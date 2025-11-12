import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_app/constants/app_colors.dart';
import 'package:music_app/models/music.dart';
import 'package:music_app/widgets/music_list_item.dart';

class MusicList extends StatefulWidget {
  final AudioPlayer player;
  const MusicList({super.key, required this.player});
  @override
  State<MusicList> createState() => _MusicListState();
}

class _MusicListState extends State<MusicList> {
  List<Map<String, dynamic>> musicList = [
    {
      "title": "Perfect",
      "singer": "Ed Shreen",
      "coverImage": "assets/es.png",
      "duration": "2:00",
      "sourcePath": "musics/Ed Sheeran - Perfect (Official Music Video).mp3",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your favoirate musics",
          style: TextStyle(color: AppColors.textPrimary),
        ),
        backgroundColor: AppColors.primaryBackground,
      ),
      backgroundColor: AppColors.secondaryBackground,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: musicList.map((music) {
            return MusicListItem(
              music: MusicModel.toObject(music),
              player: widget.player,
            );
          }).toList(),
        ),
      ),
    );
  }
}
