import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_app/modules/change_notifier.dart';
import 'package:music_app/pages/home.dart';
import 'package:music_app/pages/music_lists.dart';
import 'package:music_app/widgets/bottom_navigation.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => PlaylistProvider(),
      child: MaterialApp(home: View()),
    ),
  );
}

class View extends StatefulWidget {
  const View({super.key});
  @override
  State<View> createState() => _ViewState();
}

class _ViewState extends State<View> {
  late AudioPlayer player = AudioPlayer();
  int _currentIndex = 0;

  void _handleView(index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    player = AudioPlayer();

    player.setReleaseMode(ReleaseMode.stop);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await player.resume();
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  List<Widget> get _pages => [Home(player: player), MusicList()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: _pages[_currentIndex],
      bottomNavigationBar: CustomNagivationBar(
        currentIndex: _currentIndex,
        onTap: (index) => _handleView(index),
      ),
    );
  }
}
