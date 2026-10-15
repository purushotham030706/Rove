import 'package:flutter/material.dart';
import '../branding/branding.dart';
import '../theme/retro_theme.dart';

class PixelCameraFrame extends StatefulWidget {
  final Widget child;
  final int photoCount;
  final String instruction;

  const PixelCameraFrame({
    super.key,
    required this.child,
    this.photoCount = 143,
    this.instruction = 'FRAME THE CAR',
  });

  @override
  State<PixelCameraFrame> createState() => _PixelCameraFrameState();
}

class _PixelCameraFrameState extends State<PixelCameraFrame>
    with SingleTickerProviderStateMixin {
  late AnimationController _recBlinkController;

  @override
  void initState() {
    super.initState();
    _recBlinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _recBlinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Camera Viewport Base
        Positioned.fill(child: widget.child),

        // Retro Vignette & Pixel Corners Overlay
        Positioned.fill(
          child: CustomPaint(
            painter: _RetroViewfinderPainter(),
          ),
        ),

        // Top Status Bar: REC Indicator + Photo Count
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Blinking REC Indicator
              AnimatedBuilder(
                animation: _recBlinkController,
                builder: (context, _) {
                  final isLit = _recBlinkController.value > 0.4;
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      border: Border.all(color: RetroPalette.pixelBorder, width: 2),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          color: isLit ? RetroPalette.racingRed : Colors.transparent,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'REC',
                          style: RetroTheme.pixelDisplay(
                            fontSize: 12,
                            color: isLit ? RetroPalette.racingRed : RetroPalette.asphaltGrey,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // Archive Photo Counter
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  border: Border.all(color: RetroPalette.pixelBorder, width: 2),
                ),
                child: Text(
                  'PHOTO #${widget.photoCount.toString().padLeft(3, '0')}',
                  style: RetroTheme.pixelDisplay(
                    fontSize: 12,
                    color: RetroPalette.amber,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Center Guide Instruction ("FRAME THE CAR")
        Positioned(
          bottom: 24,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                border: Border.all(color: RetroPalette.surfaceLight, width: 1.5),
              ),
              child: Text(
                widget.instruction.toUpperCase(),
                style: RetroTheme.pixelDisplay(
                  fontSize: 11,
                  color: RetroPalette.cream,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.0,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RetroViewfinderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    const bracketLength = 28.0;
    const inset = 24.0;

    // Top-Left Corner
    canvas.drawLine(
      const Offset(inset, inset),
      const Offset(inset + bracketLength, inset),
      paint,
    );
    canvas.drawLine(
      const Offset(inset, inset),
      const Offset(inset, inset + bracketLength),
      paint,
    );

    // Top-Right Corner
    canvas.drawLine(
      Offset(size.width - inset, inset),
      Offset(size.width - inset - bracketLength, inset),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - inset, inset),
      Offset(size.width - inset, inset + bracketLength),
      paint,
    );

    // Bottom-Left Corner
    canvas.drawLine(
      Offset(inset, size.height - inset),
      Offset(inset + bracketLength, size.height - inset),
      paint,
    );
    canvas.drawLine(
      Offset(inset, size.height - inset),
      Offset(inset, size.height - inset - bracketLength),
      paint,
    );

    // Bottom-Right Corner
    canvas.drawLine(
      Offset(size.width - inset, size.height - inset),
      Offset(size.width - inset - bracketLength, size.height - inset),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - inset, size.height - inset),
      Offset(size.width - inset, size.height - inset - bracketLength),
      paint,
    );

    // Center Crosshair (Subtle Retro Dot)
    final centerPaint = Paint()..color = Colors.white.withOpacity(0.5);
    final cx = size.width / 2;
    final cy = size.height / 2;
    canvas.drawRect(Rect.fromLTWH(cx - 2, cy - 2, 4, 4), centerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
