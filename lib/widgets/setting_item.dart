import 'package:flutter/material.dart';
import 'package:music_app/constants/app_colors.dart';
import 'package:music_app/helpers/setting_action_helpers.dart';
import 'package:music_app/modules/change_notifier.dart';
import 'package:provider/provider.dart';

class SettingItem extends StatelessWidget {
  final String option;
  final String title;
  final IconData? iconData;
  const SettingItem({
    super.key,
    required this.option,
    required this.title,
    this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    final PlaylistProvider pp = context.watch<PlaylistProvider>();
    return Padding(
      padding: EdgeInsets.all(5),
      child: TextButton(
        onPressed: () async {
          if (await showConfirmDialog(context) == true) {
            switch (option) {
              case "reset_cache":
                await pp.refreshSongs(reWrite: true);
                break;
              default:
            }
          }
        },
        child: Row(
          children: [
            Icon(iconData, color: AppColors.textPrimary),
            SizedBox(width: 10),
            Text(title, style: TextStyle(color: AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }
}
