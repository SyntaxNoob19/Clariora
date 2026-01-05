import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'quiz_result_page.dart';
import '../services/chat_service.dart';

class QuizQuestionPage extends StatefulWidget {
  final String quizType;

  const QuizQuestionPage({super.key, required this.quizType});

  @override
  _QuizQuestionPageState createState() => _QuizQuestionPageState();
}

class _QuizQuestionPageState extends State<QuizQuestionPage> {
  List<Map<String, dynamic>> questions = [];
  int currentQuestionIndex = 0;
  String? selectedAnswer;
  List<String> userResponses = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("quizzes")
          .doc(widget.quizType)
          .collection("questions")
          .get();

      if (!mounted) return;

      setState(() {
        questions = querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      });
    } catch (error) {
      if (mounted) {
        setState(() {
          questions = [];
        });
      }
    }
  }

  void nextQuestion() async {
    if (selectedAnswer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select an answer before proceeding!"),
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
        ),
      );
      return;
    }

    userResponses.add(selectedAnswer!);

    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswer = null;
      });
    } else {
      setState(() {
        isLoading = true;
      });

      String aiGeneratedText = await ChatService.sendMessage(
        "Analyze the user's quiz responses to provide personalized insights. Focus on their mood, personality traits, and growth areas. Offer supportive advice, motivation, or self-improvement tips based on their answers.",
        "quiz",
      );

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuizResultsPage(
            userResponses: userResponses,
            aiGeneratedText: aiGeneratedText,
            quizType: widget.quizType,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    if (questions.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    Map<String, dynamic> currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Quiz"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFD8BFD8),
              const Color(0xFF9370DB),
              const Color(0xFF6A0DAD),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                LinearProgressIndicator(
                  value: (currentQuestionIndex + 1) / questions.length,
                  backgroundColor: Colors.purple.shade100,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.deepPurpleAccent),
                ),
                const SizedBox(height: 16),
                Text(
                  "Question ${currentQuestionIndex + 1} of ${questions.length}",
                  style:
                      theme.textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  color: isDarkMode ? Colors.grey[900] : Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentQuestion['text'],
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Column(
                          children:
                              (currentQuestion['options'] as List<dynamic>)
                                  .map((option) {
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: selectedAnswer == option
                                    ? Colors.purple.shade100
                                    : isDarkMode
                                        ? Colors.grey[800]
                                        : Colors.white,
                                border: Border.all(
                                  color: selectedAnswer == option
                                      ? Colors.deepPurple
                                      : Colors.grey.shade300,
                                ),
                              ),
                              child: RadioListTile<String>(
                                title: Text(option,
                                    style: theme.textTheme.bodyMedium),
                                value: option,
                                groupValue: selectedAnswer,
                                activeColor: Colors.deepPurple,
                                onChanged: (value) {
                                  setState(() {
                                    selectedAnswer = value;
                                  });
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : nextQuestion,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      backgroundColor: Colors.deepPurpleAccent,
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            currentQuestionIndex == questions.length - 1
                                ? "See Results"
                                : "Next",
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
