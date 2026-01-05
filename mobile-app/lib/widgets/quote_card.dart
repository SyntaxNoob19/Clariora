import 'package:flutter/material.dart';
import 'package:mentalhealthapp/services/quote_service.dart';

class QuoteCard extends StatefulWidget {
  const QuoteCard({super.key, required String quote});

  @override
  State<QuoteCard> createState() => _QuoteCardState();
}

class _QuoteCardState extends State<QuoteCard> {
  String quote = "Fetching an inspiring quote...";
  String author = "";


  @override
  void initState() {
    super.initState();
    loadQuote();
    
  }

  Future<void> loadQuote() async {
    var newQuote = await QuoteService.fetchQuote();

    setState(() {
    quote = newQuote['quote']!;
     author = newQuote['author']!;
     
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
                height: 250,
                child: SingleChildScrollView(
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Text(
                                  '"$quote"',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontStyle: FontStyle.italic),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Text(
                                  '- $author',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          
                        ],
                      ),
                    ),
                  ),
                  
                ),
              );
  }
}