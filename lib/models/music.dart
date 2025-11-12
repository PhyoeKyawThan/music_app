class MusicModel {
  String? title;
  String? coverImage;
  String? singer;
  String? duration;
  String? sourcePath;

  MusicModel({
    this.title,
    this.coverImage,
    this.singer,
    this.duration,
    this.sourcePath,
  });

  static MusicModel toObject(Map<String, dynamic> data) {
    return MusicModel(
      title: data['title'],
      coverImage: data['coverImage'],
      singer: data['singer'],
      duration: data['duration'],
      sourcePath: data['sourcePath'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'coverImage': coverImage,
      'singer': singer,
      'duration': duration,
      'sourcePath': sourcePath,
    };
  }
}
