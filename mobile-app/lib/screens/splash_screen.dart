import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mentalhealthapp/provider/user_provider.dart';
import 'package:mentalhealthapp/screens/dashboard_screen.dart';
import 'package:mentalhealthapp/screens/login_screen.dart';
import 'package:provider/provider.dart';

class SplashScreens extends StatefulWidget {
  const SplashScreens({super.key});

  @override
  State<SplashScreens> createState() => _SplashScreensState();
}

class _SplashScreensState extends State<SplashScreens> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      var user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        openLogin();
      } else {
        openDashboard();
      }
    });
  }

  void openDashboard() {
    Provider.of<UserProvider>(context, listen: false).getUserData();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DashboardScreen()),
    );
  }

  void openLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/splash_image.jpg', // Make sure the path is correct
            fit: BoxFit.cover, // Ensures the image covers the whole screen
          ),
        ],
      ),
    );
  }
}
