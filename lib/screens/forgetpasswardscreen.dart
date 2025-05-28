import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libraconnects_firebase/screens/loginscreen.dart';
import 'package:lottie/lottie.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController inputController = TextEditingController();

  Future<void> resetPassword() async {
    String input = inputController.text.trim();
    String? emailToReset;

    try {
      if (input.contains('@') && input.contains('.')) {
        emailToReset = input;
      } else {
        QuerySnapshot usersSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('username', isEqualTo: input)
            .get();

        if (usersSnapshot.docs.isEmpty) {
          usersSnapshot = await FirebaseFirestore.instance
              .collection('users')
              .where('phone', isEqualTo: input)
              .get();
        }

        if (usersSnapshot.docs.isNotEmpty) {
          emailToReset = usersSnapshot.docs.first['email'];
        }
      }

      if (emailToReset != null) {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: emailToReset);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(
              child: Text('Password reset link sent to $emailToReset'),
            ),
            backgroundColor: Colors.lightBlue,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Center(
              child: Text('No user found with that email, username, or phone.'),
            ),
            backgroundColor: Color.fromARGB(255, 113, 201, 241),
          ),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong. Try again.'),
          backgroundColor: Colors.lightBlue,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery for responsive sizing
    final mq = MediaQuery.of(context);
    final screenWidth = mq.size.width;
    final screenHeight = mq.size.height;

    // Define smaller sizes relative to screen width
    final horizontalPadding = screenWidth * 0.1; // 10% padding left and right
    final lottieHeight = screenHeight * 0.25; // 25% of height
    final fontSizeText = screenWidth * 0.04; // ~16 at 400 width
    final fontSizeLink = screenWidth * 0.032; // ~13 at 400 width
    final textFieldFontSize = screenWidth * 0.035; // smaller font
    final buttonFontSize = screenWidth * 0.04; // slightly smaller button text
    final buttonVerticalPadding =
        screenHeight * 0.015; // smaller vertical padding
    final buttonHorizontalPadding =
        screenWidth * 0.05; // smaller horizontal padding
    final borderRadius = 12.0;

    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: Text(
          'Forgot Password',
          style: GoogleFonts.actor(
            color: Colors.lightBlue,
            letterSpacing: 1.5,
            fontSize: fontSizeText + 2,
          ),
        ),
        backgroundColor: Colors.lightBlue[50],
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
        ).copyWith(top: 40),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Lottie.asset('lottie/Fy5L6YCPXn.json', height: lottieHeight),
              SizedBox(height: screenHeight * 0.03),
              Text(
                "Enter your email, phone, or username and \nwe'll send you a link to get back into your account.",
                style: GoogleFonts.poppins(fontSize: fontSizeText),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.025),
              TextField(
                controller: inputController,
                style: TextStyle(fontSize: textFieldFontSize),
                decoration: InputDecoration(
                  labelText: 'Email / Username / Phone',
                  labelStyle: TextStyle(fontSize: textFieldFontSize),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 167, 165, 165),
                      width: 0.5,
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.person_outline,
                    size: textFieldFontSize + 4,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.015,
                    horizontal: 15,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.025),
              ElevatedButton.icon(
                icon: Icon(Icons.send, size: buttonFontSize + 4),
                label: Text(
                  "Send Reset Link",
                  style: TextStyle(fontSize: buttonFontSize),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  padding: EdgeInsets.symmetric(
                    horizontal: buttonHorizontalPadding,
                    vertical: buttonVerticalPadding,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                ),
                onPressed: resetPassword,
              ),
              SizedBox(height: screenHeight * 0.04),
              Container(
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: const Color.fromARGB(255, 114, 114, 114),
                      width: 0.9,
                    ),
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    Get.offAll(() => const LoginScreen());
                  },
                  child: Text(
                    "Remembered your password? Login",
                    style: GoogleFonts.aBeeZee(fontSize: fontSizeLink),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
