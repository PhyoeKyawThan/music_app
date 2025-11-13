import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:music_app/models/music.dart';

class PlaylistProvider extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  List<MusicModel> _playlist = [
    MusicModel(
      id: 1,
      title: "Perfect",
      singer: "Ed Shreen",
      coverImage: "assets/es.png",
      duration: "2:00",
      sourcePath: "musics/Ed Sheeran - Perfect (Official Music Video).mp3",
    ),
    MusicModel(
      id: 2,
      title: "Shape Of you",
      singer: "Ed Shreen",
      coverImage: "assets/es_sou.png",
      duration: "2:01",
      sourcePath: "musics/Ed Sheeran - Shape of You (Official Music Video).mp3",
    ),
  ];
  int _currentIndex = 0;
  bool _isPlaying = false;

  // Getters
  List<MusicModel> get playlist => _playlist;
  MusicModel? get currentSong =>
      _playlist.isNotEmpty ? _playlist[_currentIndex] : null;
  bool get isPlaying => _isPlaying;

  // Set playlist (for example when you load all songs)
  void setPlaylist(List<MusicModel> songs) {
    _playlist = songs;
    _currentIndex = 0;
    notifyListeners();
  }

  // Play a specific song
  Future<void> playSong(int index) async {
    if (index < 0 || index >= _playlist.length) return;
    _currentIndex = index;
    await _player.play(AssetSource("${_playlist[index].sourcePath}"));
    _isPlaying = true;
    notifyListeners();
  }

  // Pause current song
  Future<void> pause() async {
    await _player.pause();
    _isPlaying = false;
    notifyListeners();
  }

  // Resume playback
  Future<void> resume() async {
    await _player.resume();
    _isPlaying = true;
    notifyListeners();
  }

  // Play next song
  Future<void> playNext() async {
    if (_playlist.isEmpty) return;
    _currentIndex = (_currentIndex + 1) % _playlist.length;
    await playSong(_currentIndex);
  }

  // Play previous song
  Future<void> playPrevious() async {
    if (_playlist.isEmpty) return;
    _currentIndex = (_currentIndex - 1 + _playlist.length) % _playlist.length;
    await playSong(_currentIndex);
  }
}
