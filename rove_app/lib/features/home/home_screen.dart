import 'package:flutter/material.dart';
import '../../core/branding/branding.dart';
import '../../core/theme/retro_theme.dart';
import '../../core/widgets/pixel_button.dart';
import '../../core/widgets/pixel_card.dart';
import '../../core/widgets/pixel_badge.dart';
import '../../core/widgets/pixel_road_scene.dart';
import '../../core/widgets/pixel_avatar.dart';
import '../../services/rove_repository.dart';
import '../../services/audio_service.dart';
import '../vehicle_detail/vehicle_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  final RoveRepository repo;
  final VoidCallback onNavigateToCapture;
  final VoidCallback onNavigateToCollection;

  const HomeScreen({
    super.key,
    required this.repo,
    required this.onNavigateToCapture,
    required this.onNavigateToCollection,
  });

  @override
  Widget build(BuildContext context) {
    final profile = repo.profile;
    final recentItems = repo.collection.take(4).toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              RoveBranding.appName,
              style: RetroTheme.pixelDisplay(
                fontSize: 22,
                color: RetroPalette.amber,
                fontWeight: FontWeight.w900,
                letterSpacing: 3.0,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              color: RetroPalette.surfaceLight,
              child: Text(
                'RETRO ARCHIVE',
                style: RetroTheme.pixelDisplay(
                  fontSize: 8,
                  color: RetroPalette.textMuted,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ],
        ),
        actions: [
          // Connection pill
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: repo.isBackendConnected ? RetroPalette.retroGreen : RetroPalette.asphaltGrey,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      color: repo.isBackendConnected ? RetroPalette.retroGreen : RetroPalette.amber,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      repo.isBackendConnected ? 'ONLINE' : 'DEMO',
                      style: RetroTheme.pixelDisplay(
                        fontSize: 9,
                        color: repo.isBackendConnected ? RetroPalette.retroGreen : RetroPalette.amber,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // User Greeting & Level Header
              PixelCard(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const PixelAvatar(size: 46),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'GOOD DAY, ${profile.username}',
                            style: RetroTheme.pixelDisplay(
                              fontSize: 13,
                              color: RetroPalette.cream,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              Text(
                                'LVL ${profile.level}',
                                style: RetroTheme.pixelDisplay(
                                  fontSize: 11,
                                  color: RetroPalette.amber,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '•  ${profile.title}',
                                style: RetroTheme.readableCaption(
                                  fontSize: 11,
                                  color: RetroPalette.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Total Cars Discovered Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: RetroPalette.canvasDark,
                        border: Border.all(color: RetroPalette.amber, width: 1.5),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${profile.totalEncounters}',
                            style: RetroTheme.pixelDisplay(
                              fontSize: 18,
                              color: RetroPalette.cream,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            'DISCOVERED',
                            style: RetroTheme.pixelDisplay(
                              fontSize: 7,
                              color: RetroPalette.amber,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Rarity Breakdown Bar
              PixelCard(
                title: 'RARITY ARCHIVE MATRIX',
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildRarityStat('COMMON', profile.commonCount, const Color(0xFF8E9AA8)),
                    _buildRarityStat('UNCOMMON', profile.uncommonCount, const Color(0xFF4B8B3B)),
                    _buildRarityStat('RARE', profile.rareCount, const Color(0xFF2C75D8)),
                    _buildRarityStat('EPIC', profile.epicCount, const Color(0xFF9447D1)),
                    _buildRarityStat('LEGENDARY', profile.legendaryCount, const Color(0xFFE5A912)),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Animated Pixel-Art Road Scene
              const PixelRoadScene(height: 130),

              const SizedBox(height: 16),

              // Big Primary Action: CAPTURE
              PixelButton(
                text: '⚡ CAPTURE VEHICLE',
                height: 54,
                fontSize: 15,
                backgroundColor: RetroPalette.amber,
                textColor: RetroPalette.canvasDark,
                onPressed: () {
                  RetroAudioService.playButtonBeep();
                  onNavigateToCapture();
                },
              ),

              const SizedBox(height: 20),

              // Recent Discoveries Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'RECENT DISCOVERIES',
                    style: RetroTheme.pixelDisplay(
                      fontSize: 12,
                      color: RetroPalette.cream,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.4,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      RetroAudioService.playButtonBeep();
                      onNavigateToCollection();
                    },
                    child: Text(
                      'VIEW ALL →',
                      style: RetroTheme.pixelDisplay(
                        fontSize: 10,
                        color: RetroPalette.amber,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Real Car Photographs with Pixel Frames
              if (recentItems.isEmpty)
                PixelCard(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          '[ GARAGE EMPTY ]',
                          style: RetroTheme.pixelDisplay(
                            fontSize: 12,
                            color: RetroPalette.asphaltGrey,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'No vehicles discovered yet. Step outside and tap CAPTURE to rove.',
                          textAlign: TextAlign.center,
                          style: RetroTheme.readableCaption(),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recentItems.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final item = recentItems[index];
                    return _buildRecentCard(context, item);
                  },
                ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRarityStat(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          '$count',
          style: RetroTheme.pixelDisplay(
            fontSize: 15,
            color: color,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label.substring(0, 3), // COM, UNC, RAR, EPI, LEG
          style: RetroTheme.pixelDisplay(
            fontSize: 8,
            color: RetroPalette.textMuted,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentCard(BuildContext context, dynamic item) {
    final v = item.vehicle;
    return GestureDetector(
      onTap: () {
        RetroAudioService.playButtonBeep();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => VehicleDetailScreen(
              vehicle: v,
              repo: repo,
              encounterCount: item.encounterCount,
              latestCity: item.latestCity,
            ),
          ),
        );
      },
      child: PixelCard(
        padding: const EdgeInsets.all(8),
        borderColor: RetroPalette.surfaceLight,
        child: Row(
          children: [
            // REAL PHOTOGRAPH inside sharp pixel frame (The signature contrast)
            Container(
              width: 90,
              height: 68,
              decoration: BoxDecoration(
                border: Border.all(color: RetroPalette.pixelBorder, width: 2),
                color: Colors.black,
              ),
              child: Image.network(
                item.primaryPhotoUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Center(
                  child: Text(
                    '[IMG]',
                    style: RetroTheme.pixelDisplay(
                      fontSize: 10,
                      color: RetroPalette.asphaltGrey,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Car Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    v.canonicalName.toUpperCase(),
                    style: RetroTheme.pixelDisplay(
                      fontSize: 12,
                      color: RetroPalette.cream,
                      fontWeight: FontWeight.w800,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      PixelBadge.fromTier(v.tier, fontSize: 9),
                      const SizedBox(width: 6),
                      if (item.encounterCount > 1)
                        Text(
                          '#${item.encounterCount}',
                          style: RetroTheme.pixelDisplay(
                            fontSize: 9,
                            color: RetroPalette.amber,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.latestCity.toUpperCase()} • DISCOVERED',
                    style: RetroTheme.readableCaption(
                      fontSize: 10,
                      color: RetroPalette.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: RetroPalette.asphaltGrey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
