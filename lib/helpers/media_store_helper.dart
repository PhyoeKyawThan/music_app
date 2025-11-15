import 'package:flutter/services.dart';
import 'package:music_app/models/music.dart';

class MediaStoreHelper {
  static const platform = MethodChannel('com.example.music_app/media_store');

  /// Get audio files with duration >= [minDurationMs]
  static Future<List<MusicModel>> getAudioFiles({
    int minDurationMs = 120000,
  }) async {
    try {
      final List<dynamic> result = await platform.invokeMethod(
        'getAudioFiles',
        {'minDurationMs': minDurationMs},
      );

      return result
          .map((item) => MusicModel.toObject(Map<String, dynamic>.from(item)))
          .toList();
    } on PlatformException catch (e) {
      print("Failed to get audio files: ${e.message}");
      return [];
    }
  }
}
