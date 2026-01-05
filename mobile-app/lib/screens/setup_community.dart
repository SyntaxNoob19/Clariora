import 'package:cloud_firestore/cloud_firestore.dart';

final Map<String, Map<String, List<String>>> categories = {
  "Personal Growth": {
    "Motivation": ["Daily Inspiration", "Overcoming Challenges"],
    "Self-Improvement": ["Goal Setting", "Habit Building"],
    "Productivity": ["Time Management", "Focus & Deep Work"]
  },
  "Mental Health": {
    "Anxiety Support": ["Coping Strategies", "Success Stories"],
    "Depression Awareness": ["Resources", "Support Groups"],
    "Stress Management": ["Mindfulness", "Work-Life Balance"]
  },
  "Career & Education": {
    "Internship Preparation": ["Resume Tips", "Interview Prep"],
    "Study Tips": ["Exam Strategies", "Efficient Learning"],
    "Work-Life Balance": ["Remote Work", "Burnout Prevention"]
  },
  
  "Relationships & Social Life": {
    "Friendship": ["Making Friends", "Handling Conflicts"],
    "Family Support": ["Parenting", "Sibling Bond"],
    "Loneliness": ["Finding Community", "Self-Acceptance"]
  },
  "General Discussion": {
    "Open Conversations": ["Casual Talks", "Random Thoughts"],
    "Book Club": ["Recommended Reads", "Discussions"],
    "Casual Talks": ["Anything Goes", "Off-Topic Chats"]
  }
};

Future<void> initializeCommunity() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference communityCollection = firestore.collection('community');

  for (var category in categories.entries) {
    String categoryKey = category.key.toLowerCase().replaceAll(" ", "_"); // Firestore ID
    DocumentReference categoryDoc = communityCollection.doc(categoryKey);

    await categoryDoc.set({"name": category.key}); // Add Category

    for (var subcategory in category.value.entries) {
      String subcategoryKey = subcategory.key.toLowerCase().replaceAll(" ", "_");
      DocumentReference subcategoryDoc = categoryDoc.collection('subcategories').doc(subcategoryKey);

      await subcategoryDoc.set({"name": subcategory.key}); // Add Subcategory

      for (String chatroom in subcategory.value) {
        String chatroomKey = chatroom.toLowerCase().replaceAll(" ", "_");
        DocumentReference chatroomDoc = subcategoryDoc.collection('chatrooms').doc(chatroomKey);

        await chatroomDoc.set({"name": chatroom}); // Add Chatroom
      }
    }
  }
  print("Community data initialized successfully!");
}
