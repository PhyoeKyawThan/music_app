import 'package:flutter/material.dart';
import 'package:music_app/constants/app_colors.dart';
import 'package:music_app/models/music.dart';
import 'package:music_app/modules/change_notifier.dart';
import 'package:music_app/widgets/floating_music_widget.dart';
import 'package:music_app/widgets/music_list_item.dart';
import 'package:provider/provider.dart';

class MusicList extends StatefulWidget {
  // final AudioPlayer player;
  const MusicList({super.key});
  @override
  State<MusicList> createState() => _MusicListState();
}

class _MusicListState extends State<MusicList> {
  @override
  void initState() {
    super.initState();
    if (Provider.of<PlaylistProvider>(
      context,
      listen: false,
    ).playlist.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<PlaylistProvider>(
          context,
          listen: false,
        ).refreshSongs(reWrite: false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final playListProvider = context.watch<PlaylistProvider>();
    List<MusicModel> playList = playListProvider.playlist;
    int totalSong = playList.length;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your favorite musics ($totalSong)",
          style: TextStyle(color: AppColors.textPrimary),
        ),
        backgroundColor: AppColors.primaryBackground,
      ),
      backgroundColor: AppColors.secondaryBackground,
      body: RefreshIndicator(
        child: ListView.builder(
          itemCount: playListProvider.playlist.length,
          itemBuilder: (context, index) {
            return MusicListItem(music: playList[index]);
          },
        ),
        onRefresh: () async {
          Provider.of<PlaylistProvider>(
            context,
            listen: false,
          ).refreshSongs(reWrite: false);
        },
      ),
      bottomNavigationBar: playListProvider.currentSong != null
          ? FloatingMusicWidget()
          : null,
    );
  }
}
