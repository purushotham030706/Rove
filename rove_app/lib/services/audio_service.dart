import 'package:flutter/services.dart';

class RetroAudioService {
  static void playButtonBeep() {
    // Vintage arcade micro-haptic feedback
    HapticFeedback.lightImpact();
  }

  static void playShutterClick() {
    HapticFeedback.mediumImpact();
  }

  static void playDiscoveryFanfare() {
    HapticFeedback.heavyImpact();
  }

  static void playRareRevealChime() {
    HapticFeedback.vibrate();
  }
}
