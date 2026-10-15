import '../../core/branding/branding.dart';
import 'vehicle.dart';

class Encounter {
  final String id;
  final String vehicleId;
  final String vehicleName;
  final RarityTier tier;
  final DateTime timestamp;
  final String city;
  final String region;
  final double? latitude;
  final double? longitude;
  final String photoUrl;
  final bool isNewDiscovery;
  final int xpAwarded;

  const Encounter({
    required this.id,
    required this.vehicleId,
    required this.vehicleName,
    required this.tier,
    required this.timestamp,
    required this.city,
    required this.region,
    this.latitude,
    this.longitude,
    required this.photoUrl,
    required this.isNewDiscovery,
    required this.xpAwarded,
  });

  factory Encounter.fromJson(Map<String, dynamic> json) {
    return Encounter(
      id: json['id'] ?? '',
      vehicleId: json['vehicle_id'] ?? '',
      vehicleName: json['vehicle_name'] ?? 'Unknown',
      tier: RarityTier.fromString(json['tier'] ?? 'COMMON'),
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
      city: json['city'] ?? 'Mysuru',
      region: json['region'] ?? 'Karnataka',
      latitude: json['latitude'] != null ? (json['latitude'] as num).toDouble() : null,
      longitude: json['longitude'] != null ? (json['longitude'] as num).toDouble() : null,
      photoUrl: json['photo_url'] ?? '',
      isNewDiscovery: json['is_new_discovery'] ?? true,
      xpAwarded: json['xp_awarded'] ?? 50,
    );
  }
}

class UserCollectionItem {
  final Vehicle vehicle;
  final int encounterCount;
  final DateTime firstDiscoveredAt;
  final DateTime latestDiscoveredAt;
  final String primaryPhotoUrl;
  final String firstCity;
  final String latestCity;

  const UserCollectionItem({
    required this.vehicle,
    required this.encounterCount,
    required this.firstDiscoveredAt,
    required this.latestDiscoveredAt,
    required this.primaryPhotoUrl,
    required this.firstCity,
    required this.latestCity,
  });

  factory UserCollectionItem.fromJson(Map<String, dynamic> json) {
    return UserCollectionItem(
      vehicle: Vehicle.fromJson(json['vehicle'] ?? {}),
      encounterCount: json['encounter_count'] ?? 1,
      firstDiscoveredAt: DateTime.tryParse(json['first_discovered_at'] ?? '') ?? DateTime.now(),
      latestDiscoveredAt: DateTime.tryParse(json['latest_discovered_at'] ?? '') ?? DateTime.now(),
      primaryPhotoUrl: json['primary_photo_url'] ?? '',
      firstCity: json['first_city'] ?? 'Mysuru',
      latestCity: json['latest_city'] ?? 'Mysuru',
    );
  }
}

class MapMarkerData {
  final String id;
  final String vehicleId;
  final String vehicleName;
  final RarityTier tier;
  final double latitude;
  final double longitude;
  final String city;
  final DateTime timestamp;
  final String photoUrl;

  const MapMarkerData({
    required this.id,
    required this.vehicleId,
    required this.vehicleName,
    required this.tier,
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.timestamp,
    required this.photoUrl,
  });

  factory MapMarkerData.fromJson(Map<String, dynamic> json) {
    return MapMarkerData(
      id: json['id'] ?? '',
      vehicleId: json['vehicle_id'] ?? '',
      vehicleName: json['vehicle_name'] ?? 'Unknown',
      tier: RarityTier.fromString(json['tier'] ?? 'COMMON'),
      latitude: (json['latitude'] ?? 12.2958 as num).toDouble(),
      longitude: (json['longitude'] ?? 76.6394 as num).toDouble(),
      city: json['city'] ?? 'Mysuru',
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
      photoUrl: json['photo_url'] ?? '',
    );
  }
}
