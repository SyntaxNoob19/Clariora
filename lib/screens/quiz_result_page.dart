import 'package:flutter/material.dart';
import 'package:mentalhealthapp/screens/discover_screen.dart';
import 'package:mentalhealthapp/services/chat_service.dart'; 



class QuizResultsPage extends StatefulWidget {
  final List<String> userResponses;
  final String quizType;

  const QuizResultsPage({
    super.key,
    required this.userResponses,
    required this.quizType, required String aiGeneratedText,
  });

  @override
  _QuizResultsPageState createState() => _QuizResultsPageState();
}

class _QuizResultsPageState extends State<QuizResultsPage> {
  String aiGeneratedText = "Analyzing your responses..."; // Default text

  @override
  void initState() {
    super.initState();
    fetchAIInsights();
  }

  Future<void> fetchAIInsights() async {
    String userMessage =
        "Analyze the user's quiz responses to provide personalized insights. Focus on their mood, personality traits, and growth areas. Offer supportive advice, motivation, or self-improvement tips based on their answers: ${widget.userResponses.join(", ")}";

    String response = await ChatService.sendMessage(userMessage, "quiz");

    setState(() {
      aiGeneratedText = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Quiz Results")),
      body: Padding(
  padding: const EdgeInsets.all(16.0),
  child: SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "AI Insights:",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.purple[100],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            aiGeneratedText,
            style: const TextStyle(fontSize: 16),
          ),
        ),

        const SizedBox(height: 30),
        SizedBox(
  width: double.infinity,
  child: ElevatedButton.icon(
    icon: const Icon(Icons.arrow_back),
    label: const Text("Back to Quiz"),
    style: ElevatedButton.styleFrom(
      elevation: 3,
      backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.white, 
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
           onPressed: () {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => const DiscoverYourselfPage(),
    ),
    (route) => false, // removes all previous routes
  );
},

          ),
        ),
      ],
    ),
  ),
),

    );
  }
}
