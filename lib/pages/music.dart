import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_app/constants/app_colors.dart';
import 'package:music_app/models/music.dart';
import 'package:music_app/widgets/player_controls.dart';

class Music extends StatefulWidget {
  final AudioPlayer player;
  final MusicModel music;

  const Music({super.key, required this.music, required this.player});
  @override
  State<Music> createState() => _MusicState();
}

class _MusicState extends State<Music> {
  @override
  Widget build(BuildContext context) {
    final MusicModel currentMusic = widget.music;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
        ),
        backgroundColor: AppColors.primaryBackground,
        title: Text(
          "${currentMusic.title} by ${currentMusic.singer}",
          style: TextStyle(color: AppColors.textPrimary, fontSize: 18),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.favorite, color: Colors.red),
          ),
        ],
      ),
      backgroundColor: AppColors.primaryBackground,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Center(child: Image.asset("${currentMusic.coverImage}")),
          Text(
            "Playing: ${currentMusic.title}",
            style: TextStyle(color: AppColors.textPrimary),
          ),
          PlayerControls(
            player: widget.player,
            audioPath: "${widget.music.sourcePath}",
          ),
        ],
      ),
    );
  }
}
