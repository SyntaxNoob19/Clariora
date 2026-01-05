import 'package:cloud_firestore/cloud_firestore.dart';

class ArticleService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

 Future<List<Map<String, String>>> fetchArticles() async {
  try {
    QuerySnapshot snapshot = await _db.collection('articles').get();

    if (snapshot.docs.isEmpty) {
      print("No articles found! Firestore collection might be empty.");
      return [];
    }

    for (var doc in snapshot.docs) {
      print("Raw Firestore data: ${doc.data()}");  // Debugging Line
    }

    return snapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>?;

      if (data == null) {
        print("Data is null for document: ${doc.id}");
        return {'title': 'Untitled', 'content': 'No content available'};
      }

      return {
        'title': data['title']?.toString() ?? 'Untitled',  
        'content': data['content']?.toString() ?? 'No content available',
      };
    }).toList();
  } catch (e) {
    print("Error fetching articles: $e");
    return [];
  }
}

}
