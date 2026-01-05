import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class MeditationMusicTile extends StatefulWidget {
  const MeditationMusicTile({super.key});

  @override
  _MeditationMusicTileState createState() => _MeditationMusicTileState();
}

class _MeditationMusicTileState extends State<MeditationMusicTile> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? currentTrack;
  bool isPlaying = false;

  final List<Map<String, String>> meditationTracks = [
    {'title': 'Soothing Waves', 'path': 'music/meditation1.mp3'},
    {'title': 'Deep Relaxation', 'path': 'music/meditation2.mp3'},
    {'title': 'Mindful Serenity', 'path': 'music/meditation3.mp3'},
  ];

  Future<void> _togglePlayPause(String trackPath) async {
    if (isPlaying && currentTrack == trackPath) {
      await _audioPlayer.pause();
      setState(() => isPlaying = false);
    } else {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(trackPath));
      setState(() {
        isPlaying = true;
        currentTrack = trackPath;
      });
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
        ),
        SizedBox(height: 8),
        for (var track in meditationTracks)
          Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Icon(Icons.music_note,
                  color: Colors.purple.shade700, size: 30),
              title: Text(
                track['title']!,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              trailing: IconButton(
                icon: Icon(
                  isPlaying && currentTrack == track['path']
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_fill,
                  size: 32,
                  color: Colors.deepPurpleAccent,
                ),
                onPressed: () => _togglePlayPause(track['path']!),
              ),
            ),
          ),
      ],
    );
  }
}
