import 'package:hive/hive.dart';

part 'user_profile.g.dart';

/// Enum representing user gender
@HiveType(typeId: 2)
enum Gender {
  @HiveField(0)
  male,
  @HiveField(1)
  female;

  String get displayName {
    switch (this) {
      case Gender.male:
        return 'Uomo';
      case Gender.female:
        return 'Donna';
    }
  }
}

/// Enum representing weight measurement units
@HiveType(typeId: 3)
enum WeightUnit {
  @HiveField(0)
  kg,
  @HiveField(1)
  lbs;

  String get displayName {
    switch (this) {
      case WeightUnit.kg:
        return 'Kg';
      case WeightUnit.lbs:
        return 'Lbs';
    }
  }

  String get abbreviation {
    switch (this) {
      case WeightUnit.kg:
        return 'kg';
      case WeightUnit.lbs:
        return 'lbs';
    }
  }
}

/// Enum representing volume/liquid measurement units
@HiveType(typeId: 4)
enum VolumeUnit {
  @HiveField(0)
  ml,
  @HiveField(1)
  l,
  @HiveField(2)
  oz;

  String get displayName {
    switch (this) {
      case VolumeUnit.ml:
        return 'Millilitri';
      case VolumeUnit.l:
        return 'Litri';
      case VolumeUnit.oz:
        return 'Once fluide';
    }
  }

  String get abbreviation {
    switch (this) {
      case VolumeUnit.ml:
        return 'ml';
      case VolumeUnit.l:
        return 'l';
      case VolumeUnit.oz:
        return 'fl oz';
    }
  }

  /// Convert volume to milliliters
  double toMl(double value) {
    switch (this) {
      case VolumeUnit.ml:
        return value;
      case VolumeUnit.l:
        return value * 1000;
      case VolumeUnit.oz:
        return value * 29.5735; // 1 fl oz = 29.5735 ml
    }
  }

  /// Convert from milliliters to this unit
  double fromMl(double ml) {
    switch (this) {
      case VolumeUnit.ml:
        return ml;
      case VolumeUnit.l:
        return ml / 1000;
      case VolumeUnit.oz:
        return ml / 29.5735;
    }
  }
}

/// Enum representing caffeine measurement units
@HiveType(typeId: 5)
enum CaffeineUnit {
  @HiveField(0)
  mg,
  @HiveField(1)
  oz;

  String get displayName {
    switch (this) {
      case CaffeineUnit.mg:
        return 'Milligrammi';
      case CaffeineUnit.oz:
        return 'Once';
    }
  }

  String get abbreviation {
    switch (this) {
      case CaffeineUnit.mg:
        return 'mg';
      case CaffeineUnit.oz:
        return 'oz';
    }
  }

  /// Convert caffeine to milligrams
  double toMg(double value) {
    switch (this) {
      case CaffeineUnit.mg:
        return value;
      case CaffeineUnit.oz:
        return value * 28349.5; // 1 oz = 28349.5 mg
    }
  }

  /// Convert from milligrams to this unit
  double fromMg(double mg) {
    switch (this) {
      case CaffeineUnit.mg:
        return mg;
      case CaffeineUnit.oz:
        return mg / 28349.5;
    }
  }
}

/// Model representing user profile information
@HiveType(typeId: 1)
class UserProfile {
  @HiveField(0)
  final double weight; // in kg or lbs depending on unit
  @HiveField(1)
  final int age; // in years
  @HiveField(2)
  final Gender gender;
  @HiveField(3)
  final WeightUnit weightUnit;
  @HiveField(4)
  final CaffeineUnit caffeineUnit;
  @HiveField(5)
  final DateTime createdAt;
  @HiveField(6)
  final DateTime updatedAt;
  @HiveField(7)
  final VolumeUnit volumeUnit;

