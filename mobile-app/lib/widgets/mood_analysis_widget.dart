import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MoodAnalysisWidget extends StatelessWidget {
  const MoodAnalysisWidget({super.key});

  Future<Map<String, int>> _fetchMoodData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return {};
    }

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('journal_entries')
        .orderBy('date', descending: true)
        .limit(7)
        .get();

    Map<String, int> moodCount = {};

    for (var doc in snapshot.docs) {
      final mood = doc['mood'] ?? "Neutral";
      moodCount[mood] = (moodCount[mood] ?? 0) + 1;
    }

    return moodCount;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, int>>(
      future: _fetchMoodData(),
      builder: (context, snapshot) {
        // 1. Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // 2. Error state
        if (snapshot.hasError) {
          return const Center(
            child: Text(
              "Failed to load mood data",
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        //  3. No data / null
        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(
            child: Text(
              "No mood data available",
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        //  4. Empty journal
        if (snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              "No mood data yet. Start journaling!",
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        // SAFE to use data now
        final Map<String, int> moodData = snapshot.data!;
        List<PieChartSectionData> pieChartSections = [];

        moodData.forEach((mood, count) {
          pieChartSections.add(
            PieChartSectionData(
              value: count.toDouble(),
              title: "$count",
              color: _getMoodColor(mood),
              radius: 50,
              titleStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        });

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                  height: 180,
                  child: PieChart(
                    PieChartData(
                      sections: pieChartSections,
                      borderData: FlBorderData(show: false),
                      centerSpaceRadius: 40,
                      sectionsSpace: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Column(
                  children: moodData.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.circle,
                                color: _getMoodColor(entry.key),
                                size: 12,
                              ),
                              const SizedBox(width: 8),
                              Text(entry.key),
                            ],
                          ),
                          Text("${entry.value} days"),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getMoodColor(String mood) {
    switch (mood.toLowerCase()) {
      case "happy":
        return Colors.yellow.shade700;
      case "sad":
        return Colors.blue.shade700;
      case "angry":
        return Colors.red.shade700;
      case "anxious":
        return Colors.orange.shade700;
      case "neutral":
        return Colors.grey;
      default:
        return Colors.deepPurple;
    }
  }
}
