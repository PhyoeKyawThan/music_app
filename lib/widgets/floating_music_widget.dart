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
  late final MemoryImage memoryImage;
  @override
  void initState() {
    super.initState();
    final playListProvider = context.read<PlaylistProvider>();
    if (playListProvider.currentSong?.coverImage != null) {
      memoryImage = MemoryImage(playListProvider.currentSong!.coverImage!);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool _isFav = false;
    final playListProvider = context.watch<PlaylistProvider>();
    _isFav = playListProvider.currentSong?.isFav ?? false;
    void _toggleFavorite() {
      setState(() {
        _isFav = !_isFav;
      });
    }

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
                child: playListProvider.currentSong?.coverImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image(
                          image: memoryImage,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        width: 50,
                        height: 50,
                        color: Colors.grey[300],
                        child: Icon(Icons.music_note),
                      ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  "${playListProvider.currentSong?.title}",
                  style: TextStyle(color: AppColors.textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                onPressed: () async {
                  // await playListProvider.resume();
                  await playListProvider.togglePlayPause();
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
              IconButton(
                onPressed: () {
                  _toggleFavorite();
                  playListProvider.setFav(
                    context,
                    music: playListProvider.currentSong!,
                  );
                },
                icon: Icon(
                  Icons.favorite,
                  color: _isFav == true
                      ? AppColors.favorite
                      : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
