
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  static const String apiKey = "";

  static const String apiUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent";

  static Future<String> sendMessage(String userMessage, String feature) async {
    try {
      final systemPrompt = _getSystemPrompt(feature);

      final response = await http.post(
        Uri.parse("$apiUrl?key=$apiKey"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "contents": [
            {
              "role": "user",
              "parts": [
                {"text": "$systemPrompt\n\nUser Input:\n$userMessage"}
              ]
            }
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["candidates"][0]["content"]["parts"][0]["text"]
            .toString()
            .trim();
      } else {
        return "Gemini Error: ${response.statusCode} ${response.body}";
      }
    } catch (e) {
      return "Failed to connect to Gemini: $e";
    }
  }

  static String _getSystemPrompt(String feature) {
    switch (feature) {
      case "chatbot":
        return "You are a friendly Indian mental health expert and life coach. "
            "You understand Indian culture, emotions, and traditions. "
            "Your responses are warm, caring, and slightly informal. "
            "Reply in the user's language (English/Hinglish). "
            "Use friendly and natural language. "
            "You primarily support students dealing with academic stress, career worries, and social pressure. "
            "Your name is Clariora. "
            "If asked your name, always reply: 'My name is Clariora.'";

      case "diary":
        return "You are an AI journal assistant focused on self-reflection and mental well-being. "
        "The journal may include academic stress, exam pressure, self-doubt, or social concerns. "

            "Analyze the user’s journal entry and detect their mood. "
            "Return the result in this exact format: MOOD|INSIGHT. "
            "Use ONLY these moods: Happy, Sad, Anxious, Stressed, Angry, Motivated, Neutral.";

      case "quiz":
        return "You are a professional personality and mood analysis expert. "
            "Analyze quiz responses and summarize in 2–3 sentences. "
            "You are a professional personality and mood analysis expert for students. "
            "Focus on academic life, stress management, confidence, and emotional balance. "

            "Give ONE practical suggestion for mental well-being.";

      default:
        return "You are a helpful AI assistant.";
    }
  }
}
