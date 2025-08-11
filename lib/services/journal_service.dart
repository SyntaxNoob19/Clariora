// journal_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_service.dart'; // Ensure this is correctly implemented

class JournalService {
  static final CollectionReference _journalCollection =
      FirebaseFirestore.instance.collection('journal_entries');

  // Save journal entry with AI insights and mood prediction
  static Future<void> saveJournalEntry(String text) async {
    try {
      String aiResponse = await ChatService.sendMessage(text, "diary");

      // Ensure AI response is structured correctly
      Map<String, dynamic> responseData = _parseAIResponse(aiResponse);
      String mood = responseData['mood'] ?? "Neutral"; // Default to Neutral
      String aiInsight = responseData['insight'] ?? "No insights available.";

      await _journalCollection.add({
        "text": text,
        "mood": mood,
        "date": Timestamp.now(),
        "ai_insights": aiInsight,
      });
    } catch (e) {
      print("Error saving journal entry: $e");
    }
  }

  // Fetch journal entries
  static Stream<QuerySnapshot> getJournalEntries() {
    return _journalCollection.orderBy('date', descending: true).snapshots();
  }

  // Delete journal entry
  static Future<void> deleteJournalEntry(String docId) async {
    await _journalCollection.doc(docId).delete();
  }

  // Helper function to parse AI response (Assumes response is JSON formatted)
  static Map<String, dynamic> _parseAIResponse(String response) {
    try {
      final parts = response.split('|'); // Ensure AI response format is correct
      if (parts.length < 2) {
        return {"mood": "Neutral", "insight": "Invalid AI response."};
      }
      return {
        "mood": parts[0].trim(), // Extract AI-detected mood
        "insight": parts[1].trim() // Extract AI insight
      };
    } catch (e) {
      print("Error parsing AI response: $e");
      return {"mood": "Neutral", "insight": "Could not analyze."};
    }
  }
}
