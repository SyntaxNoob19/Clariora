import 'package:flutter/material.dart';

class AboutUsTile extends StatelessWidget {
  const AboutUsTile({super.key});

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'About Clariora',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 12),

                Text(
                  'Clariora is a student-focused mental well-being platform designed to support emotional health in a safe, accessible, and stigma-free way.',
                ),

                SizedBox(height: 10),

                Text(
                  'The app helps students manage academic stress, career uncertainty, and social pressure through daily self-reflection, emotional awareness, and supportive guidance.',
                ),

                SizedBox(height: 14),

                Text(
                  'Key Features',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 8),

                Text(
                  '• Mood-based journaling with AI-driven emotional insights\n'
                  '• AI chatbot companion for empathetic, non-judgmental support\n'
                  '• Guided meditation, motivational content, and reflection prompts\n'
                  '• Personality and mood quizzes with personalized suggestions\n'
                  '• Supportive community forum for peer connection',
                ),

                SizedBox(height: 14),

                Text(
                  'Clariora is designed to encourage early emotional support and self-awareness. '
                  'It is not a substitute for professional mental health care.',
                ),

                SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('About Clariora'),
      trailing: const Icon(
        Icons.arrow_forward,
        color: Colors.deepPurple,
      ),
      onTap: () => _showBottomSheet(context),
    );
  }
}
