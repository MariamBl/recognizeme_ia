import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recognizeme_ia/Authentification/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Login extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _storeUserData(User? user) async {
    if (user != null) {
      // Assuming you have user information to store, replace this with your own logic
      Map<String, dynamic> userData = {
        'uid': user.uid,
        'email': user.email,
        'anniversaire': '',
        'adresse': '',
        'code_postal': '',
        'ville': '',
        // Add other user details as needed
      };

      // Store user information in Firestore
      try {
        await _firestore.collection('users').doc(user.uid).set(userData);
      } catch (e) {
        print('Error storing user data: $e');
        // Handle error while storing user data
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Center(child: Text('MiageD')), // Center the text
      //   backgroundColor: Colors.blue, // Set the color of the app bar
      // ),
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final user = snapshot.data;
            if (user != null) {
              // Store user data in Firestore upon successful login
              _storeUserData(user);
              return HomePage();
            } else {
              return SignInScreen();
            }
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
