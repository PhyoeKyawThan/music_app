import 'package:flutter/material.dart';
import 'package:music_app/modules/change_notifier.dart';
import 'package:provider/provider.dart';

// Future<void> clearCache(BuildContext context) async {
//   await context.watch<PlaylistProvider>().refreshSongs(reWrite: true);
// }

Future<bool?> showConfirmDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false, // user must tap a button
    builder: (context) {
      return AlertDialog(
        title: Text("Confirm"),
        content: Text(
          "Are you sure you want to continue, this will delete your favorite playlist and also recent played songs?",
        ),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          ElevatedButton(
            child: Text("Yes"),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      );
    },
  );
}
