import 'package:flutter/material.dart';
import '../branding/branding.dart';

class PixelAvatar extends StatelessWidget {
  final double size;
  final Color borderColor;

  const PixelAvatar({
    super.key,
    this.size = 54,
    this.borderColor = RetroPalette.amber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: RetroPalette.surfaceLight,
        border: Border.all(color: borderColor, width: 2.5),
        boxShadow: const [
          BoxShadow(
            color: RetroPalette.pixelBorder,
            offset: Offset(2, 2),
            blurRadius: 0,
          )
        ],
      ),
      child: CustomPaint(
        painter: _DriverEmblemPainter(),
      ),
    );
  }
}

class _DriverEmblemPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 16.0; // 16x16 pixel grid
    final paint = Paint();

    void drawPx(int x, int y, Color color) {
      paint.color = color;
      canvas.drawRect(
        Rect.fromLTWH(x * scale, y * scale, scale + 0.2, scale + 0.2),
        paint,
      );
    }

    // Helmet Dome (Retro Cream / White)
    const helmetColor = Color(0xFFE8E5DD);
    for (int x = 4; x <= 11; x++) {
      drawPx(x, 2, helmetColor);
    }
    for (int y = 3; y <= 8; y++) {
      for (int x = 3; x <= 12; x++) {
        drawPx(x, y, helmetColor);
      }
    }

    // Racing Stripe down helmet center (Red)
    for (int y = 2; y <= 5; y++) {
      drawPx(7, y, RetroPalette.racingRed);
      drawPx(8, y, RetroPalette.racingRed);
    }

    // Visor / Goggles (Dark Tint with Cyan highlight)
    for (int x = 4; x <= 11; x++) {
      drawPx(x, 6, const Color(0xFF1B2228));
      drawPx(x, 7, const Color(0xFF14191E));
    }
    drawPx(5, 6, const Color(0xFF81D4FA)); // Glint
    drawPx(6, 6, const Color(0xFF4FC3F7));

    // Lower Chin / Mask (Charcoal)
    for (int x = 4; x <= 11; x++) {
      drawPx(x, 9, const Color(0xFF2C3238));
      drawPx(x, 10, const Color(0xFF1F2428));
    }

    // Shoulders / Racing Suit (Dark Blue / Green with Collar)
    for (int y = 11; y <= 15; y++) {
      for (int x = 1; x <= 14; x++) {
        drawPx(x, y, RetroPalette.steelBlue);
      }
    }
    // Suit zipper
    drawPx(7, 12, RetroPalette.amber);
    drawPx(7, 13, RetroPalette.amber);
    drawPx(8, 12, RetroPalette.amber);
    drawPx(8, 13, RetroPalette.amber);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
