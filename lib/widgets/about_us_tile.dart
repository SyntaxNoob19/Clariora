import 'package:flutter/material.dart';

class AboutUsTile extends StatefulWidget {
  const AboutUsTile({super.key});

  @override
  State<AboutUsTile> createState() => _AboutUsTileState();
}

class _AboutUsTileState extends State<AboutUsTile> {
  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text('About This App',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 20),
              Text(
                  'Welcome to Clariora – your personal mental wellness companion. Our app is designed to support young adults navigating the challenges of early adulthood, including self-discovery, relationships, career stress, and emotional well-being.'),
              SizedBox(height: 20),
              Text(
                'Key Features',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                  '🧠 AI-Powered Emotional Support – Get personalized responses based on your mood and thoughts.'),
              Text(
                  '💬 Anonymous Community Chat – Connect with others facing similar challenges in a safe and supportive space.'),
              Text(
                  '📖 Virtual Journal & Reflection – Write down your thoughts and get supportive insights.'),
              Text(
                  '📺 Interactive Learning – Explore animations, videos, articles, and meditation music to enhance your self-growth journey.'),
              SizedBox(height: 20),
              Text(
                  'At Clariora , we believe mental health matters, and small steps can make a big difference. Take control of your well-being, one day at a time. 💜'),
              SizedBox(height: 30),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('About App'),
      trailing: Icon(
        Icons.arrow_forward,
        color: Colors.deepPurple,
      ),
      onTap: () {
        showBottomSheet(context);
      },
    );
  }
}
