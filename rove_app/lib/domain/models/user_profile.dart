class UserProfile {
  final String username;
  final int level;
  final String title;
  final int currentXP;
  final int totalEncounters;
  final int uniqueVehicles;
  final int commonCount;
  final int uncommonCount;
  final int rareCount;
  final int epicCount;
  final int legendaryCount;
  final int mythicCount;
  final int citiesDiscovered;
  final int manufacturersDiscovered;

  const UserProfile({
    required this.username,
    required this.level,
    required this.title,
    required this.currentXP,
    required this.totalEncounters,
    required this.uniqueVehicles,
    required this.commonCount,
    required this.uncommonCount,
    required this.rareCount,
    required this.epicCount,
    required this.legendaryCount,
    required this.mythicCount,
    required this.citiesDiscovered,
    required this.manufacturersDiscovered,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      username: json['username'] ?? 'PURU',
      level: json['level'] ?? 1,
      title: json['title'] ?? 'NOVICE SPOTTER',
      currentXP: json['current_xp'] ?? 0,
      totalEncounters: json['total_encounters'] ?? 0,
      uniqueVehicles: json['unique_vehicles'] ?? 0,
      commonCount: json['common_count'] ?? 0,
      uncommonCount: json['uncommon_count'] ?? 0,
      rareCount: json['rare_count'] ?? 0,
      epicCount: json['epic_count'] ?? 0,
      legendaryCount: json['legendary_count'] ?? 0,
      mythicCount: json['mythic_count'] ?? 0,
      citiesDiscovered: json['cities_discovered'] ?? 1,
      manufacturersDiscovered: json['manufacturers_discovered'] ?? 0,
    );
  }
}
