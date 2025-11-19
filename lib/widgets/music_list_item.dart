import 'package:flutter/material.dart';
import 'package:music_app/constants/app_colors.dart';
import 'package:music_app/models/music.dart';
import 'package:music_app/pages/music.dart';

class MusicListItem extends StatefulWidget {
  final MusicModel music;

  const MusicListItem({super.key, required this.music});

  @override
  State<MusicListItem> createState() => _MusicListItemState();
}

class _MusicListItemState extends State<MusicListItem> {
  late final MemoryImage? memoryImage;

  @override
  void initState() {
    super.initState();
    memoryImage = widget.music.coverImage != null
        ? MemoryImage(widget.music.coverImage!)
        : null;
  }

  @override
  Widget build(BuildContext context) {
    final MusicModel music = widget.music;
    return InkWell(
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => Music(music: music)));
      },
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: music.coverImage != null
                  ? Image(
                      image: memoryImage!,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 70,
                      height: 70,
                      color: Colors.grey[300],
                      child: Icon(Icons.music_note),
                    ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${music.title}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "${music.singer}",
                    style: TextStyle(color: AppColors.textPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "Duration: ${music.duration}",
                    style: TextStyle(color: AppColors.textPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                print(music.isFav);
              },
              icon: Icon(Icons.favorite),
              color: music.isFav == true
                  ? AppColors.favorite
                  : AppColors.textPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
