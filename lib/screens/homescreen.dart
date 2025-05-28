import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libraconnects_firebase/screens/datainsertionscreen.dart';
import 'package:libraconnects_firebase/screens/forgetpasswardscreen.dart';
import 'package:libraconnects_firebase/screens/loginscreen.dart';
import 'package:libraconnects_firebase/screens/updatescreen.dart';
import 'package:lottie/lottie.dart';

final user = FirebaseAuth.instance.currentUser;

class Homescreen extends StatefulWidget {
  final String username;
  const Homescreen({super.key, required this.username});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchText = '';

  // Adjustable font size for snackbar messages
  final double snackbarFontSize = 14.0;

  @override
  Widget build(BuildContext context) {
    // MediaQuery for responsive sizes
    final mq = MediaQuery.of(context);
    final screenWidth = mq.size.width;
    final screenHeight = mq.size.height;

    // Responsive font sizes
    final titleFontSize = screenWidth * 0.05;
    final subtitleFontSize = screenWidth * 0.035;
    final drawerHeaderFontSize = screenWidth * 0.04;
    final listTitleFontSize = screenWidth * 0.04;
    final listSubtitleFontSize = screenWidth * 0.032;
    final noDataFontSize =
        screenWidth * 0.07; // Smaller font for no data message

    // Responsive card size
    final cardImageWidth = screenWidth * 0.15;
    final cardImageHeight = screenHeight * 0.12;

    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      drawer: SizedBox(
        width: screenWidth * 0.6, // Smaller drawer width (~60%)
        child: _buildDrawer(drawerHeaderFontSize),
      ),
      appBar: AppBar(
        title: Text(
          'Library Management System',
          style: GoogleFonts.aBeeZee(
            fontSize: screenWidth * 0.032,
            color: Colors.lightBlue,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlue[50],
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DataInsertionScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Lottie.asset(
            'lottie/Animation - 1748017496150 (1).json',
            height: screenHeight * 0.1,
            width: screenWidth * 0.4,
          ),
          SizedBox(height: screenHeight * 0.015),
          Padding(
            padding: EdgeInsets.only(left: screenWidth * 0.05),
            child: Row(
              children: [
                SizedBox(width: screenWidth * 0.1),
                Flexible(
                  child: Text(
                    'Manage your library with ease',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.actor(
                      fontSize: subtitleFontSize * 0.8,
                      letterSpacing: 1.5,
                      color: const Color.fromARGB(255, 37, 14, 22),
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.05),
                Icon(Icons.forward, color: Colors.lightBlue),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
              vertical: screenHeight * 0.012,
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  searchText = value.trim().toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search by Book Name...',
                prefixIcon: Icon(Icons.search, color: Colors.lightBlue),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.03,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              style: TextStyle(fontSize: subtitleFontSize),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Books")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      "No books found.",
                      style: GoogleFonts.tangerine(fontSize: noDataFontSize),
                    ),
                  );
                }

                final allBooks = snapshot.data!.docs;
                final filteredBooks = allBooks.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final name = (data['Book Name'] ?? '')
                      .toString()
                      .toLowerCase();
                  return name.contains(searchText);
                }).toList();

                return ListView.builder(
                  itemCount: filteredBooks.length,
                  itemBuilder: (context, index) {
                    final book = filteredBooks[index];
                    final data = book.data() as Map<String, dynamic>;

                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.04,
                        vertical: screenHeight * 0.01,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(screenWidth * 0.025),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            data['Image URL'] ?? '',
                            width: cardImageWidth,
                            height: cardImageHeight,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                Icon(Icons.broken_image, size: cardImageWidth),
                          ),
                        ),
                        title: Text(
                          data['Book Name'] ?? 'Unknown',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: listTitleFontSize * 0.76,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Author: ${data['Author Name'] ?? 'Unknown'}",
                              style: TextStyle(fontSize: listSubtitleFontSize),
                            ),
                            Text(
                              "Price: ${data['Book Price'] ?? 'N/A'}",
                              style: TextStyle(fontSize: listSubtitleFontSize),
                            ),
                            Text(
                              "Edition: ${data['Book Edition'] ?? 'N/A'}",
                              style: TextStyle(fontSize: listSubtitleFontSize),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Colors.lightBlue,
                                size: screenWidth * 0.063,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UpdateScreen(
                                      bookname: data['Book Name'],
                                      authorName: data['Author Name'],
                                      price: data['Book Price'],
                                      edition: data['Book Edition'],
                                      imageUrl: data['Image URL'],
                                      docid: book.id,
                                      username: widget.username,
                                    ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.blue,
                                size: screenWidth * 0.063,
                              ),
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection('Books')
                                    .doc(book.id)
                                    .delete();
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(double drawerHeaderFontSize) {
    return Drawer(
      backgroundColor: Colors.lightBlue[50],
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 110, 204, 248),
            ),
            child: Text.rich(
              TextSpan(
                text: 'Welcome Dear,\n',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  letterSpacing: 1.5,
                  fontSize: drawerHeaderFontSize * 0.8,
                ),
                children: [
                  TextSpan(
                    text: widget.username,
                    style: GoogleFonts.aBeeZee(
                      letterSpacing: 1.5,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: drawerHeaderFontSize,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home', style: TextStyle(fontSize: 15)),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Homescreen(username: widget.username),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock_reset),
            title: const Text(
              'Forgot Password',
              style: TextStyle(fontSize: 15),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ForgotPasswordScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout', style: TextStyle(fontSize: 15)),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About', style: TextStyle(fontSize: 15)),
            onTap: () {
              Get.snackbar(
                'About Us',
                'This is a library management system.\nYou can add, update, and delete books easily.\nDeveloped by: KANZ UL EMAN\nVersion: 1.0',
                duration: const Duration(seconds: 5),
                backgroundColor: Colors.lightBlue[50],
                colorText: Colors.black,
                icon: const Icon(Icons.info, color: Colors.blue),
                snackPosition: SnackPosition.BOTTOM,
                margin: const EdgeInsets.all(12),
                messageText: Text(
                  'This is a library management system.\nYou can add, update, and delete books easily.\nDeveloped by: KANZ UL EMAN\nVersion: 1.0',
                  style: TextStyle(fontSize: snackbarFontSize),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('Contact Us', style: TextStyle(fontSize: 15)),
            onTap: () {
              Get.snackbar(
                'Contact Us',
                'Email: kanz@example.com\nPhone: +1234567890\nAddress: 123 Library St.',
                duration: const Duration(seconds: 5),
                backgroundColor: Colors.lightBlue[50],
                colorText: Colors.black,
                icon: const Icon(Icons.phone, color: Colors.blue),
                snackPosition: SnackPosition.BOTTOM,
                margin: const EdgeInsets.all(12),
                messageText: Text(
                  'Email: kanz@example.com\nPhone: +1234567890\nAddress: 123 Library St.',
                  style: TextStyle(fontSize: snackbarFontSize),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
