import 'package:flutter/material.dart';
import '../../core/branding/branding.dart';
import '../../core/theme/retro_theme.dart';
import '../../core/widgets/pixel_card.dart';
import '../../core/widgets/pixel_badge.dart';
import '../../domain/models/encounter.dart';
import '../../services/rove_repository.dart';
import '../../services/audio_service.dart';
import '../vehicle_detail/vehicle_detail_screen.dart';

class MapScreen extends StatefulWidget {
  final RoveRepository repo;

  const MapScreen({super.key, required this.repo});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapMarkerData? _selectedMarker;

  @override
  Widget build(BuildContext context) {
    final markers = widget.repo.mapMarkers;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'DISCOVERY MAP',
          style: RetroTheme.pixelDisplay(fontSize: 16, color: RetroPalette.cream),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${markers.length} PINS',
                style: RetroTheme.pixelDisplay(fontSize: 10, color: RetroPalette.amber),
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Retro Map Canvas with Stepped Grid Coordinates
            Positioned.fill(
              child: CustomPaint(
                painter: _RetroMapPainter(),
              ),
            ),

            // Interactive Pixel Pins on the Map
            Positioned.fill(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: markers.map((m) {
                      // Project coordinates to relative canvas positions
                      final relX = _projectLng(m.longitude, constraints.maxWidth);
                      final relY = _projectLat(m.latitude, constraints.maxHeight);

                      final isSelected = _selectedMarker?.id == m.id;

                      return Positioned(
                        left: relX - 16,
                        top: relY - 24,
                        child: GestureDetector(
                          onTap: () {
                            RetroAudioService.playButtonBeep();
                            setState(() => _selectedMarker = m);
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Pixel Pin Badge
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isSelected ? RetroPalette.amber : m.tier.color,
                                  border: Border.all(color: RetroPalette.pixelBorder, width: 2),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black,
                                      offset: Offset(2, 2),
                                      blurRadius: 0,
                                    )
                                  ],
                                ),
                                child: Text(
                                  m.tier.badgeSymbol,
                                  style: RetroTheme.pixelDisplay(
                                    fontSize: 8,
                                    color: isSelected ? RetroPalette.canvasDark : Colors.white,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              // Pixel needle pin
                              Container(
                                width: 3,
                                height: 8,
                                color: RetroPalette.pixelBorder,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),

            // Top HUD Coordinates Bar
            Positioned(
              top: 12,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.75),
                  border: Border.all(color: RetroPalette.surfaceLight, width: 1.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'SECTOR: SOUTH ASIA',
                      style: RetroTheme.pixelDisplay(fontSize: 9, color: RetroPalette.textMuted),
                    ),
                    Text(
                      '12.2958° N, 76.6394° E',
                      style: RetroTheme.pixelDisplay(fontSize: 9, color: RetroPalette.amber),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Selected Marker Card Drawer
            if (_selectedMarker != null)
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: _buildMarkerCard(context, _selectedMarker!),
              ),
          ],
        ),
      ),
    );
  }

  double _projectLng(double lng, double width) {
    // Demo projection mapped to India/South Asia bounds
    const minLng = 72.0;
    const maxLng = 82.0;
    final pct = (lng - minLng) / (maxLng - minLng);
    return (pct * (width - 80) + 40).clamp(30.0, width - 40.0);
  }

  double _projectLat(double lat, double height) {
    const minLat = 11.0;
    const maxLat = 21.0;
    final pct = 1.0 - ((lat - minLat) / (maxLat - minLat));
    return (pct * (height - 140) + 70).clamp(60.0, height - 120.0);
  }

  Widget _buildMarkerCard(BuildContext context, MapMarkerData marker) {
    final v = widget.repo.catalogue.firstWhere(
      (cat) => cat.id == marker.vehicleId,
      orElse: () => widget.repo.catalogue[0],
    );

    return PixelCard(
      title: 'LOCAL ENCOUNTER ARCHIVE',
      borderColor: marker.tier.color,
      trailing: GestureDetector(
        onTap: () => setState(() => _selectedMarker = null),
        child: const Icon(Icons.close, color: RetroPalette.cream, size: 16),
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          // REAL PHOTO FRAME
          Container(
            width: 70,
            height: 54,
            decoration: BoxDecoration(
              border: Border.all(color: RetroPalette.pixelBorder, width: 2),
              color: Colors.black,
            ),
            child: Image.network(
              marker.photoUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Center(child: Text('[IMG]')),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  marker.vehicleName.toUpperCase(),
                  style: RetroTheme.pixelDisplay(fontSize: 11, color: RetroPalette.cream),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    PixelBadge.fromTier(marker.tier, fontSize: 8),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  marker.city.toUpperCase(),
                  style: RetroTheme.readableCaption(fontSize: 9),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, color: RetroPalette.amber, size: 16),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => VehicleDetailScreen(
                    vehicle: v,
                    repo: widget.repo,
                    latestCity: marker.city,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _RetroMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFF161A1F);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Retro Grid Lines
    final gridPaint = Paint()
      ..color = const Color(0xFF222933)
      ..strokeWidth = 1.0;

    const gridSize = 40.0;
    for (double x = 0; x < size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Retro Coastline / Topography Polygons (Stylized South Asian terrain)
    final terrainPaint = Paint()..color = const Color(0xFF1E2631);
    final path = Path()
      ..moveTo(size.width * 0.20, 40)
      ..lineTo(size.width * 0.70, 80)
      ..lineTo(size.width * 0.85, size.height * 0.40)
      ..lineTo(size.width * 0.65, size.height * 0.75)
      ..lineTo(size.width * 0.45, size.height * 0.90)
      ..lineTo(size.width * 0.35, size.height * 0.65)
      ..lineTo(size.width * 0.15, size.height * 0.35)
      ..close();
    canvas.drawPath(path, terrainPaint);

    // Coastal pixel outline
    final coastPaint = Paint()
      ..color = RetroPalette.steelBlue.withOpacity(0.5)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, coastPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
