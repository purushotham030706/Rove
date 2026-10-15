import 'package:flutter/material.dart';
import '../branding/branding.dart';

class RetroTheme {
  // Pixel / Arcade Display Typography (Monospace uppercase retro aesthetic)
  static TextStyle pixelDisplay({
    double fontSize = 16,
    Color color = RetroPalette.cream,
    FontWeight fontWeight = FontWeight.w800,
    double letterSpacing = 1.8,
  }) {
    return TextStyle(
      fontFamily: 'Courier', // Fallback universal system monospace for retro feel
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: 1.2,
    );
  }

  // Highly readable body typography for specs, history, and technical lore
  static TextStyle readableBody({
    double fontSize = 14,
    Color color = RetroPalette.cream,
    FontWeight fontWeight = FontWeight.w400,
    double height = 1.45,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: 0.2,
    );
  }

  static TextStyle readableCaption({
    double fontSize = 12,
    Color color = RetroPalette.textMuted,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: 0.3,
    );
  }

  // Theme definition
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: RetroPalette.canvasDark,
      primaryColor: RetroPalette.amber,
      cardColor: RetroPalette.surface,
      dividerColor: RetroPalette.pixelBorder,
      appBarTheme: AppBarTheme(
        backgroundColor: RetroPalette.canvasDark,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: pixelDisplay(
          fontSize: 18,
          color: RetroPalette.cream,
          letterSpacing: 2.0,
        ),
        iconTheme: const IconThemeData(color: RetroPalette.cream),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: RetroPalette.surface,
        selectedItemColor: RetroPalette.amber,
        unselectedItemColor: RetroPalette.asphaltGrey,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
}
