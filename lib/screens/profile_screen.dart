import 'package:flutter/material.dart';
import 'package:mentalhealthapp/provider/user_provider.dart';
import 'package:mentalhealthapp/widgets/about_us_tile.dart';
import 'package:mentalhealthapp/widgets/delete_account_tile.dart';
import 'package:mentalhealthapp/widgets/edit_profile_tile.dart';
import 'package:mentalhealthapp/widgets/logout_tile.dart';
import 'package:mentalhealthapp/widgets/settings_tile.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.deepPurple),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFD8BFD8), // Lavender Mist
              Color(0xFF9370DB), // Muted Violet
              Color(0xFF6A0DAD), // Soft Royal Purple
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 60),
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white.withOpacity(0.3),
                child: Text(
                  userProvider.userName.isNotEmpty
      ? userProvider.userName[0].toUpperCase()
      : "?",

                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                userProvider.userName,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white),
              ),
              Text(
                userProvider.userEmail,
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    _buildTile(EditProfileTile(), Icons.edit),
                    _buildTile(SettingsTile(), Icons.settings),
                    _buildTile(AboutUsTile(), Icons.info),
                    _buildTile(LogoutTile(), Icons.exit_to_app),
                    _buildTile(DeleteAccountTile(), Icons.delete),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTile(Widget child, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.deepPurple),
        title: child,
      ),
    );
  }
}
