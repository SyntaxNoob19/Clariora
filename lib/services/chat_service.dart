// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class ChatService {
//   static const String apiUrl =
//       "";

//   static const String apiKey =
//       ""; // Replace with your actual API key

//   static Future<String> sendMessage(String userMessage) async {
//     try {
//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {
//           "Authorization": "Bearer $apiKey",
//           "Content-Type": "application/json",
//         },
//         body: jsonEncode({
//           "messages": [
//             {"role": "user", "content": userMessage}
//           ],
//           "max_tokens": 500,
//           "model": "mistralai/mistral-7b-instruct",
//           "stream": false
//         }),
//       );

//       if (response.statusCode == 200) {
//         var data = jsonDecode(response.body);
//         return data["choices"][0]["message"]["content"];
//       } else {
//         return "Error: ${response.statusCode} - ${response.body}";
//       }
//     } catch (e) {
//       return "Failed to connect to AI service: $e";
//     }
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  static const String apiUrl = "";
  static const String apiKey =
      "";

  static Future<String> sendMessage(String userMessage, String feature) async {
    try {
      String systemPrompt = _getSystemPrompt(feature);

      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $apiKey",
        },
        body: jsonEncode({
          "model": "anthropic/claude-3-haiku",
          "messages": [
            {"role": "system", "content": systemPrompt},
            {"role": "user", "content": userMessage}
          ],
          "max_tokens": 150
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data["choices"][0]["message"]["content"] ?? "AI didn't respond.";
      } else {
        return "Error: \${response.statusCode} - \${response.body}";
      }
    } catch (e) {
      return "Failed to connect to AI service: \$e";
    }
  }

  static String _getSystemPrompt(String feature) {
    switch (feature) {
      case "chatbot":
        return "You are a friendly Indian  mental health expert and life coach. "
            "You understand Indian culture, emotions, and traditions. "
            "Your responses are warm, caring, and slightly informal. "
            "Reply in the user's language (English/Hinglish). "
            "Use friendly and natural language, like a supportive friend. "
            "Add light humor or Bollywood-style motivation when helpful. "
            "For example: 'Arre tension mat le, sab theek hoga!'";

      case "diary":
        return "You are an AI journal assistant focused on self-reflection and mental well-being. "
            "Analyze the user’s journal entry and detect their mood. "
            "Then, provide a short self-care tip or positive insight based on their emotions. "
            "Return the result in this exact format: MOOD|INSIGHT. "
            "For example: Happy|Take a moment to appreciate the good things in your day.";

      case "quiz":
        return "You are a professional personality and mood analysis expert. "
            "Analyze the user's quiz responses to assess their personality traits and emotional state. "
            "Provide a brief, insightful analysis and offer one practical suggestion for self-improvement or well-being. "
            "Keep responses concise, clear, and professional.";

      default:
        return "You are an AI assistant designed to provide helpful responses.";
    }
  }
}
