import 'package:flutter/material.dart';
import 'package:music_app/constants/app_colors.dart';
import 'package:music_app/modules/change_notifier.dart';
import 'package:music_app/widgets/floating_music_widget.dart';
import 'package:music_app/widgets/music_cart.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     Provider.of<PlaylistProvider>(context, listen: false).refreshSongs();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final pp = context.watch<PlaylistProvider>();
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: AppBar(
        title: Text(
          "Music",
          style: TextStyle(fontSize: 18, color: AppColors.textPrimary),
        ),
        toolbarHeight: 40,
        backgroundColor: AppColors.primaryBackground,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications, color: AppColors.favorite),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: const Text(
              "Recently Played",
              style: TextStyle(color: AppColors.textPrimary, fontSize: 18),
            ),
          ),
          SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: pp.recentlyPlayed.map((music) {
                return Row(
                  children: [
                    SizedBox(width: 10),
                    MusicCart(music: music),
                    SizedBox(width: 10),
                  ],
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: const Text(
              "Favorite Musics",
              style: TextStyle(color: AppColors.textPrimary, fontSize: 18),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: pp.favSongs.map((music) {
                return Row(
                  children: [
                    SizedBox(width: 10),
                    MusicCart(music: music),
                    SizedBox(width: 10),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: pp.currentSong != null
          ? FloatingMusicWidget()
          : null,
    );
  }
}
