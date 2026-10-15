import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../domain/models/vehicle.dart';
import '../domain/models/encounter.dart';
import '../domain/models/achievement.dart';
import '../domain/models/user_profile.dart';
import '../data/seed/demo_seed_data.dart';
import '../core/branding/branding.dart';

class RoveRepository extends ChangeNotifier {
  // Backend URL (Defaults to localhost, switchable in settings)
  String _backendUrl = 'http://localhost:8000';
  bool _isDemoMode = true;
  bool _isBackendConnected = false;

  // In-Memory state
  UserProfile _profile = DemoSeedData.defaultProfile;
  List<UserCollectionItem> _collection = List.from(DemoSeedData.initialCollection);
  List<AchievementModel> _achievements = List.from(DemoSeedData.demoAchievements);
  List<MapMarkerData> _mapMarkers = List.from(DemoSeedData.demoMapMarkers);
  final List<Vehicle> _catalogue = List.from(DemoSeedData.demoVehicles);

  UserProfile get profile => _profile;
  List<UserCollectionItem> get collection => _collection;
  List<AchievementModel> get achievements => _achievements;
  List<MapMarkerData> get mapMarkers => _mapMarkers;
  List<Vehicle> get catalogue => _catalogue;
  bool get isDemoMode => _isDemoMode;
  bool get isBackendConnected => _isBackendConnected;
  String get backendUrl => _backendUrl;

  RoveRepository({bool autoSync = true}) {
    if (autoSync) {
      _initRepository();
    }
  }

  void setBackendUrl(String url) {
    _backendUrl = url;
    checkBackendHealth();
  }

  void toggleDemoMode(bool value) {
    _isDemoMode = value;
    notifyListeners();
  }

  Future<void> _initRepository() async {
    await checkBackendHealth();
  }

  Future<bool> checkBackendHealth() async {
    try {
      final res = await http.get(Uri.parse('$_backendUrl/')).timeout(
        const Duration(seconds: 2),
      );
      if (res.statusCode == 200) {
        _isBackendConnected = true;
        await syncFromBackend();
        notifyListeners();
        return true;
      }
    } catch (_) {
      _isBackendConnected = false;
    }
    notifyListeners();
    return false;
  }

  Future<void> syncFromBackend() async {
    if (!_isBackendConnected) return;

    try {
      // 1. Fetch Stats
      final statsRes = await http.get(Uri.parse('$_backendUrl/stats'));
      if (statsRes.statusCode == 200) {
        _profile = UserProfile.fromJson(jsonDecode(statsRes.body));
      }

      // 2. Fetch Collection
      final colRes = await http.get(Uri.parse('$_backendUrl/collection'));
      if (colRes.statusCode == 200) {
        final List list = jsonDecode(colRes.body);
        _collection = list.map((item) => UserCollectionItem.fromJson(item)).toList();
      }

      // 3. Fetch Map Markers
      final mapRes = await http.get(Uri.parse('$_backendUrl/encounters/map'));
      if (mapRes.statusCode == 200) {
        final List list = jsonDecode(mapRes.body);
        _mapMarkers = list.map((item) => MapMarkerData.fromJson(item)).toList();
      }

      // 4. Fetch Achievements
      final achRes = await http.get(Uri.parse('$_backendUrl/achievements'));
      if (achRes.statusCode == 200) {
        final List list = jsonDecode(achRes.body);
        _achievements = list.map((item) => AchievementModel.fromJson(item)).toList();
      }
      notifyListeners();
    } catch (_) {
      // Keep local state
    }
  }

  /// AI Identification: Matches image hint or chooses from demo preset
  Future<Map<String, dynamic>> identifyVehicle({
    String? imageHint,
    bool forceLowConfidence = false,
  }) async {
    if (_isBackendConnected && !_isDemoMode) {
      try {
        final res = await http.post(
          Uri.parse('$_backendUrl/identify'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'image_name_hint': imageHint,
            'force_low_confidence': forceLowConfidence,
          }),
        );
        if (res.statusCode == 200) {
          final data = jsonDecode(res.body);
          final matchedJson = data['matched_vehicle'];
          final vehicle = matchedJson != null ? Vehicle.fromJson(matchedJson) : _catalogue[0];
          return {
            'vehicle': vehicle,
            'confidence': (data['confidence'] as num).toDouble(),
            'is_low_confidence': data['is_low_confidence'] as bool,
            'alternatives': data['alternative_candidates'] ?? [],
          };
        }
      } catch (_) {
        // Fallback to local
      }
    }

    // Local Mock Provider
    await Future.delayed(const Duration(milliseconds: 700)); // Simulated retro scan latency

    Vehicle chosen = _catalogue[0];
    if (imageHint != null) {
      final hint = imageHint.toLowerCase();
      for (final v in _catalogue) {
        if (v.canonicalName.toLowerCase().contains(hint) ||
            v.make.toLowerCase().contains(hint) ||
            v.generationCode.toLowerCase().contains(hint)) {
          chosen = v;
          break;
        }
      }
    }

    final double confidence = forceLowConfidence ? 0.62 : 0.94;
    final bool isLow = confidence < 0.75;

    final alternatives = [
      {'make': chosen.make, 'model': chosen.model, 'generation': chosen.generationCode, 'variant': 'Clubsport Spec', 'confidence': 0.65},
      {'make': chosen.make, 'model': chosen.model, 'generation': 'Alternative Gen', 'variant': 'Roadster', 'confidence': 0.52},
    ];

