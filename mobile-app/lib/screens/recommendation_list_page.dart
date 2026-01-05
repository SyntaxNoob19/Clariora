import 'package:flutter/material.dart';
import 'recommendation_detail_page.dart';

class RecommendationListPage extends StatelessWidget {
  final String category;

  RecommendationListPage({super.key, required this.category});

  final Map<String, List<Map<String, String>>> recommendations = {
    "Motivational": [
      {
        "title": "The Pursuit of Happyness",
        "type": "Movie",
        "description":
            "A heartwarming story of Chris Gardner, who struggles with homelessness while raising his son and chasing his dreams."
      },
      {
        "title": "Atomic Habits",
        "type": "Book",
        "description":
            "James Clear's best-selling book on how small daily habits can lead to massive success over time."
      },
    ],
    "Relaxing": [
      {
        "title": "Eat Pray Love",
        "type": "Movie",
        "description":
            "A woman embarks on a journey across Italy, India, and Indonesia to find herself and discover true happiness."
      },
      {
        "title": "The Power of Now",
        "type": "Book",
        "description":
            "Eckhart Tolle's guide to mindfulness and living in the present moment to achieve inner peace."
      },
    ],
    "Sci-Fi": [
      {
        "title": "Interstellar",
        "type": "Movie",
        "description":
            "A breathtaking sci-fi adventure where astronauts travel through a wormhole to save humanity."
      },
      {
        "title": "Dune",
        "type": "Book",
        "description":
            "Frank Herbert's epic novel about politics, power, and survival on the desert planet Arrakis."
      },
    ],
    "Romantic": [
      {
        "title": "The Notebook",
        "type": "Movie",
        "description":
            "A timeless love story about a young couple who fall in love but face obstacles along the way."
      },
      {
        "title": "Pride and Prejudice",
        "type": "Book",
        "description":
            "Jane Austen's classic romance about Elizabeth Bennet and Mr. Darcy navigating love and societal expectations."
      },
    ],
    "Adventure": [
      {
        "title": "Indiana Jones",
        "type": "Movie",
        "description":
            "The thrilling adventures of archaeologist Indiana Jones as he searches for ancient artifacts."
      },
      {
        "title": "Into the Wild",
        "type": "Book",
        "description":
            "The true story of Christopher McCandless, who leaves behind society to live in the Alaskan wilderness."
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    final items = recommendations[category] ?? [];
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text("$category Recommendations"),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
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
        child: ListView.builder(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Center(
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                margin: EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  title: Text(
                    items[index]["title"]!,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Text(
                    items[index]["type"]!,
                    style: TextStyle(color: Colors.deepPurple, fontSize: 16),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios,
                      size: 16, color: Colors.grey[700]),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecommendationDetailPage(
                          title: items[index]["title"]!,
                          type: items[index]["type"]!,
                          description: items[index]["description"]!,
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
