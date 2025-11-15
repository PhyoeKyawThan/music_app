import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_app/constants/app_colors.dart';
import 'package:music_app/modules/change_notifier.dart';
import 'package:music_app/widgets/music_cart.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  final AudioPlayer player;

  const Home({super.key, required this.player});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final pp = context.watch<PlaylistProvider>();
    return Container(
      color: AppColors.primaryBackground,
      child: Column(
        children: [
          const Text("Recently Played"),
          // SingleChildScrollView(
          //   child: Row(
          //     children: pp.playlist.map((music) {
          //       return Row(
          //         children: [
          //           MusicCart(music: music),
          //           SizedBox(width: 10),
          //         ],
          //       );
          //     }).toList(),
          //   ),
          // ),
        ],
      ),
    );
  }
}
