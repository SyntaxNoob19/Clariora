import 'package:flutter/material.dart';
import 'package:mentalhealthapp/services/article_service.dart';
import 'package:mentalhealthapp/screens/article_detail_screen.dart';

class ArticleCard extends StatefulWidget {
  const ArticleCard({super.key});

  @override
  State<ArticleCard> createState() => _ArticleCardState();
}

class _ArticleCardState extends State<ArticleCard> {
  List<Map<String, String>> articles = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadArticles();
  }

  // Future<void> loadArticles() async {
  //   var fetchedArticles = await ArticleService().fetchArticles();
  //   setState(() {
  //     articles = fetchedArticles;
  //     isLoading = false;
  //   });
  // }

  Future<void> loadArticles() async {
    print("📢 Fetching articles...");
    var fetchedArticles = await ArticleService().fetchArticles();

    setState(() {
      articles = fetchedArticles;
      isLoading = false;
    });

    if (articles.isEmpty) {
      print("⚠️ No articles found! Something is wrong.");
    } else {
      print("✅ Loaded ${articles.length} articles.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : SizedBox(
            height: 100,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.only(right: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: InkWell(
                      onTap: () {
                        // Navigate to the article detail screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ArticleDetailScreen(
                              title: articles[index]['title']!,
                              content: articles[index]['content']!,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: 180,
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              articles[index]['title']!,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          );
  }
}