    return {
      'vehicle': chosen,
      'confidence': confidence,
      'is_low_confidence': isLow,
      'alternatives': alternatives,
    };
  }

  /// Confirm Capture and record discovery
  Future<Map<String, dynamic>> confirmCapture({
    required Vehicle vehicle,
    String city = 'Mysuru',
    String region = 'Karnataka',
    double? latitude,
    double? longitude,
    String? photoUrl,
    double aiConfidence = 0.95,
  }) async {
    final photo = photoUrl ?? vehicle.photoUrl ?? 'https://images.unsplash.com/photo-1580273916550-e323be2ae537?w=800';

    if (_isBackendConnected && !_isDemoMode) {
      try {
        final res = await http.post(
          Uri.parse('$_backendUrl/capture/confirm'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'vehicle_id': vehicle.id,
            'captured_image_url': photo,
            'city': city,
            'region': region,
            'latitude': latitude ?? 12.2958,
            'longitude': longitude ?? 76.6394,
            'ai_confidence': aiConfidence,
          }),
        );
        if (res.statusCode == 200) {
          final data = jsonDecode(res.body);
          await syncFromBackend();
          return {
            'is_new_discovery': data['is_new_discovery'],
            'encounter_count': data['encounter_count'],
            'xp_awarded': data['xp_awarded'],
            'new_total_xp': data['new_total_xp'],
            'current_level': data['current_level'],
            'title': data['title'],
            'unlocked_achievements': data['unlocked_achievements'],
          };
        }
      } catch (_) {
        // Fallback to local
      }
    }

    // Local State Management
    final existingIndex = _collection.indexWhere((c) => c.vehicle.id == vehicle.id);
    final bool isNew = existingIndex == -1;
    final int xpAwarded = isNew ? vehicle.tier.baseXP : 25;
    int encounterCount = 1;

    if (isNew) {
      final newItem = UserCollectionItem(
        vehicle: vehicle,
        encounterCount: 1,
        firstDiscoveredAt: DateTime.now(),
        latestDiscoveredAt: DateTime.now(),
        primaryPhotoUrl: photo,
        firstCity: city,
        latestCity: city,
      );
      _collection.insert(0, newItem);
    } else {
      final prev = _collection[existingIndex];
      encounterCount = prev.encounterCount + 1;
      _collection[existingIndex] = UserCollectionItem(
        vehicle: prev.vehicle,
        encounterCount: encounterCount,
        firstDiscoveredAt: prev.firstDiscoveredAt,
        latestDiscoveredAt: DateTime.now(),
        primaryPhotoUrl: photo,
        firstCity: prev.firstCity,
        latestCity: city,
      );
    }

    // Add Map Marker
    _mapMarkers.insert(
      0,
      MapMarkerData(
        id: 'marker_${DateTime.now().millisecondsSinceEpoch}',
        vehicleId: vehicle.id,
        vehicleName: vehicle.canonicalName,
        tier: vehicle.tier,
        latitude: latitude ?? (12.2958 + (_mapMarkers.length * 0.01)),
        longitude: longitude ?? (76.6394 + (_mapMarkers.length * 0.01)),
        city: city,
        timestamp: DateTime.now(),
        photoUrl: photo,
      ),
    );

    // Update Profile Stats
    final newXP = _profile.currentXP + xpAwarded;
    final newLevel = 1 + (newXP ~/ 150);
    String title = 'NOVICE SPOTTER';
    if (newLevel >= 15) {
      title = 'PADDOCK SCOUT';
    } else if (newLevel >= 10) {
      title = 'ROAD HUNTER';
    } else if (newLevel >= 6) {
      title = 'CURB DETECTIVE';
    } else if (newLevel >= 3) {
      title = 'STREET SCOUT';
    }

    _profile = UserProfile(
      username: _profile.username,
      level: newLevel,
      title: title,
      currentXP: newXP,
      totalEncounters: _profile.totalEncounters + 1,
      uniqueVehicles: _collection.length,
      commonCount: _profile.commonCount + (isNew && vehicle.tier == RarityTier.common ? 1 : 0),
      uncommonCount: _profile.uncommonCount + (isNew && vehicle.tier == RarityTier.uncommon ? 1 : 0),
      rareCount: _profile.rareCount + (isNew && vehicle.tier == RarityTier.rare ? 1 : 0),
      epicCount: _profile.epicCount + (isNew && vehicle.tier == RarityTier.epic ? 1 : 0),
      legendaryCount: _profile.legendaryCount + (isNew && vehicle.tier == RarityTier.legendary ? 1 : 0),
      mythicCount: _profile.mythicCount + (isNew && vehicle.tier == RarityTier.mythic ? 1 : 0),
      citiesDiscovered: _profile.citiesDiscovered,
      manufacturersDiscovered: _profile.manufacturersDiscovered,
    );

    notifyListeners();

    return {
      'is_new_discovery': isNew,
      'encounter_count': encounterCount,
      'xp_awarded': xpAwarded,
      'new_total_xp': newXP,
      'current_level': newLevel,
      'title': title,
      'unlocked_achievements': [],
    };
  }

  void resetDemo() {
    _profile = const UserProfile(
      username: 'PURU',
      level: 1,
      title: 'NOVICE SPOTTER',
      currentXP: 0,
      totalEncounters: 0,
      uniqueVehicles: 0,
      commonCount: 0,
      uncommonCount: 0,
      rareCount: 0,
      epicCount: 0,
      legendaryCount: 0,
      mythicCount: 0,
      citiesDiscovered: 1,
      manufacturersDiscovered: 0,
    );
    _collection.clear();
    _mapMarkers.clear();
    notifyListeners();
  }

  void seedStarter() {
    _profile = DemoSeedData.defaultProfile;
    _collection = List.from(DemoSeedData.initialCollection);
    _mapMarkers = List.from(DemoSeedData.demoMapMarkers);
    _achievements = List.from(DemoSeedData.demoAchievements);
    notifyListeners();
  }
}
