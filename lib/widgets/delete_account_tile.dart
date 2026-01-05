import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mentalhealthapp/screens/splash_screen.dart';

class DeleteAccountTile extends StatelessWidget {
  const DeleteAccountTile({super.key});

  @override
  Widget build(BuildContext context) {
    void showPasswordDialog(BuildContext context, User user) {
      final TextEditingController passwordController = TextEditingController();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Confirm Password"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Enter your password to delete your account."),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                String password = passwordController.text.trim();
                if (password.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Password cannot be empty!")),
                  );
                  return;
                }

                AuthCredential credential = EmailAuthProvider.credential(
                  email: user.email!,
                  password: password,
                );

                try {
                  // Re-authenticate the user
                  await user.reauthenticateWithCredential(credential);

                  // Delete user data from Firestore
                  await FirebaseFirestore.instance
                      .collection("users")
                      .doc(user.uid)
                      .delete();

                  // Delete user account
                  await user.delete();

                  // Show confirmation
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Account deleted successfully")),
                  );

                  // Navigate to splash screen immediately
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => SplashScreens()),
                    (route) => false,
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: ${e.toString()}")),
                  );
                }
              },
              child: const Text("Confirm", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
    }

    void showDeleteDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Delete Account?"),
          content: const Text(
              "This action is irreversible. Do you want to continue?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close delete dialog first
                User? user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  showPasswordDialog(context, user); // Ask for password
                }
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
    }

    return ListTile(
      title: const Text('Delete Profile'),
      trailing: const Icon(
        Icons.arrow_forward,
        color: Colors.deepPurple,
      ),
      onTap: () {
        showDeleteDialog(context);
      },
    );
  }
}
