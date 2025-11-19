import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:music_app/models/music.dart';

final FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

void initNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await notificationsPlugin.initialize(initializationSettings);
}

Future<void> showSongNotification(MusicModel song) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'music_channel',
    'Music Playback',
    channelDescription: 'Shows current playing song',
    importance: Importance.max,
    priority: Priority.high,
    ongoing: true,
    icon: '@mipmap/ic_launcher',
    styleInformation: MediaStyleInformation(),
  );

  const NotificationDetails platformDetails = NotificationDetails(
    android: androidDetails,
  );

  await notificationsPlugin.show(0, song.title, song.singer, platformDetails);
}
