import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libraconnects_firebase/screens/homescreen.dart';
import 'package:lottie/lottie.dart';

class UpdateScreen extends StatefulWidget {
  final String? bookname, authorName, price, edition, imageUrl, docid;

  const UpdateScreen({
    required this.bookname,
    required this.authorName,
    required this.price,
    required this.edition,
    required this.imageUrl,
    required this.docid,
    super.key,
    required String username,
  });

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  late TextEditingController bookNameController;
  late TextEditingController authorNameController;
  late TextEditingController bookPriceController;
  late TextEditingController bookEditionController;
  late TextEditingController imageUrlController;
  String? username;

  @override
  void initState() {
    super.initState();
    bookNameController = TextEditingController(text: widget.bookname);
    authorNameController = TextEditingController(text: widget.authorName);
    bookPriceController = TextEditingController(text: widget.price);
    bookEditionController = TextEditingController(text: widget.edition);
    imageUrlController = TextEditingController(text: widget.imageUrl);
    // Fix username assignment if needed; for now null-safe
    username = '';
  }

  void updateData() async {
    await FirebaseFirestore.instance
        .collection("Books")
        .doc(widget.docid)
        .update({
          'Book Name': bookNameController.text.trim(),
          'Author Name': authorNameController.text.trim(),
          'Book Price': bookPriceController.text.trim(),
          'Book Edition': bookEditionController.text.trim(),
          'Image URL': imageUrlController.text.trim(),
        });

    Get.snackbar('Success', 'Book Updated Successfully');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => Homescreen(username: username ?? '')),
    );
  }

  Widget buildField(
    String label,
    TextEditingController controller,
    double fontSize,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        style: TextStyle(fontSize: fontSize * 0.8),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: fontSize * 0.9),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: EdgeInsets.symmetric(
            vertical: fontSize * 0.6,
            horizontal: fontSize * 0.8,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final screenWidth = mq.size.width;
    final screenHeight = mq.size.height;

    final double baseFontSize = screenWidth * 0.036;
    final double horizontalPadding = screenWidth * 0.07;

    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[50],
        elevation: 0,
        title: Text(
          'Update Book',
          style: GoogleFonts.aBeeZee(
            fontSize: baseFontSize * 1.2,
            color: Colors.lightBlue,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: screenHeight * 0.03,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(
              'lottie/Animation - 1748020844135.json',
              height: screenHeight * 0.18,
              width: screenWidth * 0.36,
              fit: BoxFit.contain,
            ),
            SizedBox(height: screenHeight * 0.025),
            buildField('Book Name', bookNameController, baseFontSize),
            buildField('Author Name', authorNameController, baseFontSize),
            buildField('Book Price', bookPriceController, baseFontSize),
            buildField('Book Edition', bookEditionController, baseFontSize),
            buildField('Image URL', imageUrlController, baseFontSize),
            SizedBox(height: screenHeight * 0.03),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: updateData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                child: Text(
                  'Update Book',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: baseFontSize * 1.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
