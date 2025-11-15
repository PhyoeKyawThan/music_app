import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:music_app/models/music.dart';
import 'package:music_app/modules/audio_from_storage_handler.dart';
import 'dart:async';

class PlaylistProvider extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  List<MusicModel> _playlist = [];
  int _currentIndex = 0;
  bool _isPlaying = false;
  bool _isLoading = false;

  // Getters
  List<MusicModel> get playlist => _playlist;
  MusicModel? get currentSong =>
      _playlist.isNotEmpty ? _playlist[_currentIndex] : null;
  bool get isPlaying => _isPlaying;
  bool get isLoading => _isLoading;

  PlaylistProvider() {
    _initializePlayer();
    _loadDeviceSongs();
  }

  void _initializePlayer() {
    _player.onPlayerComplete.listen((_) {
      playNext();
    });

    _player.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.playing) {
        _isPlaying = true;
      } else if (state == PlayerState.paused) {
        _isPlaying = false;
      }
      notifyListeners();
    });
  }

  // Load songs from device
  Future<void> _loadDeviceSongs() async {
    _isLoading = true;
    notifyListeners();

    try {
      final songs = await AudioService.getSongsSafe();
      if (songs.isNotEmpty) {
        _playlist = songs;
        print("Loaded ${_playlist.length} songs from device");
      }
      _playlist = [];
    } catch (e) {
      print("Error loading songs: $e");
      _playlist = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Default fallback playlist
  List<MusicModel> _getDefaultPlaylist() {
    return [
      MusicModel(
        id: 1,
        title: "Perfect",
        singer: "Ed Shreen",
        coverImage: null,
        duration: "2:00",
        sourcePath: "musics/Ed Sheeran - Perfect (Official Music Video).mp3",
      ),
      MusicModel(
        id: 2,
        title: "Shape Of you",
        singer: "Ed Shreen",
        coverImage: null,
        duration: "2:01",
        sourcePath:
            "musics/Ed Sheeran - Shape of You (Official Music Video).mp3",
      ),
    ];
  }

  // Refresh songs from device
  Future<void> refreshSongs() async {
    await _loadDeviceSongs();
  }

  // Set custom playlist
  void setPlaylist(List<MusicModel> songs) {
    _playlist = songs;
    _currentIndex = 0;
    _isPlaying = false;
    notifyListeners();
  }

  // Play a specific song
  Future<void> playSong(int index) async {
    if (index < 0 || index >= _playlist.length) return;

    _currentIndex = index;
    final song = _playlist[index];
    print(song.id);
    try {
      // Use DeviceFileSource for actual device files
      await _player.play(DeviceFileSource(song.sourcePath!));
      _isPlaying = true;
      print("Is device");
      notifyListeners();
    } catch (e) {
      print("Error playing song: $e");
      // Fallback to AssetSource if DeviceFileSource fails
      try {
        await _player.play(AssetSource(song.sourcePath!));
        _isPlaying = true;
        notifyListeners();
      } catch (e2) {
        print("Error with asset source: $e2");
      }
    }
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

  // Toggle play/pause
  Future<void> togglePlayPause() async {
    if (_isPlaying) {
      await pause();
    } else {
      if (currentSong != null) {
        await resume();
      } else if (_playlist.isNotEmpty) {
        await playSong(_currentIndex);
      }
    }
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

  // Seek to position
  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  // Get current position stream
  Stream<Duration> get positionStream => _player.onPositionChanged;

  // Get duration of current song
  Future<Duration?> get duration async {
    return _player.getDuration();
  }

  // Dispose player
  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
