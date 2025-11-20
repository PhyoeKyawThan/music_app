import 'dart:async';
import 'dart:typed_data';
import 'package:music_app/models/music.dart';
import 'package:on_audio_query_pluse/on_audio_query.dart';

class AudioService {
  static final OnAudioQuery _audioQuery = OnAudioQuery();
  static bool _isQuerying = false;

  static Completer<void>? _queryCompleter;

  static Future<List<MusicModel>> getSongsSafe() async {
    // Prevent multiple simultaneous queries with completer pattern
    if (_isQuerying && _queryCompleter != null) {
      // Wait for the ongoing query to complete and return its result
      await _queryCompleter!.future;
      return []; // Or you could cache and return the previous result
    }

    _isQuerying = true;
    _queryCompleter = Completer<void>();

    try {
      // Add a small delay to prevent race conditions
      await Future.delayed(Duration(milliseconds: 100));

      // Check permissions with retry logic
      final hasPermission = await _checkAndRequestPermissionsWithRetry();
      if (!hasPermission) {
        // print('Permission denied for audio query');
        return [];
      }

      // Add another small delay after permission grant
      await Future.delayed(Duration(milliseconds: 200));

      // Use a timeout to prevent hanging
      final songs = await _audioQuery
          .querySongs(
            sortType: null,
            orderType: OrderType.ASC_OR_SMALLER,
            uriType: UriType.EXTERNAL,
            ignoreCase: true,
          )
          .timeout(
            Duration(seconds: 30),
            onTimeout: () {
              // print('Query timeout occurred');
              return <SongModel>[];
            },
          );

      if (songs.isEmpty) {
        // print('No songs found or query returned empty');
        return [];
      }

      // Filter and convert songs with error handling for each conversion
      final filteredSongs = songs
          .where((song) => song.duration != null && song.duration! > 150000)
          .toList();

      // print('Found ${filteredSongs.length} songs after filtering');

      // Convert List<SongModel> to List<MusicModel> with individual error handling
      List<MusicModel> musicList = [];
      for (int i = 0; i < filteredSongs.length; i++) {
        try {
          final musicModel = await _convertToMusicModel(filteredSongs[i], i);
          musicList.add(musicModel);
        } catch (e) {
          // print('Error converting song at index $i: $e');
          // Continue with other songs instead of failing entirely
        }
      }

      // print('Successfully converted ${musicList.length} songs');
      return musicList;
    } on TimeoutException catch (e) {
      // print('Timeout exception in getSongsSafe: $e');
      return [];
    } catch (e, stackTrace) {
      // print('Error in getSongsSafe: $e');
      print('Stack trace: $stackTrace');
      return [];
    } finally {
      _isQuerying = false;
      _queryCompleter?.complete();
      _queryCompleter = null;
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
      isFav: false,
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
      // print("Invalid image: empty or too large");
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

    // print("Invalid image: unrecognized format");
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

  static Future<bool> _checkAndRequestPermissionsWithRetry({
    int maxRetries = 3,
  }) async {
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        // print('Permission check attempt $attempt');

        // Use the package's built-in permission check
        bool hasPermission = await _audioQuery.checkAndRequest(
          retryRequest: attempt < maxRetries, // Only retry if not last attempt
        );

        if (hasPermission) {
          // print('Permission granted on attempt $attempt');
          return true;
        }

        // If we're on the last attempt and still no permission, return false
        if (attempt == maxRetries) {
          // print('Permission denied after $maxRetries attempts');
          return false;
        }

        // Wait before retrying
        // print('Waiting before permission retry...');
        await Future.delayed(Duration(milliseconds: 500 * attempt));
      } catch (e) {
        // print('Permission check error on attempt $attempt: $e');

        if (attempt == maxRetries) {
          return false;
        }

        await Future.delayed(Duration(milliseconds: 500 * attempt));
      }
    }

    return false;
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
      // print("Error getting artwork bytes for song $songId: $e");
      return null;
    }
  }
}
