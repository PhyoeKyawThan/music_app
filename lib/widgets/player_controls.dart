import 'package:flutter/material.dart';
import 'package:music_app/constants/app_colors.dart';
import 'package:music_app/modules/change_notifier.dart';
import 'package:provider/provider.dart';

class PlayerControls extends StatefulWidget {
  // final AudioPlayer player;
  // final String audioPath;
  const PlayerControls({
    super.key,
    // required this.player,
    // required this.audioPath,
  });
  @override
  State<PlayerControls> createState() => _PlayerControlsState();
}

class _PlayerControlsState extends State<PlayerControls> {
  @override
  Widget build(BuildContext context) {
    final playListProvider = context.watch<PlaylistProvider>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.shuffle_sharp, color: AppColors.textPrimary),
        ),
        IconButton(
          onPressed: () {
            playListProvider.playPrevious();
          },
          icon: Icon(Icons.skip_previous, color: AppColors.textPrimary),
        ),
        IconButton(
          padding: EdgeInsets.all(20),
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(AppColors.primaryAccent),
          ),
          onPressed: () async {
            if (playListProvider.isPlaying) {
              await playListProvider.pause();
            } else {
              await playListProvider.resume();
            }
          },
          icon: Icon(
            playListProvider.isPlaying ? Icons.pause : Icons.play_arrow,
            color: AppColors.textPrimary,
          ),
        ),
        IconButton(
          onPressed: () {
            playListProvider.playNext();
          },
          icon: Icon(Icons.skip_next, color: AppColors.textPrimary),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.loop, color: AppColors.textPrimary),
        ),
      ],
    );
  }
}
