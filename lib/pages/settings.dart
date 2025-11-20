import 'package:flutter/material.dart';
import 'package:music_app/constants/app_colors.dart';
import 'package:music_app/widgets/setting_item.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings", style: TextStyle(color: AppColors.textPrimary)),
        backgroundColor: AppColors.navBackground,
      ),
      backgroundColor: AppColors.primaryBackground,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SettingItem(
              option: "reset_cache",
              iconData: Icons.cached_outlined,
              title: "Clear temporary files to free up space",
            ),
            _buildDivider(),
            // SettingItem(option: "Reset Cache", iconData: Icons.cached_outlined),
            // SettingItem(option: )
            // Text(
            //   "Developed by Phyoe Kyaw Than",
            //   style: TextStyle(color: AppColors.textSecondary),
            //   textAlign: TextAlign.center,
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 0.1,
      color: AppColors.textPrimary,
      width: double.infinity,
    );
  }
}
