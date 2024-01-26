import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rupiya_finnovations_practical_test_kinjalrathod/screens/home_screen.dart';
import 'package:rupiya_finnovations_practical_test_kinjalrathod/screens/register_screen.dart';
import 'package:rupiya_finnovations_practical_test_kinjalrathod/utils/my_sharepreferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String errorMessage = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isEmailValid = true; // To track email validation

  Future<void> signinwithEmailAndPassword() async {
    try {
      await _auth
          .signInWithEmailAndPassword(
            email: _controllerEmail.text,
            password: _controllerPassword.text,
          )
          .then((value) => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false));
      setState(() {
        errorMessage = ''; // Reset the error message
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message!;
      });

      // Show the error dialog for invalid login credentials
      showErrorDialog('Invalid login credentials');
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );

      // After successfully creating the user, add their details to Firestore.
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': user.email,
          // Add other user details here as needed.
        });
      }
    } on FirebaseAuthException catch (e) {
      log(e.toString());
      setState(() {
// Update the errorMessage directly
      });
    }
  }

  loginWithEmailAndPassword() async {
    try {
      final String email = _controllerEmail.text.trim();
      final String password = _controllerPassword.text.trim();
      final userCredential = await _auth
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) {
        String userId = _auth.currentUser!.uid.toString();
        log(userId, name: "UserId__");

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false);

        MySharedPreferences.instance.setStringValue("isLogin", "true");
      });
      log(userCredential ?? "Not logged in");
    } catch (e) {
      log('Login failed: $e');
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }

  Future<void> signup(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    try {
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);

        // Getting users credential
        UserCredential result =
            await _auth.signInWithCredential(authCredential);

        if (result != null) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false);
        } // if result not null we simply call the MaterialpageRoute,
        // for go to the HomePage screen
      }
    } catch (e) {
      log(e.toString(), name: "Signin error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
                  color: Color(0xFF07689F),
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
                  color: Color(0xFFFF7E67),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Positioned(
            top: 150, // Adjust the top value to position the text
            left: 30, // Adjust the left value to position the text
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi,',
                  style: GoogleFonts.openSans(
                    // Use Google Fonts
                    color: Colors.white, // Text color
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  ),
                ),
                Text(
                  'Welcome back!',
                  style: GoogleFonts.openSans(
                    // Use Google Fonts
                    color: Colors.white, // Text color
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 150),
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
                          prefixIcon:
                              const Icon(Icons.email), // Add the icon here
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          labelStyle: GoogleFonts.openSans(),
                          errorText: isEmailValid
                              ? null
                              : 'Invalid email format', // Display error message
                        ),
                        style: GoogleFonts.openSans(),
                        onChanged: (value) {
                          // Validate email format using regex pattern
                          final emailRegex = RegExp(
                              r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
                          setState(() {
                            isEmailValid = emailRegex.hasMatch(value);
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
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
                          prefixIcon:
                              const Icon(Icons.lock), // Add the icon here
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          labelStyle: GoogleFonts.openSans(),
                        ),
                        style: GoogleFonts.openSans(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 9),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const RegisterPage();
                              },
                            ),
                          );
                        },
                        child: Text(
                          'Register Your self',
                          style: GoogleFonts.openSans(
                            // Use Google Fonts
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) {
                          //       return ForgotPasswordPage();
                          //     },
                          //   ),
                          // );
                        },
                        child: Text(
                          'Forgot Password?',
                          style: GoogleFonts.openSans(
                            // Use Google Fonts
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () async {
                      // await createUserWithEmailAndPassword();
                      if (_auth.currentUser != null) {
                        log(FirebaseAuth.instance.currentUser.toString(),
                            name: "current user");
                        loginWithEmailAndPassword();
                      } else {
                        log("User not exist");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFFFF7E67), // Adjust the primary color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(15), // Rounded corners
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 24), // Adjust padding
                      elevation: 4, // Add elevation for a raised effect
                    ),
                    child: Text(
                      'Login',
                      style: GoogleFonts.openSans(
                        fontSize: 20, // Adjust the font size
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Text color
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 1,
                        width: 150,
                        color: Colors.black.withOpacity(0.1),
                      ),
                      Text(
                        "OR",
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.3),
                        ),
                      ),
                      Container(
                        height: 1,
                        width: 150,
                        color: Colors.black.withOpacity(0.1),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      signup(context);
                    },
                    child: Material(
                      elevation: 8,
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFFCDE6F6),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/google_logo.png",
                                height: 20,
                                width: 20,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Continue with Google",
                                style: GoogleFonts.openSans(
                                    // Use Google Fonts
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              )
                            ]),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () async {
                      try {
                        final userCredential = await FirebaseAuth.instance
                            .signInAnonymously()
                            .then((value) => Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()),
                                (route) => false));
                        print("Signed in with temporary account.");
                      } on FirebaseAuthException catch (e) {
                        switch (e.code) {
                          case "operation-not-allowed":
                            print(
                                "Anonymous auth hasn't been enabled for this project.");
                            break;
                          default:
                            print("Unknown error.");
                        }
                      }
                    },
                    child: Material(
                      elevation: 8,
                      borderRadius: BorderRadius.circular(10),
                      color: const Color(0xFFCDE6F6),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.person_2_rounded,
                                color: Colors.blue,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Continue As guest",
                                style: GoogleFonts.openSans(
                                    // Use Google Fonts
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              )
                            ]),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
