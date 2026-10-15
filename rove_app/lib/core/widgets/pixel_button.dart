import 'package:flutter/material.dart';
import '../branding/branding.dart';
import '../theme/retro_theme.dart';

class PixelButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final Widget? icon;
  final double height;
  final double? width;
  final double fontSize;

  const PixelButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = RetroPalette.amber,
    this.textColor = RetroPalette.canvasDark,
    this.borderColor = RetroPalette.pixelBorder,
    this.icon,
    this.height = 48,
    this.width,
    this.fontSize = 13,
  });

  @override
  State<PixelButton> createState() => _PixelButtonState();
}

class _PixelButtonState extends State<PixelButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final double depth = widget.onPressed == null ? 0 : 3.0;
    final double currentShift = _isPressed ? depth : 0.0;

    return GestureDetector(
      onTapDown: widget.onPressed == null
          ? null
          : (_) => setState(() => _isPressed = true),
      onTapUp: widget.onPressed == null
          ? null
          : (_) {
              setState(() => _isPressed = false);
              widget.onPressed?.call();
            },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 50),
        width: widget.width,
        height: widget.height,
        margin: EdgeInsets.only(top: currentShift, bottom: depth - currentShift),
        decoration: BoxDecoration(
          color: widget.onPressed == null
              ? RetroPalette.surfaceLight
              : widget.backgroundColor,
          border: Border.all(
            color: widget.borderColor,
            width: 2.5,
          ),
          boxShadow: widget.onPressed == null || _isPressed
              ? []
              : [
                  BoxShadow(
                    color: widget.borderColor,
                    offset: const Offset(0, 3.5),
                    blurRadius: 0,
                  ),
                ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                widget.icon!,
                const SizedBox(width: 8),
              ],
              Text(
                widget.text.toUpperCase(),
                style: RetroTheme.pixelDisplay(
                  fontSize: widget.fontSize,
                  color: widget.onPressed == null
                      ? RetroPalette.asphaltGrey
                      : widget.textColor,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
