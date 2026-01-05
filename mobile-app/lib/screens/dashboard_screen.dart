import 'package:flutter/material.dart';
import 'package:mentalhealthapp/provider/user_provider.dart';
import 'package:mentalhealthapp/screens/chatbot_screen.dart';
import 'package:mentalhealthapp/screens/community_screen.dart';
import 'package:mentalhealthapp/screens/discover_screen.dart';
import 'package:mentalhealthapp/screens/home_screen.dart';
import 'package:mentalhealthapp/screens/journal_screen.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);

    List<Widget> pages = [
      HomeScreen(),
      JournalScreen(),
      DiscoverYourselfPage(),
      ChatScreen(),
      CommunityScreen()
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Journal'),
          BottomNavigationBarItem(
              icon: Icon(Icons.psychology), label: 'Discover'),
          BottomNavigationBarItem(
              icon: Icon(Icons.smart_toy), label: 'Chatbot'),
          BottomNavigationBarItem(icon: Icon(Icons.forum), label: 'Communnity'),
        ],
      ),
    );
  }
}
