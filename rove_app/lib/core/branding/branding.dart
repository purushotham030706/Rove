import 'package:flutter/material.dart';

/// Centralized branding for ROVE.
/// The product name, taglines, color tokens, and tier parameters are defined here.
class RoveBranding {
  static const String appName = 'ROVE';
  static const String tagline = 'Real-World Automotive Discovery & Archive';
  static const String subtitle = 'Retro Automotive Field Collector';
  static const String version = 'v1.0.0';
  static const String author = 'DeepMind Pair Programming';
}

/// Retro Automotive Color Palette (Custom non-generic palette)
class RetroPalette {
  static const Color cream = Color(0xFFF4F1EA);
  static const Color canvasDark = Color(0xFF141618);
  static const Color surface = Color(0xFF202328);
  static const Color surfaceLight = Color(0xFF2C3138);
  static const Color surfaceLighter = Color(0xFF3B414B);
  static const Color pixelBorder = Color(0xFF0A0B0C);
  
  // Retro Automotive Accents
  static const Color steelBlue = Color(0xFF4A6B82);
  static const Color retroGreen = Color(0xFF4B8B3B);
  static const Color amber = Color(0xFFD99B26);
  static const Color racingRed = Color(0xFFC83E34);
  static const Color signalOrange = Color(0xFFE06D28);
  static const Color asphaltGrey = Color(0xFF69717D);
  static const Color white = Color(0xFFFFFFFF);
  static const Color textMuted = Color(0xFFA0AAB5);
  static const Color scanlineColor = Color(0x18000000);
}

/// Rarity Tier Visual Configurations as an Enhanced Enum
enum RarityTier {
  common(
    displayName: 'COMMON',
    stars: 1,
    color: Color(0xFF8E9AA8),
    badgeSymbol: '[ C ]',
    baseXP: 10,
  ),
  uncommon(
    displayName: 'UNCOMMON',
    stars: 2,
    color: Color(0xFF4B8B3B),
    badgeSymbol: '[ U ]',
    baseXP: 25,
  ),
  rare(
    displayName: 'RARE',
    stars: 3,
    color: Color(0xFF2C75D8),
    badgeSymbol: '[ R ]',
    baseXP: 50,
  ),
  epic(
    displayName: 'EPIC',
    stars: 4,
    color: Color(0xFF9447D1),
    badgeSymbol: '[ E ]',
    baseXP: 100,
  ),
  legendary(
    displayName: 'LEGENDARY',
    stars: 5,
    color: Color(0xFFE5A912),
    badgeSymbol: '[ L ]',
    baseXP: 250,
  ),
  mythic(
    displayName: 'MYTHIC',
    stars: 6,
    color: Color(0xFFE53E3E),
    badgeSymbol: '[ M ]',
    baseXP: 500,
  );

  final String displayName;
  final int stars;
  final Color color;
  final String badgeSymbol;
  final int baseXP;

  const RarityTier({
    required this.displayName,
    required this.stars,
    required this.color,
    required this.badgeSymbol,
    required this.baseXP,
  });

  static RarityTier fromString(String val) {
    switch (val.toUpperCase()) {
      case 'UNCOMMON':
        return RarityTier.uncommon;
      case 'RARE':
        return RarityTier.rare;
      case 'EPIC':
        return RarityTier.epic;
      case 'LEGENDARY':
        return RarityTier.legendary;
      case 'MYTHIC':
        return RarityTier.mythic;
      case 'COMMON':
      default:
        return RarityTier.common;
    }
  }
}
