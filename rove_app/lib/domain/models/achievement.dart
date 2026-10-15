class AchievementModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String badgePixelIcon;
  final int xpReward;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  const AchievementModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.badgePixelIcon,
    required this.xpReward,
    required this.isUnlocked,
    this.unlockedAt,
  });

  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? 'MILESTONE',
      badgePixelIcon: json['badge_pixel_icon'] ?? 'pixel_badge_generic',
      xpReward: json['xp_reward'] ?? 50,
      isUnlocked: json['is_unlocked'] ?? false,
      unlockedAt: json['unlocked_at'] != null
          ? DateTime.tryParse(json['unlocked_at'])
          : null,
    );
  }
}
