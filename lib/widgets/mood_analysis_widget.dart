import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class MoodAnalysisWidget extends StatelessWidget {
  const MoodAnalysisWidget({super.key});

  Future<Map<String, int>> _fetchMoodData() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('journal_entries')
        .orderBy('date', descending: true)
        .limit(7)
        .get();

    Map<String, int> moodCount = {};

    for (var doc in snapshot.docs) {
      String mood = doc['mood'] ?? "Neutral";
      moodCount[mood] = (moodCount[mood] ?? 0) + 1;
    }

    return moodCount;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, int>>(
      future: _fetchMoodData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        Map<String, int> moodData = snapshot.data!;
        List<PieChartSectionData> pieChartSections = [];

        moodData.forEach((mood, count) {
          pieChartSections.add(PieChartSectionData(
            value: count.toDouble(),
            title: "$count",
            color: _getMoodColor(mood),
            radius: 50,
            titleStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ));
        });

        return Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                SizedBox(height: 10),
                Column(
                  children: moodData.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.circle,
                                  color: _getMoodColor(entry.key), size: 12),
                              SizedBox(width: 8),
                              Text(entry.key, style: TextStyle(fontSize: 16)),
                            ],
                          ),
                          Text("${entry.value} days",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
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

  // Function to get different colors based on mood
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
