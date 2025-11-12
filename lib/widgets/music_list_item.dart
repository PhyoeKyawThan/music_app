import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_app/constants/app_colors.dart';
import 'package:music_app/models/music.dart';
import 'package:music_app/pages/music.dart';

class MusicListItem extends StatelessWidget {
  final MusicModel music;
  final AudioPlayer player;

  const MusicListItem({super.key, required this.music, required this.player});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Music(music: music, player: player),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset("${music.coverImage}", width: 70, height: 60),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${music.title}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  "${music.singer}",
                  style: TextStyle(color: AppColors.textPrimary),
                ),
                Text(
                  "Duration: ${music.duration}",
                  style: TextStyle(color: AppColors.textPrimary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
