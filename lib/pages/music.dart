// import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_app/constants/app_colors.dart';
import 'package:music_app/models/music.dart';
import 'package:music_app/modules/change_notifier.dart';
import 'package:music_app/widgets/player_controls.dart';
import 'package:provider/provider.dart';

class Music extends StatefulWidget {
  // final AudioPlayer player;
  final MusicModel? music;

  // const Music({super.key, required this.music, required this.player});
  const Music({super.key, required this.music});

  @override
  State<Music> createState() => _MusicState();
}

class _MusicState extends State<Music> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final playListProvider = context.read<PlaylistProvider>();
      playListProvider.playSong(widget.music!.id!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final playListProvider = context.watch<PlaylistProvider>();

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
          "${playListProvider.currentSong?.title} by ${playListProvider.currentSong?.singer}",
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
          Center(
            child: playListProvider.currentSong?.coverImage == null
                ? Container(
                    width: 400,
                    height: 500,
                    color: Colors.grey[300],
                    child: Icon(Icons.music_note),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.memory(
                      playListProvider.currentSong!.coverImage!,
                      width: 300,
                      height: 400,
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
          Text(
            "Playing: ${playListProvider.currentSong?.title}",
            style: TextStyle(color: AppColors.textPrimary),
          ),
          PlayerControls(
            // player: ,
            // audioPath: "${playListProvider.currentSong?.sourcePath}",
          ),
        ],
      ),
    );
  }
}
