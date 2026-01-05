import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mentalhealthapp/screens/chatroom_screen.dart';

class CategoryScreen extends StatelessWidget {
  final String categoryId;

  const CategoryScreen({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Chatrooms",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
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
        child: SafeArea(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('categories')
                .doc(categoryId)
                .collection('chatrooms')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              var chatrooms = snapshot.data!.docs;

              if (chatrooms.isEmpty) {
                return const Center(
                  child: Text(
                    "No chatrooms available.",
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: ListView.separated(
                  itemCount: chatrooms.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    var chatroom = chatrooms[index];
                    String chatroomName = chatroom['name'];
                    IconData iconData = _getSubcategoryIcon(chatroomName);

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      color: isDarkMode
                          ? Colors.grey[900]
                          : Colors.white.withOpacity(0.95),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 18),
                        leading: Icon(
                          iconData,
                          color:  Colors.deepPurple,
                        ),
                        title: Text(
                          chatroomName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.deepPurple,
                          size: 18,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatroomScreen(
                                categoryId: categoryId,
                                chatroomId: chatroom.id,
                                chatroomName: chatroomName,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  IconData _getSubcategoryIcon(String subcategoryName) {
    switch (subcategoryName.toLowerCase()) {
      case 'stress & anxiety':
        return Icons.error_outline;
      case 'mindfulness & self-care':
        return Icons.nature_people;
      case 'job hunting & interviews':
        return Icons.business_center;
      case 'time management & focus':
        return Icons.timer;
      case 'friendships & social anxiety':
        return Icons.people;
      case 'dating & love life':
        return Icons.favorite;
      case 'building good habits':
        return Icons.check_circle;
      case 'overcoming procrastination':
        return Icons.done;
      default:
        return Icons.chat_bubble_outline;
    }
  }
}
