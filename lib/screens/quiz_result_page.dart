import 'package:flutter/material.dart';
import 'package:mentalhealthapp/services/chat_service.dart'; // Assuming ChatService is here

class QuizResultsPage extends StatefulWidget {
  final List<String> userResponses;
  final String quizType;

  const QuizResultsPage({
    Key? key,
    required this.userResponses,
    required this.quizType, required String aiGeneratedText,
  }) : super(key: key);

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
        child: SingleChildScrollView( // ✅ Added Scrollable View
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
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
            ],
          ),
        ),
      ),
    );
  }
}
