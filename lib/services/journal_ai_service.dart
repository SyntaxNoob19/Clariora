import 'dart:convert';
import 'package:http/http.dart' as http;

class JournalAIService {
  static const String apiUrl =
      "https://openrouter.ai/api/v1/chat/completions"; // Ensure this API works

  // Analyze mood based on journal text
  static Future<String> analyzeMood(String text) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer YOUR_API_KEY"
        },
        body: jsonEncode({
          "model": "anthropic/claude-3-haiku",
          "messages": [
            {
              "role": "system",
              "content":
                  "Analyze the mood of this journal entry and return one word only (e.g., Happy, Sad, Anxious, Motivated)."
            },
            {"role": "user", "content": text}
          ],
          "max_tokens": 10
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["choices"][0]["message"]["content"].trim();
      } else {
        return "Neutral"; // Default if API fails
      }
    } catch (e) {
      return "Neutral";
    }
  }

  // Generate AI insights based on mood and text
  static Future<String> generateInsights(String text, String mood) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer YOUR_API_KEY"
        },
        body: jsonEncode({
          "model": "anthropic/claude-3-haiku",
          "messages": [
            {
              "role": "system",
              "content":
                  "Based on this mood ('$mood'), provide a short self-care tip or positive insight for the user. Keep it concise and encouraging."
            },
            {"role": "user", "content": text}
          ],
          "max_tokens": 100
        }),
      );

      print("AI Insights Response: ${response.body}"); // Debugging

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["choices"][0]["message"]["content"].trim();
      } else {
        return "No insights available.";
      }
    } catch (e) {
      print("AI Insights Error: $e");
      return "No insights available.";
    }
  }
}
