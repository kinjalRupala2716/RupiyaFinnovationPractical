// ignore_for_file: unused_local_variable

import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rupiya_finnovations_practical_test_kinjalrathod/screens/app_screen/home_screen.dart';
import 'package:rupiya_finnovations_practical_test_kinjalrathod/utils/my_sharepreferences.dart';
// import 'package:encrypt/encrypt.dart' as encrypt;

class RegisterPage extends StatefulWidget {
  // final VoidCallback showLoginPage;
  const RegisterPage({
    Key? key,
    // required this.showLoginPage,
  }) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool showContactSection = false;
  String errorMessage = '';
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CameraDescription? camera;

  bool isEmailValid = true;

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    _controllerName.dispose();
    super.dispose();
  }

  registerWithEmailAndPassword() async {
    try {
      final String email = _controllerEmail.text.trim();
      final String password = _controllerPassword.text.trim();
      final userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        String userId = _auth.currentUser!.uid.toString();
        MySharedPreferences.instance.setStringValue("uId", userId);
        final user = FirebaseAuth.instance.currentUser;

        if (user != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'uid': user.uid,
            'name': _controllerName.text.trim(),
            'email': user.email,
            // Add other user details here as needed.
          });
        }
        // loginWithEmailAndPassword();
      });
      // log(userCredential);
    } catch (e) {
      log('registration failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned(
              top: -270,
              left: -50,
              right: 0,
              child: Material(
                elevation: 8,
                shape: const CircleBorder(),
                child: Container(
                  width: 760,
                  height: 680,
                  decoration: const BoxDecoration(
                    color: Color(0xFFA2D5F2),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            Positioned(
              top: -80,
              left: -80,
              child: Material(
                elevation: 8,
                shape: const CircleBorder(),
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF7E67),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 90,
              right: -90,
              child: Material(
                elevation: 8,
                shape: const CircleBorder(),
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: const BoxDecoration(
                    color: Color(0xFF07689F),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 150,
              left: 30,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hi,',
                    style: GoogleFonts.openSans(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),
                  Text(
                    'New User!',
                    style: GoogleFonts.openSans(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(left: 30, top: 30),
                child: Positioned(
                    child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.5)),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 30,
                      )),
                ))),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (!showContactSection)
                      Column(
                        children: [
                          const SizedBox(height: 300),
                          Material(
                            elevation: 8,
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xFFCDE6F6),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextField(
                                controller: _controllerName,
                                decoration: InputDecoration(
                                  labelText: 'Name',
                                  prefixIcon: const Icon(Icons.person),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  labelStyle: GoogleFonts.openSans(),
                                ),
                                style: GoogleFonts.openSans(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Material(
                            elevation: 8,
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xFFCDE6F6),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextField(
                                controller: _controllerEmail,
                                decoration: InputDecoration(
                                  labelText: 'Email Address',
                                  prefixIcon: const Icon(Icons.email),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  labelStyle: GoogleFonts.openSans(),
                                  errorText: isEmailValid
                                      ? null
                                      : 'Invalid email format',
                                ),
                                style: GoogleFonts.openSans(),
                                onChanged: (value) {
                                  final emailRegex = RegExp(
                                      r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
                                  setState(() {
                                    isEmailValid = emailRegex.hasMatch(value);
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Material(
                            elevation: 8,
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xFFCDE6F6),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextField(
                                controller: _controllerPassword,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon: const Icon(Icons.lock),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  labelStyle: GoogleFonts.openSans(),
                                ),
                                style: GoogleFonts.openSans(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            child: errorMessage.isNotEmpty
                                ? Text(
                                    errorMessage,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 14, // Adjust the font size
                                    ),
                                  )
                                : const SizedBox
                                    .shrink(), // Hide the error message container if no error message
                          ),
                          const SizedBox(height: 24),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              onPressed: () async {
                                // registerWithEmailAndPassword();
                                await _auth
                                    .createUserWithEmailAndPassword(
                                        email: _controllerEmail.text,
                                        password: _controllerPassword.text)
                                    .then((value) => _auth
                                        .signInWithEmailAndPassword(
                                            email: _controllerEmail.text,
                                            password: _controllerPassword.text)
                                        .then((value) =>
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const HomeScreen()),
                                                (route) => false)));
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(
                                    0xFFFF7E67), // Adjust the primary color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      15), // Rounded corners
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 9,
                                    horizontal: 24), // Adjust padding
                                elevation:
                                    4, // Add elevation for a raised effect
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Next ',
                                    style: GoogleFonts.openSans(
                                      fontSize: 15, // Adjust the font size
                                      fontWeight: FontWeight.bold,
                                      color: const Color.fromRGBO(
                                          255, 255, 255, 1), // Text color
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white, // Icon color
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
