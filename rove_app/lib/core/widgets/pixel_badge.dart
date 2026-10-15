import 'package:flutter/material.dart';
import '../branding/branding.dart';
import '../theme/retro_theme.dart';

class PixelBadge extends StatelessWidget {
  final String text;
  final Color color;
  final int? stars;
  final double fontSize;
  final bool showBrackets;

  const PixelBadge({
    super.key,
    required this.text,
    required this.color,
    this.stars,
    this.fontSize = 11,
    this.showBrackets = true,
  });

  factory PixelBadge.fromTier(RarityTier tier, {double fontSize = 11}) {
    return PixelBadge(
      text: tier.displayName,
      color: tier.color,
      stars: tier.stars,
      fontSize: fontSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    String starStr = '';
    if (stars != null && stars! > 0) {
      starStr = ' ${'★' * stars!}';
    }

    final displayText = showBrackets
        ? '[ ${text.toUpperCase()}$starStr ]'
        : '${text.toUpperCase()}$starStr';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.18),
        border: Border.all(color: color, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: RetroPalette.pixelBorder.withOpacity(0.5),
            offset: const Offset(1, 1),
            blurRadius: 0,
          )
        ],
      ),
      child: Text(
        displayText,
        style: RetroTheme.pixelDisplay(
          fontSize: fontSize,
          color: color,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
