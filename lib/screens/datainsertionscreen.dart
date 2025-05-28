import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class DataInsertionScreen extends StatefulWidget {
  const DataInsertionScreen({super.key});

  @override
  State<DataInsertionScreen> createState() => _DataInsertionScreenState();
}

class _DataInsertionScreenState extends State<DataInsertionScreen> {
  final TextEditingController bookNameController = TextEditingController();
  final TextEditingController authorNameController = TextEditingController();
  final TextEditingController bookPriceController = TextEditingController();
  final TextEditingController bookEditionController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();

  void insertData() async {
    if (bookNameController.text.isEmpty ||
        authorNameController.text.isEmpty ||
        bookPriceController.text.isEmpty ||
        bookEditionController.text.isEmpty) {
      Get.snackbar('Error', 'All fields are required');
      return;
    }

    await FirebaseFirestore.instance.collection("Books").add({
      'Book Name': bookNameController.text.trim(),
      'Author Name': authorNameController.text.trim(),
      'Book Price': bookPriceController.text.trim(),
      'Book Edition': bookEditionController.text.trim(),
      'Image URL': imageUrlController.text.trim(),
    });

    Get.snackbar('Success', 'Book Added Successfully');
    Navigator.pop(context);
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

    final double baseFontSize = screenWidth * 0.035;
    final double horizontalPadding = screenWidth * 0.08;

    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[50],
        elevation: 0,
        title: Text(
          'Add New Book',
          style: GoogleFonts.aBeeZee(
            fontSize: baseFontSize * 1.4,
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
          vertical: screenHeight * 0.025,
        ),
        child: Column(
          children: [
            Lottie.asset(
              'lottie/Animation - 1748018605560.json',
              height: screenHeight * 0.22,
              width: screenWidth * 0.45,
              fit: BoxFit.contain,
            ),
            buildField('Book Name', bookNameController, baseFontSize),
            buildField('Author Name', authorNameController, baseFontSize),
            buildField('Book Price', bookPriceController, baseFontSize),
            buildField('Book Edition', bookEditionController, baseFontSize),
            buildField('Image URL', imageUrlController, baseFontSize),
            SizedBox(height: screenHeight * 0.03),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: insertData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
                child: Text(
                  'Insert Book',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: baseFontSize * 0.95,
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
