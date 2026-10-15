import 'package:flutter/material.dart';
import '../branding/branding.dart';

class PixelRoadScene extends StatefulWidget {
  final double height;

  const PixelRoadScene({super.key, this.height = 140});

  @override
  State<PixelRoadScene> createState() => _PixelRoadSceneState();
}

class _PixelRoadSceneState extends State<PixelRoadScene>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0C1017),
        border: Border.all(color: RetroPalette.pixelBorder, width: 2.5),
        boxShadow: const [
          BoxShadow(
            color: RetroPalette.pixelBorder,
            offset: Offset(2, 2),
            blurRadius: 0,
          )
        ],
      ),
      child: ClipRect(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: _PixelRoadPainter(progress: _controller.value),
            );
          },
        ),
      ),
    );
  }
}

class _PixelRoadPainter extends CustomPainter {
  final double progress;

  _PixelRoadPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // 1. Pixel Stars (Blinking)
    final stars = [
      Offset(size.width * 0.10, 16),
      Offset(size.width * 0.25, 24),
      Offset(size.width * 0.45, 12),
      Offset(size.width * 0.65, 28),
      Offset(size.width * 0.82, 14),
      Offset(size.width * 0.92, 32),
    ];

    for (int i = 0; i < stars.length; i++) {
      final alpha = ((progress * 3 + (i * 0.4)) % 1.0 > 0.5) ? 255 : 90;
      paint.color = Colors.white.withAlpha(alpha);
      canvas.drawRect(
        Rect.fromLTWH(stars[i].dx, stars[i].dy, 3, 3),
        paint,
      );
    }

    // 2. Distant Pixel Mountain Silhouettes
    paint.color = const Color(0xFF18202D);
    final mountainPath = Path();
    mountainPath.moveTo(0, size.height * 0.60);
    double mX = 0;
    while (mX < size.width) {
      mountainPath.lineTo(mX + 25, size.height * 0.35);
      mountainPath.lineTo(mX + 50, size.height * 0.60);
      mX += 50;
    }
    mountainPath.lineTo(size.width, size.height * 0.60);
    mountainPath.lineTo(size.width, size.height);
    mountainPath.lineTo(0, size.height);
    mountainPath.close();
    canvas.drawPath(mountainPath, paint);

    // 3. Pixel City Skyline with window lights
    paint.color = const Color(0xFF222B38);
    final buildings = [
      Rect.fromLTWH(20, size.height * 0.40, 24, size.height * 0.30),
      Rect.fromLTWH(50, size.height * 0.32, 30, size.height * 0.38),
      Rect.fromLTWH(88, size.height * 0.45, 22, size.height * 0.25),
      Rect.fromLTWH(125, size.height * 0.36, 32, size.height * 0.34),
      Rect.fromLTWH(size.width - 130, size.height * 0.34, 28, size.height * 0.36),
      Rect.fromLTWH(size.width - 95, size.height * 0.42, 26, size.height * 0.28),
      Rect.fromLTWH(size.width - 60, size.height * 0.30, 34, size.height * 0.40),
    ];

    for (final b in buildings) {
      canvas.drawRect(b, paint);
      // Windows
      final winPaint = Paint()..color = const Color(0xFFE5A912).withOpacity(0.7);
      for (double wy = b.top + 6; wy < b.bottom - 10; wy += 8) {
        for (double wx = b.left + 5; wx < b.right - 5; wx += 8) {
          canvas.drawRect(Rect.fromLTWH(wx, wy, 3, 3), winPaint);
        }
      }
    }

    // 4. Asphalt Road
    final roadTop = size.height * 0.65;
    paint.color = const Color(0xFF1E2124);
    canvas.drawRect(Rect.fromLTWH(0, roadTop, size.width, size.height - roadTop), paint);

    // Road top curb / guardrail
    paint.color = RetroPalette.amber;
    canvas.drawRect(Rect.fromLTWH(0, roadTop, size.width, 3), paint);

    // Moving dashed lane markings
    paint.color = Colors.white.withOpacity(0.85);
    const dashWidth = 18.0;
    const dashGap = 20.0;
    const totalDash = dashWidth + dashGap;
    final offset = (progress * totalDash * 4) % totalDash;

    for (double x = -offset; x < size.width + totalDash; x += totalDash) {
      canvas.drawRect(
        Rect.fromLTWH(x, roadTop + (size.height - roadTop) * 0.5 - 1.5, dashWidth, 3),
        paint,
      );
    }

    // 5. Driving Pixel-Art Car
    // Gentle floating bob
    final carX = size.width * 0.40;
    final carY = roadTop + 8 + (progress * 10).floor() % 2;

    _drawPixelCar(canvas, carX, carY);
  }

  void _drawPixelCar(Canvas canvas, double x, double y) {
    final p = Paint();

    // Headlight beam (warm yellow cone)
    final beamPaint = Paint()
      ..color = const Color(0x33FFEA79)
      ..style = PaintingStyle.fill;
    final beamPath = Path()
      ..moveTo(x + 42, y + 10)
      ..lineTo(x + 100, y + 2)
      ..lineTo(x + 100, y + 22)
      ..close();
    canvas.drawPath(beamPath, beamPaint);

    // Car Body (Retro Red / Amber Sports Car)
    p.color = RetroPalette.racingRed;
    // Lower body
    canvas.drawRect(Rect.fromLTWH(x, y + 8, 42, 9), p);
    // Cabin roof
    canvas.drawRect(Rect.fromLTWH(x + 10, y + 2, 20, 7), p);

    // Windows (Cyan / Tinted)
    p.color = const Color(0xFF81D4FA);
    canvas.drawRect(Rect.fromLTWH(x + 13, y + 4, 8, 4), p); // rear side
    canvas.drawRect(Rect.fromLTWH(x + 23, y + 4, 6, 4), p); // front side

    // Wheels (Pixel Charcoal with Silver Hub)
    p.color = const Color(0xFF0A0A0A);
    canvas.drawRect(Rect.fromLTWH(x + 6, y + 13, 8, 8), p);
    canvas.drawRect(Rect.fromLTWH(x + 28, y + 13, 8, 8), p);

    // Hubs
    p.color = Colors.white70;
    canvas.drawRect(Rect.fromLTWH(x + 9, y + 16, 2, 2), p);
    canvas.drawRect(Rect.fromLTWH(x + 31, y + 16, 2, 2), p);

    // Taillight (Amber/Red)
    p.color = const Color(0xFFFF5252);
    canvas.drawRect(Rect.fromLTWH(x, y + 9, 3, 3), p);

    // Headlight (Yellow pixel)
    p.color = const Color(0xFFFFEB3B);
    canvas.drawRect(Rect.fromLTWH(x + 40, y + 9, 3, 3), p);

    // Exhaust puff
    final puffX = x - 6 - ((progress * 15) % 6);
    p.color = Colors.white30;
    canvas.drawRect(Rect.fromLTWH(puffX, y + 12, 3, 3), p);
  }

  @override
  bool shouldRepaint(covariant _PixelRoadPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
