import 'package:flutter/material.dart';
import 'package:mentalhealthapp/provider/user_provider.dart';
import 'package:mentalhealthapp/screens/profile_screen.dart';
import 'package:mentalhealthapp/widgets/article_card.dart';
import 'package:mentalhealthapp/widgets/meditation_music_tile.dart';
import 'package:mentalhealthapp/widgets/mood_analysis_widget.dart';
import 'package:mentalhealthapp/widgets/quote_card.dart';
import 'package:mentalhealthapp/widgets/recommendation_grid.dart';
import 'package:mentalhealthapp/widgets/gif_display.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Clariora",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
              child: CircleAvatar(
                backgroundColor: Colors.deepPurple[200],
                radius: 20,
                child: Text(
                  userProvider.userName.isNotEmpty
      ? userProvider.userName[0].toUpperCase()
      : "?",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFD8BFD8), // Lavender Mist
              Color(0xFF9370DB), // Muted Violet
              Color(0xFF6A0DAD), // Soft Royal Purple
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello, ${userProvider.userName}",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 20),
              _buildSection(
                  "Motivational Quotes",
                  QuoteCard(
                    quote: '',
                  )),
              _buildSection("Weekly Mood Analysis", MoodAnalysisWidget()),
              _buildSection("Meditation & Exercise GIFs", GifDisplay()),
              _buildSection("Meditation Music", MeditationMusicTile()),
              _buildSection("Read Articles", ArticleCard()),
              _buildSection("Movie & Book Recommendations", RecommendationGrid()),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget child) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple)),
            SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}