  UserProfile({
    required this.weight,
    required this.age,
    required this.gender,
    this.weightUnit = WeightUnit.kg,
    this.caffeineUnit = CaffeineUnit.mg,
    this.volumeUnit = VolumeUnit.ml,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Get weight in kg regardless of unit setting
  double get weightInKg {
    return weightUnit == WeightUnit.kg ? weight : weight * 0.453592; // lbs to kg
  }

  /// Convert caffeine amount to display unit
  double convertCaffeineAmount(double amountInMg) {
    return caffeineUnit.fromMg(amountInMg);
  }

  /// Convert caffeine amount from display unit to mg
  double convertCaffeineToMg(double displayAmount) {
    return caffeineUnit.toMg(displayAmount);
  }

  /// Convert volume amount to display unit
  double convertVolumeAmount(double amountInMl) {
    return volumeUnit.fromMl(amountInMl);
  }

  /// Convert volume amount from display unit to ml
  double convertVolumeToMl(double displayAmount) {
    return volumeUnit.toMl(displayAmount);
  }

  /// Calculate maximum daily caffeine intake based on weight, age, and gender
  double get maxDailyCaffeine {
    // Youth under 18: max 100mg per day
    if (age < 18) {
      return 100.0;
    }
    
    // Adults: max 6mg per kg body weight, but not exceeding 400mg
    // Adjust slightly for gender (women typically process caffeine slightly slower)
    double multiplier = gender == Gender.female ? 5.5 : 6.0;
    final calculatedMax = weightInKg * multiplier;
    return calculatedMax > 400.0 ? 400.0 : calculatedMax;
  }

  /// Get caffeine intake status based on current intake
  CaffeineStatus getCaffeineStatus(double currentIntake) {
    final maxIntake = maxDailyCaffeine;
    final percentage = (currentIntake / maxIntake) * 100;

    if (percentage <= 50) {
      return CaffeineStatus.low;
    } else if (percentage <= 75) {
      return CaffeineStatus.moderate;
    } else if (percentage <= 100) {
      return CaffeineStatus.high;
    } else {
      return CaffeineStatus.excessive;
    }
  }

  /// Create UserProfile from JSON
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      weight: (json['weight'] as num).toDouble(),
      age: json['age'] as int,
      gender: Gender.values[json['gender'] as int? ?? 0],
      weightUnit: WeightUnit.values[json['weightUnit'] as int? ?? 0],
      caffeineUnit: CaffeineUnit.values[json['caffeineUnit'] as int? ?? 0],
      volumeUnit: VolumeUnit.values[json['volumeUnit'] as int? ?? 0],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt'] as int),
    );
  }

  /// Convert UserProfile to JSON
  Map<String, dynamic> toJson() {
    return {
      'weight': weight,
      'age': age,
      'gender': gender.index,
      'weightUnit': weightUnit.index,
      'caffeineUnit': caffeineUnit.index,
      'volumeUnit': volumeUnit.index,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  /// Create a copy with updated values
  UserProfile copyWith({
    double? weight,
    int? age,
    Gender? gender,
    WeightUnit? weightUnit,
    CaffeineUnit? caffeineUnit,
    VolumeUnit? volumeUnit,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      weight: weight ?? this.weight,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      weightUnit: weightUnit ?? this.weightUnit,
      caffeineUnit: caffeineUnit ?? this.caffeineUnit,
      volumeUnit: volumeUnit ?? this.volumeUnit,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'UserProfile(weight: $weight${weightUnit.abbreviation}, age: $age, gender: ${gender.displayName}, volumeUnit: ${volumeUnit.abbreviation}, maxDailyCaffeine: $maxDailyCaffeine${caffeineUnit.abbreviation})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile &&
           other.weight == weight &&
           other.age == age &&
           other.gender == gender &&
           other.weightUnit == weightUnit &&
           other.caffeineUnit == caffeineUnit &&
           other.volumeUnit == volumeUnit;
  }

  @override
  int get hashCode => weight.hashCode ^ age.hashCode ^ gender.hashCode ^ weightUnit.hashCode ^ caffeineUnit.hashCode ^ volumeUnit.hashCode;
}

/// Enum representing different caffeine intake status levels
enum CaffeineStatus {
  low,       // 0-50% of daily limit
  moderate,  // 51-75% of daily limit
  high,      // 76-100% of daily limit
  excessive; // >100% of daily limit

  /// Get display name for the status
  String get displayName {
    switch (this) {
      case CaffeineStatus.low:
        return 'Basso';
      case CaffeineStatus.moderate:
        return 'Moderato';
      case CaffeineStatus.high:
        return 'Alto';
      case CaffeineStatus.excessive:
        return 'Eccessivo';
    }
  }

  /// Get color associated with the status
  String get colorHex {
    switch (this) {
      case CaffeineStatus.low:
        return '#4CAF50'; // Green
      case CaffeineStatus.moderate:
        return '#FFEB3B'; // Yellow
      case CaffeineStatus.high:
        return '#FF9800'; // Orange
      case CaffeineStatus.excessive:
        return '#F44336'; // Red
    }
  }
}
