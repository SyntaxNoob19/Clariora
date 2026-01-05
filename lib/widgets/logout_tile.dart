import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mentalhealthapp/screens/splash_screen.dart';

class LogoutTile extends StatefulWidget {
  const LogoutTile({super.key});

  @override
  State<LogoutTile> createState() => _LogoutTileState();
}

class _LogoutTileState extends State<LogoutTile> {
  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Logout"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); 

              await FirebaseAuth.instance.signOut();

             
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Logged out successfully"),
                  duration: Duration(seconds: 2),
                ),
              );

               
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => SplashScreens()),
                (route) => false,
              );
            },
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('Logout'),
      trailing: Icon(Icons.arrow_forward,color:Colors.deepPurple ,),

     
      onTap: () {
        showLogoutDialog(context);
      },
    );
  }
}
