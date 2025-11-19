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
  @override
  void initState() {
    super.initState();
    // if (Provider.of<PlaylistProvider>(
    //   context,
    //   listen: false,
    // ).playlist.isEmpty) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PlaylistProvider>(
        context,
        listen: false,
      ).refreshSongs(reWrite: false);
    });
    // }
  }

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
      body: RefreshIndicator(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  const Icon(Icons.history, color: AppColors.textPrimary),
                  SizedBox(width: 5),
                  const Text(
                    "Recently Played",
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            pp.recentlyPlayed.isEmpty
                ? Container(
                    height: 100,
                    child: Center(
                      child: Text(
                        "No recently played songs",
                        style: TextStyle(color: AppColors.textPrimary),
                      ),
                    ),
                  )
                : SingleChildScrollView(
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
              child: Row(
                children: [
                  const Icon(Icons.favorite, color: AppColors.textPrimary),
                  SizedBox(width: 5),
                  const Text(
                    "Favorite Songs",
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Wrap(
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.start,
                  spacing: 10,
                  runSpacing: 10,
                  children: pp.favSongs.map((music) {
                    return MusicCart(music: music);
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
        onRefresh: () async {
          Provider.of<PlaylistProvider>(
            context,
            listen: false,
          ).refreshSongs(reWrite: false);
        },
      ),
      bottomNavigationBar: pp.currentSong != null
          ? FloatingMusicWidget()
          : null,
    );
  }
}
