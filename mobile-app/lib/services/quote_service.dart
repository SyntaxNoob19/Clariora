import 'dart:convert';
import 'package:http/http.dart' as http;

class QuoteService {
  static Future<Map<String, String>> fetchQuote() async {
    final url = Uri.parse('http://api.quotable.io/random?tags=motivational');
    try {
      final response = await http.get(url);
      print("API Status Code: ${response.statusCode}"); // Debugging
      print("API Response Body: ${response.body}"); // Debugging

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          "quote": data["content"] ?? "No quote available",
          "author": data["author"] ?? "Unknown"
        };
      } else {
        throw Exception("Failed to load quote");
      }
    } catch (e) {
      print("Error fetching quote: $e"); // Debugging
      return {
        "quote": "Stay positive and keep moving forward!",
        "author": "Unknown"
      };
    }
  }
}
