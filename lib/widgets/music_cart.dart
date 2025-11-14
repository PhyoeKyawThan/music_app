import 'package:flutter/material.dart';
import 'package:music_app/constants/app_colors.dart';
import 'package:music_app/models/music.dart';

class MusicCart extends StatelessWidget {
  final MusicModel music;
  const MusicCart({super.key, required this.music});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.secondaryBackground,
      width: 100,
      height: 130,
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(10),
              child: Image.asset("${music.coverImage}", width: 90, height: 100),
            ),
            Text(
              "${music.title}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
