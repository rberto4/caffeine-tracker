import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';

part 'beverage.g.dart';

/// Model representing a beverage with its properties
@HiveType(typeId: 6)
class Beverage extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final double volume; // in ml

  @HiveField(3)
  final double caffeineAmount; // in mg

  @HiveField(4)
  final int colorIndex; // index in AppColors.beverageColors

  @HiveField(5)
  final int imageIndex; // index in BeverageAssets.allImages

  Beverage({
    required this.id,
    required this.name,
    required this.volume,
    required this.caffeineAmount,
    required this.colorIndex,
    required this.imageIndex,
  });

  /// Get the color associated with this beverage
  Color get color => AppColors.getBeverageColor(colorIndex);

  /// Get the image asset path for this beverage
  String get imagePath => BeverageAssets.getBeverageImage(imageIndex);

  /// Create a Beverage from JSON
  factory Beverage.fromJson(Map<String, dynamic> json) {
    return Beverage(
      id: json['id'] as String,
      name: json['name'] as String,
      volume: (json['volume'] as num).toDouble(),
      caffeineAmount: (json['caffeineAmount'] as num).toDouble(),
      colorIndex: json['colorIndex'] as int? ?? 0,
      imageIndex: json['imageIndex'] as int? ?? 0,
    );
  }

  /// Convert Beverage to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'volume': volume,
      'caffeineAmount': caffeineAmount,
      'colorIndex': colorIndex,
      'imageIndex': imageIndex,
    };
  }

  /// Create a copy with updated values
  Beverage copyWith({
    String? id,
    String? name,
    double? volume,
    double? caffeineAmount,
    int? colorIndex,
    int? imageIndex,
  }) {
    return Beverage(
      id: id ?? this.id,
      name: name ?? this.name,
      volume: volume ?? this.volume,
      caffeineAmount: caffeineAmount ?? this.caffeineAmount,
      colorIndex: colorIndex ?? this.colorIndex,
      imageIndex: imageIndex ?? this.imageIndex,
    );
  }

  /// Create a beverage with suggested color and image based on name
  factory Beverage.withSuggestions({
    required String id,
    required String name,
    required double volume,
    required double caffeineAmount,
    int? colorIndex,
    int? imageIndex,
  }) {
    // Suggest color based on beverage type
    int suggestedColorIndex = colorIndex ?? _getSuggestedColorIndex(name);
    
    // Suggest image based on beverage type
    int suggestedImageIndex = imageIndex ?? _getSuggestedImageIndex(name);

    return Beverage(
      id: id,
      name: name,
      volume: volume,
      caffeineAmount: caffeineAmount,
      colorIndex: suggestedColorIndex,
      imageIndex: suggestedImageIndex,
    );
  }

  /// Get suggested color index based on beverage name
  static int _getSuggestedColorIndex(String name) {
    final lowerName = name.toLowerCase();
    
    if (lowerName.contains('coffee') || lowerName.contains('espresso')) {
      return 4; // Red/Brown
    } else if (lowerName.contains('tea')) {
      return 1; // Green
    } else if (lowerName.contains('energy')) {
      return 2; // Orange
    } else if (lowerName.contains('cola') || lowerName.contains('soda')) {
      return 0; // Blue
    } else if (lowerName.contains('chocolate') || lowerName.contains('cocoa')) {
      return 3; // Purple
    } else {
      return 5; // Teal as default
    }
  }

  /// Get suggested image index based on beverage name
  static int _getSuggestedImageIndex(String name) {
    final suggestedImage = BeverageAssets.getSuggestedImageForType(name);
    return BeverageAssets.allImages.indexOf(suggestedImage);
  }

  @override
  String toString() {
    return 'Beverage(id: $id, name: $name, volume: ${volume}ml, caffeine: ${caffeineAmount}mg)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Beverage && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
