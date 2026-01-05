
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mentalhealthapp/screens/splash_screen.dart';



class LoginController {
  static Future<void> createAccount(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) {
        return SplashScreens();
      }), (route) {
        return false;
      });

      print('Account created successfully');
    } catch (e) {
      SnackBar message = SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            e.toString(),
            style: TextStyle(color: Colors.white),
          ));
      ScaffoldMessenger.of(context).showSnackBar(message);
    }
  }
}
