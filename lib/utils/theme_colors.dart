import 'package:flutter/material.dart';

/// Pixel art medieval dark theme color palette
class PixelTheme {
  // Base colors
  static const darkPurple = Color(0xFF2C1B47); // Deep background
  static const shadowPurple = Color(0xFF1A102C); // Darker shadows
  static const midPurple = Color(0xFF51366B); // Mid-tones
  static const lightPurple = Color(0xFF8B4F93); // Highlights

  // Accent colors
  static const bloodRed = Color(0xFF9E2B25); // Blood red for evil vibes
  static const poisonGreen = Color(0xFF3F7D20); // Toxic green for potions
  static const candleYellow = Color(0xFFFFB82B); // Candle flames
  static const boneWhite = Color(0xFFE5D7B7); // Skulls and bones
  static const rustBrown = Color(0xFF8B4513); // Wood and metal

  // UI Element colors
  static const uiDark = Color(0xFF0F0A1E); // UI backgrounds
  static const uiMid = Color(0xFF2A1F3D); // UI mid-tones
  static const uiLight = Color(0xFF453A5A); // UI highlights
  static const uiAccent = Color(0xFFAD7FCC); // UI borders and accents

  // Gradient presets
  static const backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      shadowPurple,
      darkPurple,
    ],
  );

  static const uiGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      uiDark,
      uiMid,
    ],
  );

  // Pixel perfect shadow
  static List<BoxShadow> pixelShadow = [
    const BoxShadow(
      color: shadowPurple,
      offset: Offset(4, 4),
      spreadRadius: 0,
      blurRadius: 0,
    ),
  ];
}
