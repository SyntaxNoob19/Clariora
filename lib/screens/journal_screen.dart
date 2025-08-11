import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mentalhealthapp/services/journal_service.dart';

class JournalScreen extends StatefulWidget {
  @override
  _JournalScreenState createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Detect system theme
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text("My Journal"),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFD8BFD8), // Lavender Mist
              Color(0xFF9370DB), // Muted Violet
              Color(0xFF6A0DAD), // Soft Royal Purple
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: StreamBuilder(
          stream: JournalService.getJournalEntries(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            var entries = snapshot.data!.docs;
            return ListView.builder(
              padding:
                  EdgeInsets.only(top: 80, left: 16, right: 16, bottom: 16),
              itemCount: entries.length,
              itemBuilder: (context, index) {
                var entry = entries[index];
                DateTime entryDate = entry['date'].toDate();
                String formattedDate =
                    DateFormat('yyyy-MM-dd – kk:mm').format(entryDate);
                String mood = entry['mood'] ?? "Neutral";
                String aiInsights =
                    entry['ai_insights'] ?? "No AI insights available.";

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: EdgeInsets.symmetric(vertical: 10),
                  elevation: 4,
                  shadowColor: Colors.black26,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry['text'],
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(height: 8),

                        // Date
                        Text(
                          "🗓 Date: $formattedDate",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),

                        // Mood (On a Separate Line)
                        Text(
                          "😃 Mood: $mood",
                          style: TextStyle(fontSize: 14, color: Colors.blue),
                        ),

                        SizedBox(height: 6),
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "🧠 AI Insights: $aiInsights",
                            style:
                                TextStyle(color: Colors.purple, fontSize: 14),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteJournalEntry(entry.id),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddJournalEntryDialog,
        backgroundColor: Color(0xFF6A0DAD),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddJournalEntryDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text("New Journal Entry"),
          content: TextField(
            controller: _textController,
            decoration: InputDecoration(
              hintText: "Write your thoughts here...",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              filled: true,
              fillColor: Color(0xFFD8BFD8),
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6A0DAD),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () async {
                if (_textController.text.isNotEmpty) {
                  await JournalService.saveJournalEntry(_textController.text);
                  _textController.clear();
                  Navigator.pop(context);
                }
              },
              child: Text(
                "Save",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteJournalEntry(String docId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirm Deletion"),
          content: Text("Are you sure you want to delete this journal entry?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close dialog
              child: Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                await JournalService.deleteJournalEntry(docId);
                Navigator.pop(context); // Close dialog after deletion
              },
              child: Text("Delete", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
