import '../../core/branding/branding.dart';

class VehicleSpecification {
  final String engine;
  final String? displacement;
  final String? cylinders;
  final String? aspiration;
  final int horsepower;
  final int? torqueNm;
  final String transmission;
  final String drivetrain;
  final int? curbWeightKg;
  final int? topSpeedKmh;
  final double? zeroToHundredSec;
  final String? productionYears;

  const VehicleSpecification({
    required this.engine,
    this.displacement,
    this.cylinders,
    this.aspiration,
    required this.horsepower,
    this.torqueNm,
    required this.transmission,
    required this.drivetrain,
    this.curbWeightKg,
    this.topSpeedKmh,
    this.zeroToHundredSec,
    this.productionYears,
  });

  factory VehicleSpecification.fromJson(Map<String, dynamic> json) {
    return VehicleSpecification(
      engine: json['engine'] ?? '',
      displacement: json['displacement'],
      cylinders: json['cylinders'],
      aspiration: json['aspiration'],
      horsepower: json['horsepower'] ?? 0,
      torqueNm: json['torque_nm'],
      transmission: json['transmission'] ?? '',
      drivetrain: json['drivetrain'] ?? '',
      curbWeightKg: json['curb_weight_kg'],
      topSpeedKmh: json['top_speed_kmh'],
      zeroToHundredSec: json['zero_to_hundred_sec'] != null
          ? (json['zero_to_hundred_sec'] as num).toDouble()
          : null,
      productionYears: json['production_years'],
    );
  }
}

class VehicleRarityModel {
  final RarityTier tier;
  final double rarityScore;
  final int? productionVolume;
  final String? estimatedPrevalence;
  final int? ageYears;
  final String? regionalAvailability;
  final int baseXP;

  const VehicleRarityModel({
    required this.tier,
    required this.rarityScore,
    this.productionVolume,
    this.estimatedPrevalence,
    this.ageYears,
    this.regionalAvailability,
    required this.baseXP,
  });

  factory VehicleRarityModel.fromJson(Map<String, dynamic> json) {
    final tierStr = json['tier'] ?? 'COMMON';
    final tier = RarityTier.fromString(tierStr);
    return VehicleRarityModel(
      tier: tier,
      rarityScore: (json['rarity_score'] ?? 50.0 as num).toDouble(),
      productionVolume: json['production_volume'],
      estimatedPrevalence: json['estimated_current_prevalence'],
      ageYears: json['age_years'],
      regionalAvailability: json['regional_availability'],
      baseXP: json['base_xp'] ?? tier.baseXP,
    );
  }
}

class VehicleLoreModel {
  final List<String> documentedNicknames;
  final List<String> communityNicknames;
  final String history;
  final String? motorsport;
  final List<String> interestingFacts;
  final List<String> trivia;

  const VehicleLoreModel({
    this.documentedNicknames = const [],
    this.communityNicknames = const [],
    required this.history,
    this.motorsport,
    this.interestingFacts = const [],
    this.trivia = const [],
  });

  factory VehicleLoreModel.fromJson(Map<String, dynamic> json) {
    return VehicleLoreModel(
      documentedNicknames: List<String>.from(json['documented_nicknames'] ?? []),
      communityNicknames: List<String>.from(json['community_nicknames'] ?? []),
      history: json['history'] ?? '',
      motorsport: json['motorsport'],
      interestingFacts: List<String>.from(json['interesting_facts'] ?? []),
      trivia: List<String>.from(json['trivia'] ?? []),
    );
  }
}

class Vehicle {
  final String id;
  final String canonicalName;
  final String displayYearRange;
  final String make;
  final String model;
  final String generationCode;
  final String variantName;
  final String country;
  final String category;
  final RarityTier tier;
  final String? photoUrl;
  final String? pixelArtSprite;
  final VehicleSpecification? specifications;
  final VehicleRarityModel? rarity;
  final VehicleLoreModel? lore;

  const Vehicle({
    required this.id,
    required this.canonicalName,
    required this.displayYearRange,
    required this.make,
    required this.model,
    required this.generationCode,
    required this.variantName,
    required this.country,
    required this.category,
    required this.tier,
    this.photoUrl,
    this.pixelArtSprite,
    this.specifications,
    this.rarity,
    this.lore,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    final tier = RarityTier.fromString(json['tier'] ?? 'COMMON');
    return Vehicle(
      id: json['id'] ?? '',
      canonicalName: json['canonical_name'] ?? '',
      displayYearRange: json['display_year_range'] ?? '',
      make: json['make'] ?? '',
      model: json['model'] ?? '',
      generationCode: json['generation_code'] ?? '',
      variantName: json['variant_name'] ?? '',
      country: json['country'] ?? '',
      category: json['category'] ?? '',
      tier: tier,
      photoUrl: json['photo_url'],
      pixelArtSprite: json['pixel_art_sprite'],
      specifications: json['specifications'] != null
          ? VehicleSpecification.fromJson(json['specifications'])
          : null,
      rarity: json['rarity'] != null
          ? VehicleRarityModel.fromJson(json['rarity'])
          : null,
      lore: json['lore'] != null ? VehicleLoreModel.fromJson(json['lore']) : null,
    );
  }
}
