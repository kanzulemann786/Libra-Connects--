import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libraconnects_firebase/screens/forgetpasswardscreen.dart';
import 'package:libraconnects_firebase/screens/homescreen.dart';
import 'package:libraconnects_firebase/screens/sgnupscreen.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isVisible = true;
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();

  void _login() async {
    final email = loginEmailController.text.trim();
    final password = loginPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Error', 'Please enter email and password');
      return;
    }

    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(firebaseUser.uid)
            .get();

        final username = userDoc.data()?['username'] ?? 'User';

        Get.offAll(() => Homescreen(username: username));
      } else {
        Get.snackbar('Login Failed', 'Incorrect email or password');
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Login Error', e.message ?? 'Unknown error');
    }
  }

  @override
  void dispose() {
    loginEmailController.dispose();
    loginPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final textFieldHeight = screenHeight * 0.065; // Increased height
    final buttonHeight = screenHeight * 0.065;
    final fontSize = screenWidth * 0.04;

    return Scaffold(
      backgroundColor: Colors.lightBlue.shade50,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Library Login',
          style: GoogleFonts.actor(
            color: Colors.lightBlue,
            letterSpacing: 1.5,
            fontSize: screenWidth * 0.05,
          ),
        ),
        backgroundColor: Colors.lightBlue.shade50,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.06,
          vertical: screenHeight * 0.02,
        ),
        child: Column(
          children: [
            Lottie.asset(
              'lottie/Animation - 1747221719906.json',
              height: screenHeight * 0.25,
            ),
            SizedBox(height: screenHeight * 0.03),
            _buildTextField(
              loginEmailController,
              'Email',
              Icons.email,
              false,
              textFieldHeight,
              fontSize,
            ),
            SizedBox(height: screenHeight * 0.02),
            _buildTextField(
              loginPasswordController,
              'Password',
              Icons.lock_outline,
              true,
              textFieldHeight,
              fontSize,
            ),
            SizedBox(height: screenHeight * 0.03),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
                minimumSize: Size(screenWidth * 0.5, buttonHeight),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Login',
                style: GoogleFonts.poppins(
                  fontSize: fontSize,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            TextButton(
              onPressed: () {
                Get.to(() => const ForgotPasswordScreen());
              },
              child: Text(
                'Forgot Password?',
                style: GoogleFonts.poppins(
                  color: Colors.lightBlue,
                  fontSize: fontSize,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account?",
                  style: TextStyle(fontSize: fontSize * 0.95),
                ),
                TextButton(
                  onPressed: () => Get.to(() => const SignupScreen()),
                  child: Text(
                    'Sign Up',
                    style: GoogleFonts.poppins(
                      color: Colors.lightBlue,
                      fontWeight: FontWeight.w600,
                      fontSize: fontSize,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    IconData icon, [
    bool isPassword = false,
    double? height,
    double? fontSize,
  ]) {
    return SizedBox(
      height: height ?? 60,
      child: TextField(
        controller: controller,
        obscureText: isPassword && isVisible,
        style: TextStyle(fontSize: fontSize ?? 16),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.lightBlue),
          hintText: hint,
          hintStyle: TextStyle(fontSize: fontSize ?? 16),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: EdgeInsets.symmetric(
            vertical: height != null ? height * 0.25 : 18,
            horizontal: 12,
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isVisible ? Icons.visibility_off : Icons.visibility,
                    color: Colors.lightBlue,
                  ),
                  onPressed: () {
                    setState(() {
                      isVisible = !isVisible;
                    });
                  },
                )
              : null,
        ),
      ),
    );
  }
}
