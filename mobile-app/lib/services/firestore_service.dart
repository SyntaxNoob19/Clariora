import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> initializeCategories() async {
    List<Map<String, dynamic>> categories = [
      {
        "name": "Mental Health & Well-being",
        "chatrooms": ["Stress & Anxiety", "Mindfulness & Self-Care"]
      },
      {
        "name": "Career & Productivity",
        "chatrooms": ["Job Hunting & Interviews", "Time Management & Focus"]
      },
      {
        "name": "Relationships & Social Life",
        "chatrooms": ["Friendships & Social Anxiety", "Dating & Love Life"]
      },
      {
        "name": "Personal Growth & Motivation ",
        "chatrooms": ["Building Good Habits", "Overcoming Procrastination"]
      },
    ];

    for (var category in categories) {
      var categoryQuery = await _firestore
          .collection('categories')
          .where('name', isEqualTo: category['name'])
          .get();

      if (categoryQuery.docs.isEmpty) {
        // Only add if category does NOT exist
        var categoryRef = await _firestore
            .collection('categories')
            .add({"name": category['name']});

        // Add chatrooms inside the category
        for (var chatroom in category['chatrooms']) {
          await categoryRef.collection('chatrooms').add({"name": chatroom});
        }
      }
    }
  }
}
