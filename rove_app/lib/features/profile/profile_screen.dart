import 'package:flutter/material.dart';
import '../../core/branding/branding.dart';
import '../../core/theme/retro_theme.dart';
import '../../core/widgets/pixel_card.dart';
import '../../core/widgets/pixel_avatar.dart';
import '../../core/widgets/pixel_button.dart';
import '../../services/rove_repository.dart';
import '../settings/settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  final RoveRepository repo;

  const ProfileScreen({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    final p = repo.profile;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ARCHIVIST PROFILE',
          style: RetroTheme.pixelDisplay(fontSize: 16, color: RetroPalette.cream),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: RetroPalette.amber, size: 20),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => SettingsScreen(repo: repo),
                ),
              );
            },
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Avatar & Main Title Header Card
              PixelCard(
                borderColor: RetroPalette.amber,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const PixelAvatar(size: 64),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.username,
                            style: RetroTheme.pixelDisplay(
                              fontSize: 18,
                              color: RetroPalette.cream,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2.0,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            color: RetroPalette.amber.withOpacity(0.2),
                            child: Text(
                              'LVL ${p.level} • ${p.title}',
                              style: RetroTheme.pixelDisplay(
                                fontSize: 10,
                                color: RetroPalette.amber,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'CURRENT XP: ${p.currentXP} PTS',
                            style: RetroTheme.readableCaption(fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Macro Stats Grid
              PixelCard(
                title: 'FIELD CAREER STATISTICS',
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildBigStat('${p.totalEncounters}', 'TOTAL ENCOUNTERS'),
                        _buildBigStat('${p.uniqueVehicles}', 'UNIQUE VEHICLES'),
                      ],
                    ),
                    const Divider(color: RetroPalette.surfaceLight, height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildBigStat('${p.citiesDiscovered}', 'CITIES ROVED'),
                        _buildBigStat('${p.manufacturersDiscovered}', 'MANUFACTURERS'),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Rarity Breakdown Bars
              PixelCard(
                title: 'RARITY DISTRIBUTION ARCHIVE',
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    _buildRarityBar('COMMON', p.commonCount, p.totalEncounters, const Color(0xFF8E9AA8)),
                    const SizedBox(height: 10),
                    _buildRarityBar('UNCOMMON', p.uncommonCount, p.totalEncounters, const Color(0xFF4B8B3B)),
                    const SizedBox(height: 10),
                    _buildRarityBar('RARE', p.rareCount, p.totalEncounters, const Color(0xFF2C75D8)),
                    const SizedBox(height: 10),
                    _buildRarityBar('EPIC', p.epicCount, p.totalEncounters, const Color(0xFF9447D1)),
                    const SizedBox(height: 10),
                    _buildRarityBar('LEGENDARY', p.legendaryCount, p.totalEncounters, const Color(0xFFE5A912)),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Settings Shortcut Button
              PixelButton(
                text: 'SYSTEM & SYNC SETTINGS',
                height: 48,
                backgroundColor: RetroPalette.surface,
                textColor: RetroPalette.cream,
                borderColor: RetroPalette.surfaceLight,
                icon: const Icon(Icons.settings, color: RetroPalette.amber, size: 18),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => SettingsScreen(repo: repo),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBigStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: RetroTheme.pixelDisplay(
            fontSize: 22,
            color: RetroPalette.amber,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: RetroTheme.pixelDisplay(
            fontSize: 9,
            color: RetroPalette.textMuted,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildRarityBar(String tier, int count, int total, Color color) {
    final double pct = total > 0 ? (count / total).clamp(0.05, 1.0) : 0.05;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              tier,
              style: RetroTheme.pixelDisplay(
                fontSize: 10,
                color: color,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              '$count ARCHIVED',
              style: RetroTheme.pixelDisplay(fontSize: 10, color: RetroPalette.cream),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: RetroPalette.canvasDark,
            border: Border.all(color: RetroPalette.pixelBorder, width: 1.5),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: pct,
            child: Container(color: color),
          ),
        ),
      ],
    );
  }
}
