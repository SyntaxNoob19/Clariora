import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String userName = 'dummy';
  String userEmail = 'dummy';
  String userId = 'dummy';
  String userCountry = 'dummy';

  var db = FirebaseFirestore.instance;

  void getUserData() {
    var authUser = FirebaseAuth.instance.currentUser;
    db.collection('users').doc(authUser!.uid).get().then((dataSnapshot) {
      userName = dataSnapshot.data()?['name'] ?? '';
      userEmail = dataSnapshot.data()?['email'] ?? '';
      userId = dataSnapshot.data()?['id'] ?? '';
      userCountry = dataSnapshot.data()?['country'] ?? '';
      notifyListeners();
    });
  }
}
