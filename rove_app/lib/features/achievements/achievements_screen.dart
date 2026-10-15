import 'package:flutter/material.dart';
import '../../core/branding/branding.dart';
import '../../core/theme/retro_theme.dart';
import '../../core/widgets/pixel_card.dart';
import '../../domain/models/achievement.dart';
import '../../services/rove_repository.dart';

class AchievementsScreen extends StatelessWidget {
  final RoveRepository repo;

  const AchievementsScreen({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    final achievements = repo.achievements;
    final unlockedCount = achievements.where((a) => a.isUnlocked).length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'BADGES & ACHIEVEMENTS',
          style: RetroTheme.pixelDisplay(fontSize: 15, color: RetroPalette.cream),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '$unlockedCount / ${achievements.length} UNLOCKED',
                style: RetroTheme.pixelDisplay(fontSize: 10, color: RetroPalette.amber),
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: achievements.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final ach = achievements[index];
            return _buildAchievementCard(ach);
          },
        ),
      ),
    );
  }

  Widget _buildAchievementCard(AchievementModel ach) {
    final isUnlocked = ach.isUnlocked;
    final borderColor = isUnlocked ? RetroPalette.amber : RetroPalette.surfaceLight;

    return PixelCard(
      borderColor: borderColor,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // 8-bit Pixel Badge Emblem
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isUnlocked ? RetroPalette.amber.withOpacity(0.2) : RetroPalette.surface,
              border: Border.all(
                color: isUnlocked ? RetroPalette.amber : RetroPalette.asphaltGrey,
                width: 2,
              ),
            ),
            child: Icon(
              isUnlocked ? Icons.verified : Icons.lock_outline,
              color: isUnlocked ? RetroPalette.amber : RetroPalette.asphaltGrey,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      ach.title.toUpperCase(),
                      style: RetroTheme.pixelDisplay(
                        fontSize: 12,
                        color: isUnlocked ? RetroPalette.cream : RetroPalette.textMuted,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      '+${ach.xpReward} XP',
                      style: RetroTheme.pixelDisplay(
                        fontSize: 10,
                        color: isUnlocked ? RetroPalette.amber : RetroPalette.asphaltGrey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  ach.description,
                  style: RetroTheme.readableBody(
                    fontSize: 12,
                    color: isUnlocked ? RetroPalette.cream : RetroPalette.textMuted,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  color: isUnlocked ? RetroPalette.retroGreen.withOpacity(0.2) : RetroPalette.canvasDark,
                  child: Text(
                    isUnlocked ? 'COMPLETED' : 'LOCKED MILESTONE',
                    style: RetroTheme.pixelDisplay(
                      fontSize: 8,
                      color: isUnlocked ? RetroPalette.retroGreen : RetroPalette.asphaltGrey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
