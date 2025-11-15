import 'dart:typed_data';

class MusicModel {
  int? id;
  String? title;
  Uint8List? coverImage; // Change from String to Uint8List
  String? singer;
  String? duration;
  String? sourcePath;

  MusicModel({
    this.id,
    this.title,
    this.coverImage,
    this.singer,
    this.duration,
    this.sourcePath,
  });

  static MusicModel toObject(Map<String, dynamic> data) {
    return MusicModel(
      id: data['id'],
      title: data['title'],
      coverImage: data['coverImage'] is List
          ? Uint8List.fromList(data['coverImage'])
          : data['coverImage'],
      singer: data['singer'],
      duration: data['duration'],
      sourcePath: data['sourcePath'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'coverImage': coverImage,
      'singer': singer,
      'duration': duration,
      'sourcePath': sourcePath,
    };
  }
}
