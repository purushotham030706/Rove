import 'package:flutter/material.dart';
import '../../core/branding/branding.dart';
import '../../core/theme/retro_theme.dart';
import '../../core/widgets/pixel_button.dart';
import '../../core/widgets/pixel_card.dart';
import '../../core/widgets/pixel_badge.dart';
import '../../core/widgets/pixel_particles.dart';
import '../../domain/models/vehicle.dart';
import '../../services/rove_repository.dart';
import '../../services/audio_service.dart';
import '../vehicle_detail/vehicle_detail_screen.dart';

class DiscoveryRevealScreen extends StatefulWidget {
  final Vehicle vehicle;
  final RoveRepository repo;
  final String city;
  final double confidence;

  const DiscoveryRevealScreen({
    super.key,
    required this.vehicle,
    required this.repo,
    required this.city,
    required this.confidence,
  });

  @override
  State<DiscoveryRevealScreen> createState() => _DiscoveryRevealScreenState();
}

class _DiscoveryRevealScreenState extends State<DiscoveryRevealScreen> {
  bool _isNewDiscovery = true;
  int _encounterCount = 1;
  int _xpAwarded = 50;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _saveEncounter();
    });
  }

  Future<void> _saveEncounter() async {
    RetroAudioService.playDiscoveryFanfare();
    
    final result = await widget.repo.confirmCapture(
      vehicle: widget.vehicle,
      city: widget.city,
      aiConfidence: widget.confidence,
    );

    if (mounted) {
      setState(() {
        _isNewDiscovery = result['is_new_discovery'] as bool;
        _encounterCount = result['encounter_count'] as int;
        _xpAwarded = result['xp_awarded'] as int;
      });
      if (widget.vehicle.tier == RarityTier.rare ||
          widget.vehicle.tier == RarityTier.epic ||
          widget.vehicle.tier == RarityTier.legendary) {
        RetroAudioService.playRareRevealChime();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final v = widget.vehicle;
    final photo = v.photoUrl ?? 'https://images.unsplash.com/photo-1580273916550-e323be2ae537?w=800';

    return Scaffold(
      backgroundColor: RetroPalette.canvasDark,
      body: SafeArea(
        child: Stack(
          children: [
            // Floating 8-bit Pixel Particles in Rarity Color
            Positioned.fill(
              child: PixelParticles(
                color: v.tier.color,
                count: 32,
              ),
            ),

            // Content Container
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Discovery Banner
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: _isNewDiscovery ? RetroPalette.amber : RetroPalette.surfaceLight,
                        border: Border.all(color: RetroPalette.pixelBorder, width: 2),
                      ),
                      child: Text(
                        _isNewDiscovery ? '★ NEW DISCOVERY ★' : 'ALREADY ARCHIVED (#$_encounterCount)',
                        style: RetroTheme.pixelDisplay(
                          fontSize: 12,
                          color: _isNewDiscovery ? RetroPalette.canvasDark : RetroPalette.cream,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Vehicle Canonical Name & Gen
                  Text(
                    v.canonicalName.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: RetroTheme.pixelDisplay(
                      fontSize: 20,
                      color: RetroPalette.cream,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.8,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${v.generationCode} • ${v.displayYearRange} • ${v.country.toUpperCase()}',
                    textAlign: TextAlign.center,
                    style: RetroTheme.readableCaption(
                      fontSize: 12,
                      color: RetroPalette.textMuted,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // REAL CAPTURED PHOTO inside sharp pixel frame (Signature contrast)
                  Container(
                    height: 220,
                    decoration: BoxDecoration(
                      border: Border.all(color: v.tier.color, width: 3.5),
                      boxShadow: const [
                        BoxShadow(
                          color: RetroPalette.pixelBorder,
                          offset: Offset(4, 4),
                          blurRadius: 0,
                        )
                      ],
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          photo,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.black,
                            child: Center(
                              child: Text(
                                '[PHOTO ARCHIVED]',
                                style: RetroTheme.pixelDisplay(fontSize: 12),
                              ),
                            ),
                          ),
                        ),
                        // Top Corner Badge
                        Positioned(
                          top: 8,
                          left: 8,
                          child: PixelBadge.fromTier(v.tier, fontSize: 10),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Rarity Reveal Card
                  PixelCard(
                    borderColor: v.tier.color,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Column(
                      children: [
                        Text(
                          'RARITY TIER',
                          style: RetroTheme.pixelDisplay(
                            fontSize: 10,
                            color: RetroPalette.textMuted,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${'★' * v.tier.stars} ${v.tier.displayName}',
                          style: RetroTheme.pixelDisplay(
                            fontSize: 18,
                            color: v.tier.color,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2.0,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // XP Awarded
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: RetroPalette.amber.withOpacity(0.2),
                            border: Border.all(color: RetroPalette.amber, width: 1.5),
                          ),
                          child: Text(
                            '+$_xpAwarded XP GAINED',
                            style: RetroTheme.pixelDisplay(
                              fontSize: 13,
                              color: RetroPalette.amber,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'FIRST DISCOVERED IN ${widget.city.toUpperCase()}',
                          style: RetroTheme.readableCaption(
                            fontSize: 11,
                            color: RetroPalette.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Actions
                  PixelButton(
                    text: 'INSPECT FULL SPECIFICATIONS',
                    height: 50,
                    backgroundColor: RetroPalette.amber,
                    textColor: RetroPalette.canvasDark,
                    onPressed: () {
                      RetroAudioService.playButtonBeep();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => VehicleDetailScreen(
                            vehicle: v,
                            repo: widget.repo,
                            encounterCount: _encounterCount,
                            latestCity: widget.city,
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  PixelButton(
                    text: 'RETURN TO HOME',
                    height: 46,
                    backgroundColor: RetroPalette.surface,
                    textColor: RetroPalette.cream,
                    borderColor: RetroPalette.surfaceLight,
                    onPressed: () {
                      RetroAudioService.playButtonBeep();
                      Navigator.of(context).pop();
                    },
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
