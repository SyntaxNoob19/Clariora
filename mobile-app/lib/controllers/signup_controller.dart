import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:mentalhealthapp/screens/splash_screen.dart';

class SignupController {
  static Future<void> createAccount(
      {required String email,
      required String password,
      required String name,
      required BuildContext context}) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      var userid = FirebaseAuth.instance.currentUser!.uid;
      var db = FirebaseFirestore.instance;

      Map<String, dynamic> data = {
        'name': name,
        'email': email,
        'id': userid.toString()
      };
      try {
        await db.collection('users').doc(userid.toString()).set(data);
      } catch (e) {
        print(e);
      }

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
