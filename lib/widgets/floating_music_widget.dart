import 'package:flutter/material.dart';
import 'package:music_app/constants/app_colors.dart';
import 'package:music_app/modules/change_notifier.dart';
import 'package:music_app/pages/music.dart';
import 'package:provider/provider.dart';

class FloatingMusicWidget extends StatefulWidget {
  const FloatingMusicWidget({super.key});

  @override
  State<FloatingMusicWidget> createState() => _FloatingMusicWidgetState();
}

class _FloatingMusicWidgetState extends State<FloatingMusicWidget> {
  @override
  Widget build(BuildContext context) {
    final playListProvider = context.watch<PlaylistProvider>();
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Music(music: playListProvider.currentSong),
          ),
        );
      },
      child: DecoratedBox(
        decoration: BoxDecoration(color: AppColors.divider),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  "${playListProvider.currentSong?.coverImage}",
                  width: 70,
                  height: 50,
                ),
              ),
              Expanded(
                child: Text(
                  "${playListProvider.currentSong?.title}",
                  style: TextStyle(color: AppColors.textPrimary),
                ),
              ),
              IconButton(
                onPressed: () async {
                  if (playListProvider.isPlaying) {
                    await playListProvider.pause();
                  } else {
                    await playListProvider.resume();
                  }
                },
                icon: Icon(
                  playListProvider.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: AppColors.favorite,
                ),
              ),
              IconButton(
                onPressed: () async {
                  await playListProvider.playNext();
                },
                icon: Icon(Icons.skip_next, color: AppColors.favorite),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
