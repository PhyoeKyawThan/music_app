import 'package:flutter/material.dart';

class AppColors {
  // 🌌 Backgrounds
  static const Color primaryBackground = Color(
    0xFF0A0B1A,
  ); // Deep dark navy background
  static const Color secondaryBackground = Color(
    0xFF131429,
  ); // Card & container background
  static const Color scaffoldBackground = Color(
    0xFF0E0F20,
  ); // For Scaffold / full screen

  // 💡 Accent / Brand
  static const Color primaryAccent = Color(0xFF6C63FF); // Main purple accent
  static const Color secondaryAccent = Color(
    0xFF8E7CFF,
  ); // Slightly lighter purple
  static const Color highlight = Color(0xFFB39DFF); // Soft lavender glow

  // 🎶 Text Colors
  static const Color textPrimary = Colors.white; // Bright text
  static const Color textSecondary = Color(0xFFB0B3C3); // Muted text
  static const Color textTertiary = Color(
    0xFF8A8DA4,
  ); // Dim hints or inactive text

  // 🔘 Bottom Navigation
  static const Color navBackground = Color(0xFF181A2C); // Transparent dark
  static const Color navActive = Color(0xFF6C63FF); // Purple active icon
  static const Color navInactive = Color(0xFF6D6F7D); // Grayish inactive icon

  // 💫 Gradients
  static const LinearGradient mainBackgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1C1C3A), Color(0xFF0B0C2A)],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    colors: [Color(0xFF7A5FFF), Color(0xFF6245FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ❤️ Others
  static const Color favorite = Color(0xFFFF6584); // Pinkish favorite color
  static const Color divider = Color(0xFF2A2C45); // Subtle divider line
}
