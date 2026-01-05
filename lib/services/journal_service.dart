import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_service.dart'; 
import 'package:firebase_auth/firebase_auth.dart';


class JournalService {
static CollectionReference _journalCollection() {
  final user = FirebaseAuth.instance.currentUser;
  return FirebaseFirestore.instance
      .collection('users')
      .doc(user!.uid)
      .collection('journal_entries');
}


// Save journal entry with AI insights and mood prediction
  static Future<void> saveJournalEntry(String text) async {
    try {
      String aiResponse = await ChatService.sendMessage(text, "diary");

      // Ensure AI response is structured correctly
      Map<String, dynamic> responseData = _parseAIResponse(aiResponse);
      String rawMood = responseData['mood'] ?? "Neutral";
String mood = normalizeMood(rawMood);

      String aiInsight = responseData['insight'] ?? "No insights available.";

      await  _journalCollection().add({
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
 return _journalCollection()
    .orderBy('date', descending: true)
    .snapshots();

}


  // Delete journal entry
 static Future<void> deleteJournalEntry(String docId) async {
  await _journalCollection().doc(docId).delete();

}


  static Map<String, dynamic> _parseAIResponse(String response) {
  try {
    final cleaned = response.trim();

    // Try normal format first: MOOD|INSIGHT
    if (cleaned.contains('|')) {
      final parts = cleaned.split('|');
      return {
        "mood": parts[0].replaceAll("Mood:", "").trim(),
        "insight": parts.sublist(1).join('|').trim(),
      };
    }

    // Fallback: try to detect mood from text itself
    return {
      "mood": cleaned,
      "insight": "Take a moment to reflect and be kind to yourself.",
    };
  } catch (e) {
    return {
      "mood": "Neutral",
      "insight": "Could not analyze this entry.",
    };
  }
}

  static String normalizeMood(String rawMood) {
  final mood = rawMood.toLowerCase();

  if (mood.contains("happy") || mood.contains("joy") || mood.contains("excited")) {
    return "Happy";
  }

  if (mood.contains("sad") || mood.contains("depress") || mood.contains("low")) {
    return "Sad";
  }

  if (mood.contains("anxious") || mood.contains("anxiety") || mood.contains("worried")) {
    return "Anxious";
  }

  if (mood.contains("stress") || mood.contains("overwhelm") || mood.contains("pressure")) {
    return "Stressed";
  }

  if (mood.contains("angry") || mood.contains("frustrat") || mood.contains("irritat")) {
    return "Angry";
  }

  if (mood.contains("motivat") || mood.contains("hope") || mood.contains("positive")) {
    return "Motivated";
  }

  return "Neutral"; 
}

}
