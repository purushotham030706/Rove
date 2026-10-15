import 'package:flutter/material.dart';
import '../branding/branding.dart';
import '../theme/retro_theme.dart';

class PixelCard extends StatelessWidget {
  final Widget child;
  final String? title;
  final Color backgroundColor;
  final Color borderColor;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final double borderWidth;
  final Widget? trailing;

  const PixelCard({
    super.key,
    required this.child,
    this.title,
    this.backgroundColor = RetroPalette.surface,
    this.borderColor = RetroPalette.surfaceLight,
    this.padding = const EdgeInsets.all(12),
    this.margin,
    this.borderWidth = 2.0,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor, width: borderWidth),
        boxShadow: const [
          BoxShadow(
            color: RetroPalette.pixelBorder,
            offset: Offset(2, 2),
            blurRadius: 0,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: borderColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title!.toUpperCase(),
                    style: RetroTheme.pixelDisplay(
                      fontSize: 11,
                      color: RetroPalette.cream,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                  if (trailing != null) trailing!,
                ],
              ),
            ),
          ],
          Padding(
            padding: padding,
            child: child,
          ),
        ],
      ),
    );
  }
}
