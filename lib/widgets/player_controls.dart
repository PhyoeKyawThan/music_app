import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_app/constants/app_colors.dart';

class PlayerControls extends StatefulWidget {
  final AudioPlayer player;
  final String audioPath;
  const PlayerControls({
    super.key,
    required this.player,
    required this.audioPath,
  });
  @override
  State<PlayerControls> createState() => _PlayerControlsState();
}

class _PlayerControlsState extends State<PlayerControls> {
  bool isPlaying = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.shuffle_sharp, color: AppColors.textPrimary),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.skip_previous, color: AppColors.textPrimary),
        ),
        IconButton(
          padding: EdgeInsets.all(20),
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(AppColors.primaryAccent),
          ),
          onPressed: () async {
            if (!isPlaying) {
              await widget.player.setSource(AssetSource(widget.audioPath));
              await widget.player.resume();
            } else {
              await widget.player.pause();
            }
            setState(() {
              isPlaying = !isPlaying;
            });
          },
          icon: Icon(
            isPlaying ? Icons.pause : Icons.play_arrow,
            color: AppColors.textPrimary,
          ),
        ),
        IconButton(
          onPressed: () {},
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
