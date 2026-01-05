import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mentalhealthapp/provider/user_provider.dart';
import 'package:provider/provider.dart';

class EditProfileTile extends StatefulWidget {
  const EditProfileTile({super.key});

  @override
  State<EditProfileTile> createState() => _EditProfileTileState();
}

class _EditProfileTileState extends State<EditProfileTile> {
  TextEditingController changeName = TextEditingController();
  TextEditingController changePassword = TextEditingController();
  TextEditingController currentPassword = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool _obscureText = true;

  void showBottomSheet(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    changeName.text = userProvider.userName ?? "";
    changePassword.clear();
    currentPassword.clear();

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Edit Profile",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: changeName,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Username can not be empty';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        labelText: 'Edit Username',
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    obscureText: _obscureText,
                    controller: currentPassword,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureText
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                        labelText: 'Current Password ',
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    obscureText: _obscureText,
                    controller: changePassword,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        labelText: 'New Password ',
                        suffixIcon: IconButton(
                          icon: Icon(_obscureText
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 30),
                  isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () => updateProfile(userProvider),
                          child: Text('Update Profile'))
                ],
              ),
            ),
          );
        });
  }

  Future<void> updateProfile(UserProvider userProvider) async {
    if (!formKey.currentState!.validate()) return;

    setState(() => isLoading = true);
    String userId = userProvider.userId;

    if (userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: User ID is missing")),
      );
      setState(() => isLoading = false);
      return;
    }
    Map<String, dynamic> updateData = {'name': changeName.text};

    try {
      // Update Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update(updateData);

      // Update Provider state
      userProvider.getUserData();

      // Update Firebase Authentication password if entered
      User? user = FirebaseAuth.instance.currentUser;

      if (changePassword.text.isNotEmpty) {
        if (user != null && currentPassword.text.isNotEmpty) {
          // Re-authenticate the user
          AuthCredential credential = EmailAuthProvider.credential(
            email: user.email!,
            password: currentPassword.text,
          );
          await user.reauthenticateWithCredential(credential);
          // Now update the password
          await user.updatePassword(changePassword.text);
        } else {
          throw Exception("Current password is required to update password");
        }
      }
      if (mounted) Navigator.pop(context); // Close Bottom Sheet
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Profile updated successfully!")),
      );
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close Bottom Sheet in case of error
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text('Edit Profile'),
        // leading: Icon(Icons.edit),
      trailing: Icon(Icons.arrow_forward,color:Colors.deepPurple ,),
        
        onTap: () {
          showBottomSheet(context);
        });
  }
}
