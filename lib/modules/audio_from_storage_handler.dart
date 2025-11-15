import 'dart:async';
import 'dart:typed_data';

import 'package:music_app/models/music.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioService {
  static final OnAudioQuery _audioQuery = OnAudioQuery();
  static bool _isQuerying = false;

  static Future<List<MusicModel>> getSongsSafe() async {
    // Prevent multiple simultaneous queries
    if (_isQuerying) {
      return [];
    }

    _isQuerying = true;
    try {
      if (!await _checkAndRequestPermissions()) {
        return [];
      }

      // Use a timeout to prevent hanging
      final songs = await _audioQuery
          .querySongs(
            sortType: null,
            orderType: OrderType.ASC_OR_SMALLER,
            uriType: UriType.EXTERNAL,
            ignoreCase: true,
          )
          .timeout(Duration(seconds: 20));

      // Convert List<SongModel> to List<MusicModel>
      int index = 0;
      List<MusicModel> musicList = await Future.wait(
        songs.map((song) {
          Future<MusicModel> music = _convertToMusicModel(song, index);
          index += 1;
          return music;
        }),
      );

      return musicList;
    } on TimeoutException {
      return [];
    } catch (e) {
      return [];
    } finally {
      _isQuerying = false;
    }
  }

  // Helper method to convert SongModel to MusicModel
  static Future<MusicModel> _convertToMusicModel(
    SongModel song,
    int index,
  ) async {
    // Get album artwork for the song
    Uint8List? coverImage = await _getAlbumArt(song.id);
    // Uint8List? coverImage = null;

    return MusicModel(
      id: index,
      title: song.title,
      coverImage: coverImage,
      singer: song.artist ?? "Unknown Artist",
      duration: _formatDuration(song.duration ?? 0),
      sourcePath: song.data,
    );
  }

  // Helper function to get album artwork as base64 string
  static Future<Uint8List?> _getAlbumArt(int songId) async {
    try {
      final Uint8List? artwork = await _audioQuery.queryArtwork(
        songId,
        ArtworkType.AUDIO,
        format: ArtworkFormat.PNG,
        size: 400, // Reduced size to prevent large images
      );

      // Validate the artwork data
      if (artwork != null && _isValidImage(artwork)) {
        return artwork;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static bool _isValidImage(Uint8List data) {
    // Check if data is not empty and has reasonable size
    if (data.isEmpty || data.lengthInBytes > 500000) {
      // Max 500KB
      print("Invalid image: empty or too large");
      return false;
    }

    // Basic JPEG/PNG header check
    if (data.length >= 3) {
      // Check for JPEG header (FF D8 FF)
      if (data[0] == 0xFF && data[1] == 0xD8 && data[2] == 0xFF) {
        return true;
      }
      // Check for PNG header (89 50 4E 47)
      if (data[0] == 0x89 &&
          data[1] == 0x50 &&
          data[2] == 0x4E &&
          data[3] == 0x47) {
        return true;
      }
    }

    print("Invalid image: unrecognized format");
    return false;
  }

  // Helper function to format duration from milliseconds to MM:SS format
  static String _formatDuration(int milliseconds) {
    if (milliseconds <= 0) return "0:00";

    Duration duration = Duration(milliseconds: milliseconds);
    String twoDigits(int n) => n.toString().padLeft(2, "0");

    // Handle hours if needed
    if (duration.inHours > 0) {
      String twoDigitHours = twoDigits(duration.inHours);
      String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
      String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
      return "$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds";
    } else {
      String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
      String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
  }

  static Future<bool> _checkAndRequestPermissions() async {
    try {
      // Check if we already have permissions
      if (await Permission.audio.isGranted ||
          await Permission.storage.isGranted ||
          await Permission.manageExternalStorage.isGranted) {
        return true;
      }

      // Request permissions
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        await Permission.audio.request();
      }

      return await Permission.audio.isGranted ||
          await Permission.storage.isGranted;
    } catch (e) {
      print("Permission check error: $e");
      return false;
    }
  }

  // Optional: Method to get artwork as Uint8List for immediate use
  static Future<Uint8List?> getArtworkBytes(int songId) async {
    try {
      return await _audioQuery.queryArtwork(
        songId,
        ArtworkType.AUDIO,
        format: ArtworkFormat.JPEG,
        size: 300,
      );
    } catch (e) {
      print("Error getting artwork bytes for song $songId: $e");
      return null;
    }
  }
}
