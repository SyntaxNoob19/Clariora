import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class GifDisplay extends StatelessWidget {
  final List<String> meditationGifs = [
    'assets/gifs/meditation1.gif',
    'assets/gifs/meditation2.gif',
    'assets/gifs/meditation3.gif',
  ];

  final List<String> breathingGifs = [
    'assets/gifs/breathing1.gif',
    'assets/gifs/breathing2.gif',
    'assets/gifs/breathing3.gif',
  ];

  final List<String> yogaGifs = [
    'assets/gifs/yoga1.gif',
    'assets/gifs/yoga2.gif',
    'assets/gifs/yoga3.gif',
  ];

   GifDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCategory(context, "Meditation", meditationGifs),
        _buildCategory(context, "Breathing Exercises", breathingGifs),
        _buildCategory(context, "Yoga", yogaGifs),
      ],
    );
  }

  Widget _buildCategory(BuildContext context, String title, List<String> gifList) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            spreadRadius: 2,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
            ),
          ),
          CarouselSlider(
            options: CarouselOptions(
              height: 160,
              enlargeCenterPage: true,
              autoPlay: true,
              aspectRatio: 16 / 9,
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: Duration(milliseconds: 1000),
              viewportFraction: 0.7,
            ),
            items: gifList.map((gifPath) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        spreadRadius: 1,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Image.asset(gifPath, fit: BoxFit.cover, width: 160, height: 160),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
