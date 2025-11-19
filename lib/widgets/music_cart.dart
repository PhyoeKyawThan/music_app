import 'package:flutter/material.dart';
import 'package:music_app/constants/app_colors.dart';
import 'package:music_app/models/music.dart';
import 'package:music_app/pages/music.dart';

class MusicCart extends StatefulWidget {
  final MusicModel music;
  const MusicCart({super.key, required this.music});
  @override
  State<StatefulWidget> createState() {
    return _MusicCartState();
  }
}

class _MusicCartState extends State<MusicCart> {
  late final MemoryImage memoryImage;
  @override
  void initState() {
    super.initState();
    memoryImage = MemoryImage(widget.music.coverImage!);
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
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(10),
        child: Container(
          color: const Color.fromARGB(255, 10, 13, 65),
          width: 100,
          height: 160,
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(10),
                  child: music.coverImage != null
                      ? Image(
                          image: memoryImage,
                          width: 100,
                          height: 120,
                          fit: BoxFit.cover,
                        )
                      : Icon(
                          Icons.music_note,
                          size: 100,
                          color: AppColors.primaryAccent,
                        ),
                ),
                // SizedBox(height: 10),
                Text(
                  "${music.title}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
