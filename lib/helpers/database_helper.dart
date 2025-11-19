import 'package:music_app/models/music.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'music_cache.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
      CREATE TABLE playlist(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        songIndex INTEGER,
        title TEXT,
        singer TEXT,
        duration TEXT,
        sourcePath TEXT,
        coverImage BLOB,
        isFav INTEGER DEFAULT 0
      )
    ''');

        await db.execute('''
      CREATE TABLE recently_played(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        playlist_id INTEGER,
        played_at INTEGER,
        FOREIGN KEY (playlist_id) REFERENCES playlist(id)
      )
    ''');
      },
    );
  }

  Future<void> insertSong(MusicModel song) async {
    final database = await db;
    await database.insert('playlist', {
      'songIndex': song.id,
      'title': song.title,
      'singer': song.singer,
      'duration': song.duration,
      'sourcePath': song.sourcePath,
      'coverImage': song.coverImage,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> setFav({id, isFav = false}) async {
    final database = await db;
    await database.update(
      "playlist",
      {"isFav": isFav ? 1 : 0},
      where: "songIndex = ?",
      whereArgs: [id],
    );
  }

  Future<List<MusicModel>> getAllSongs() async {
    final database = await db;
    final List<Map<String, dynamic>> maps = await database.query('playlist');

    return List.generate(maps.length, (i) {
      return MusicModel(
        id: maps[i]['songIndex'],
        title: maps[i]['title'],
        singer: maps[i]['singer'],
        duration: maps[i]['duration'],
        sourcePath: maps[i]['sourcePath'],
        coverImage: maps[i]['coverImage'],
      );
    });
  }

  Future<List<MusicModel>> getFavSongs() async {
    final database = await db;
    final List<Map<String, dynamic>> maps = await database.query(
      'playlist',
      where: " isFav = ? ",
      whereArgs: [1],
    );

    return List.generate(maps.length, (i) {
      return MusicModel(
        id: maps[i]['songIndex'],
        title: maps[i]['title'],
        singer: maps[i]['singer'],
        duration: maps[i]['duration'],
        sourcePath: maps[i]['sourcePath'],
        coverImage: maps[i]['coverImage'],
      );
    });
  }

  // Add to DatabaseHelper class
  Future<void> removeSong(int id) async {
    final database = await db;
    await database.delete('playlist', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> addToRecentlyPlayed(MusicModel song) async {
    // if (!_isInitialized) return;
    try {
      final database = await db;

      // First, check if this song is already in playlist table
      final existingSong = await database.query(
        'playlist',
        where: 'sourcePath = ?',
        whereArgs: [song.sourcePath],
      );

      int playlistId;

      if (existingSong.isEmpty) {
        // Insert into playlist first if it doesn't exist
        playlistId = await database.insert('playlist', {
          'title': song.title,
          'singer': song.singer,
          'duration': song.duration,
          'sourcePath': song.sourcePath,
          'coverImage': song.coverImage,
        });
      } else {
        playlistId = existingSong.first['id'] as int;
      }

      // Remove any existing entry for this song to avoid duplicates
      await database.delete(
        'recently_played',
        where: 'playlist_id = ?',
        whereArgs: [playlistId],
      );

      // Insert new recently played entry
      await database.insert('recently_played', {
        'playlist_id': playlistId,
        'played_at': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      print("Error adding to recently played: $e");
    }
  }

  Future<void> cleanupRecentlyPlayed({int limit = 10}) async {
    // if (!_isInitialized) return;
    try {
      final database = await db;

      // Delete older entries beyond the limit
      await database.rawDelete(
        '''
        DELETE FROM recently_played 
        WHERE id NOT IN (
          SELECT id FROM recently_played 
          ORDER BY played_at DESC 
          LIMIT ?
        )
      ''',
        [limit],
      );
    } catch (e) {
      print("Error cleaning up recently played: $e");
    }
  }

  Future<void> clearRecentlyPlayed() async {
    // if (!_isInitialized) return;
    try {
      final database = await db;
      await database.delete('recently_played');
    } catch (e) {
      print("Error clearing recently played: $e");
    }
  }

  Future<List<MusicModel>> getRecentlyPlayedSongs() async {
    final database = await db;
    final List<Map<String, dynamic>> maps = await database.rawQuery('''
    SELECT p.* FROM playlist p
    INNER JOIN recently_played rp ON p.id = rp.playlist_id
    ORDER BY rp.played_at DESC
    LIMIT 10
  ''');

    return List.generate(maps.length, (i) {
      return MusicModel(
        id: maps[i]['songIndex'],
        title: maps[i]['title'],
        singer: maps[i]['singer'],
        duration: maps[i]['duration'],
        sourcePath: maps[i]['sourcePath'],
        coverImage: maps[i]['coverImage'],
      );
    });
  }

  Future<void> clearCache() async {
    final database = await db;
    await database.delete('playlist');
    await database.delete("recently_played");
  }
}
