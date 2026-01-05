import 'package:cloud_firestore/cloud_firestore.dart';

class QuizService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addQuizQuestions() async {
    Map<String, List<Map<String, dynamic>>> quizzes = {
      "mood_quiz": [
        {"text": "How do you feel right now?", "options": ["Happy", "Sad", "Anxious", "Calm"]},
        {"text": "How was your sleep last night?", "options": ["Great", "Okay", "Poor", "Barely Slept"]},
        {"text": "What describes your energy level today?", "options": ["High", "Normal", "Low", "Drained"]},
        {"text": "How do you feel about socializing today?", "options": ["Excited", "Neutral", "Avoiding", "Overwhelmed"]},
        {"text": "Do you feel motivated to work on your goals today?", "options": ["Very", "Somewhat", "Not really", "Not at all"]},
        {"text": "How do you handle stress currently?", "options": ["Stay calm", "Feel overwhelmed", "Seek support", "Ignore it"]},
        {"text": "What emotion do you feel most today?", "options": ["Joy", "Anxiety", "Frustration", "Peace"]},
        {"text": "Are you finding it easy to focus today?", "options": ["Yes", "Somewhat", "No", "Very Distracted"]},
      ],
      "personality_quiz": [
        {"text": "How do you prefer to spend your free time?", "options": ["With friends", "Alone", "Learning something new", "Relaxing"]},
        {"text": "How do you make decisions?", "options": ["Instinct", "Logic", "Emotion", "Advice from others"]},
        {"text": "What describes your work style?", "options": ["Organized", "Flexible", "Spontaneous", "Perfectionist"]},
        {"text": "How do you handle challenges?", "options": ["Face them head-on", "Get help", "Avoid them", "Feel stuck"]},
        {"text": "What motivates you the most?", "options": ["Success", "Helping others", "Learning", "Freedom"]},
        {"text": "How do you handle failure?", "options": ["Learn from it", "Feel discouraged", "Ignore it", "Try again"]},
        {"text": "How do you usually express emotions?", "options": ["Openly", "Privately", "With actions", "I suppress them"]},
        {"text": "Do you prefer structured plans or spontaneity?", "options": ["Plans", "A mix of both", "Spontaneous", "Depends on the situation"]},
      ]
    };

    for (String quizName in quizzes.keys) {
      CollectionReference questionsRef = _firestore.collection("quizzes").doc(quizName).collection("questions");
      for (var i = 0; i < quizzes[quizName]!.length; i++) {
        await questionsRef.doc("question_${i + 1}").set(quizzes[quizName]![i]);
      }
    }
    print(" Quiz questions uploaded to Firestore!");
  }
}
