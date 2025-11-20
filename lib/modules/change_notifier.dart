import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_app/models/music.dart';
import 'package:music_app/modules/audio_from_storage_handler.dart';
import 'package:music_app/helpers/database_helper.dart';
import 'dart:async';

import 'package:music_app/modules/local_notification.dart';

class PlaylistProvider extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<MusicModel> _playlist = [];
  List<MusicModel> _recentlyPlayed = [];
  List<MusicModel> _favSongs = [];
  int _currentIndex = 0;
  bool _isPlaying = false;
  bool _isLoading = false;

  // Getters
  List<MusicModel> get playlist => _playlist;
  List<MusicModel> get recentlyPlayed => _recentlyPlayed;
  List<MusicModel> get favSongs => _favSongs;
  MusicModel? get currentSong =>
      _playlist.isNotEmpty ? _playlist[_currentIndex] : null;
  bool get isPlaying => _isPlaying;
  bool get isLoading => _isLoading;

  PlaylistProvider() {
    _initializePlayer();
  }

  void _initializePlayer() {
    _player.onPlayerComplete.listen((_) {
      playNext();
    });

    _player.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.playing) {
        _isPlaying = true;
        showSongNotification(currentSong!);
      } else if (state == PlayerState.paused) {
        _isPlaying = false;
        notificationsPlugin.cancel(0);
      }
      notifyListeners();
    });
  }

  void setCurrentSong(MusicModel music) {
    _currentIndex = music.id!;
  }

  // Load cached songs from database
  Future<void> _loadCachedSongs() async {
    _isLoading = true;
    notifyListeners();

    try {
      final cachedSongs = await _dbHelper.getAllSongs();
      if (cachedSongs.isNotEmpty) {
        _playlist = cachedSongs;
        // print("Loaded ${_playlist.length} songs from cache");
        _recentlyPlayed = await _dbHelper.getRecentlyPlayedSongs();
        _favSongs = await _dbHelper.getFavSongs();
      } else {
        // If no cached songs, load from device
        await _loadDeviceSongs();
      }
    } catch (e) {
      // print("Error loading cached songs: $e");
      await _loadDeviceSongs();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load songs from device and cache them
  Future<void> _loadDeviceSongs() async {
    _isLoading = true;
    notifyListeners();

    try {
      final songs = await AudioService.getSongsSafe();
      if (songs.isNotEmpty) {
        _playlist = songs;

        // Cache all songs to database
        for (final song in songs) {
          await _dbHelper.insertSong(song);
        }
        _recentlyPlayed = await _dbHelper.getRecentlyPlayedSongs();
        // print("Loaded ${_playlist.length} songs from device and cached them");
      }
    } catch (e) {
      // print("Error loading songs: $e");
      _playlist = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Refresh songs from device
  Future<void> refreshSongs({bool reWrite = false}) async {
    // Clear cache and reload from device
    if (await getCachedSongsCount() <= 0 || reWrite) {
      await _dbHelper.clearCache();
      await _loadDeviceSongs();
    } else {
      await _loadCachedSongs();
    }
  }

  Future<void> refreshHome() async {
    _recentlyPlayed = await _dbHelper.getRecentlyPlayedSongs();
    _favSongs = await _dbHelper.getFavSongs();
  }

  // Add individual song to playlist and cache it
  Future<void> addSongToPlaylist(MusicModel song) async {
    // Check if song already exists in playlist
    final existingIndex = _playlist.indexWhere(
      (s) => s.sourcePath == song.sourcePath,
    );
    if (existingIndex == -1) {
      _playlist.add(song);
      await _dbHelper.insertSong(song);
      notifyListeners();
    }
  }

  Future<void> setFav(BuildContext context, {music}) async {
    if (music == null || music.id == null) {
      return;
    }

    bool fav = music.isFav ? false : true;

    music.isFav = fav;

    await _dbHelper.setFav(id: music.id, isFav: fav);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          music.isFav == true ? "Added to favorites" : "Removed from favorites",
          style: TextStyle(color: fav ? Colors.yellow : Colors.white),
        ),
        duration: Duration(seconds: 1),
      ),
    );
    if (!fav) {
      _favSongs.removeWhere((item) => item.id == music.id);
    } else {
      _favSongs.insert(0, music);
    }
    notifyListeners();
  }

  // Remove song from playlist and cache
  Future<void> removeSongFromPlaylist(int index) async {
    if (index >= 0 && index < _playlist.length) {
      final song = _playlist[index];
      _playlist.removeAt(index);

      await _dbHelper.removeSong(song.id!);

      // Adjust current index if needed
      if (_currentIndex >= index && _currentIndex > 0) {
        _currentIndex--;
      }

      notifyListeners();
    }
  }

  // Set custom playlist
  Future<void> setPlaylist(List<MusicModel> songs) async {
    _playlist = songs;
    _currentIndex = 0;
    _isPlaying = false;

    // Cache the new playlist
    await _dbHelper.clearCache();
    for (final song in songs) {
      await _dbHelper.insertSong(song);
    }

    notifyListeners();
  }

  Future<void> setRecentlyPlayed(MusicModel music) async {
    // If the song already exists, remove it first (avoid duplicates)
    _recentlyPlayed.removeWhere((item) => item.id == music.id);

    // Add the song at the start of the list
    _recentlyPlayed.insert(0, music);

    // Keep only the latest 10 songs
    if (_recentlyPlayed.length > 10) {
      _recentlyPlayed = _recentlyPlayed.sublist(0, 10);
    }

    // Add to recently played in database
    await _dbHelper.addToRecentlyPlayed(music);

    // Ensure database also maintains the 10-song limit
    await _dbHelper.cleanupRecentlyPlayed(limit: 10);

    notifyListeners();
  }

  // Play a specific song
  Future<void> playSong(int index) async {
    if (index < 0 || index >= _playlist.length) return;

    _currentIndex = index;
    final song = _playlist[index];

    try {
      await _player.play(DeviceFileSource(song.sourcePath!));
      _isPlaying = true;

      // Add to recently played when song starts playing
      await setRecentlyPlayed(song);

      notifyListeners();
    } catch (e) {
      // print("Error playing song: $e");
      // Fallback to AssetSource if DeviceFileSource fails
      try {
        await _player.play(AssetSource(song.sourcePath!));
        _isPlaying = true;
        await setRecentlyPlayed(song);
        notifyListeners();
      } catch (e2) {
        // print("Error with asset source: $e2");
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
    showSongNotification(currentSong!);
    notifyListeners();
  }

  // Play previous song
  Future<void> playPrevious() async {
    if (_playlist.isEmpty) return;
    _currentIndex = (_currentIndex - 1 + _playlist.length) % _playlist.length;
    await playSong(_currentIndex);
    showSongNotification(currentSong!);
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

  // Clear all cached songs
  Future<void> clearCache() async {
    await _dbHelper.clearCache();
    _playlist.clear();
    _currentIndex = 0;
    _isPlaying = false;
    notifyListeners();
  }

  // Get cached songs count
  Future<int> getCachedSongsCount() async {
    final songs = await _dbHelper.getAllSongs();
    return songs.length;
  }

  // Dispose player
  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
