import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Thin wrapper over [HapticFeedback] so call sites are testable and so
/// `buttonPress` can follow each platform's convention.
class AppHaptics {
  static void buttonPress() {
    // Android/Fuchsia expect haptics on every button press, iOS does not.
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      lightImpact();
    }
  }

  static Future<void> lightImpact() => HapticFeedback.lightImpact();
  static Future<void> mediumImpact() => HapticFeedback.mediumImpact();
  static Future<void> heavyImpact() => HapticFeedback.heavyImpact();
  static Future<void> selectionClick() => HapticFeedback.selectionClick();
  static Future<void> vibrate() => HapticFeedback.vibrate();
}
