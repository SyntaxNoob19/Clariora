import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mentalhealthapp/screens/category_screen.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Community",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
        elevation: 2,
      ),
      body: Container(
        decoration: const BoxDecoration(
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
        child: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('categories').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  "No categories available",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              );
            }

            var categories = snapshot.data!.docs;
            List<String> seenCategories = [];
            var uniqueCategories = categories.where((doc) {
              String categoryName = doc['name'];
              if (seenCategories.contains(categoryName)) return false;
              seenCategories.add(categoryName);
              return true;
            }).toList();

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Join a Community",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView.separated(
                      itemCount: uniqueCategories.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        var category = uniqueCategories[index];
                        String categoryName = category['name'];
                        IconData iconData = _getCategoryIcon(categoryName);

                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                          shadowColor: Colors.black45,
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 16),
                            leading: Icon(iconData,
                                color: Color(0xFF6A0DAD), size: 28),
                            title: Text(
                              categoryName,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios,
                                color: Color(0xFF6A0DAD)),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CategoryScreen(categoryId: category.id),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'mental health & well-being':
        return Icons.self_improvement;
      case 'career & productivity':
        return Icons.work;
      case 'relationships & social life':
        return Icons.favorite;
      case 'personal growth & motivation':
        return Icons.trending_up;
      default:
        return Icons.category;
    }
  }
}
