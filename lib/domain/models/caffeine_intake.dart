import 'package:hive/hive.dart';

part 'caffeine_intake.g.dart';

/// Model representing a single caffeine intake entry
@HiveType(typeId: 0)
class CaffeineIntake extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String productName;

  @HiveField(2)
  final double caffeineAmount; // in mg

  @HiveField(3)
  final DateTime timestamp;

  @HiveField(4)
  final String? barcode;

  @HiveField(5)
  final double? quantity;

  CaffeineIntake({
    required this.id,
    required this.productName,
    required this.caffeineAmount,
    required this.timestamp,
    this.barcode,
    this.quantity,
  });

  /// Create a CaffeineIntake from JSON
  factory CaffeineIntake.fromJson(Map<String, dynamic> json) {
    return CaffeineIntake(
      id: json['id'] as String,
      productName: json['productName'] as String,
      caffeineAmount: (json['caffeineAmount'] as num).toDouble(),
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int),
      barcode: json['barcode'] as String?,
      quantity: json['quantity'] != null ? (json['quantity'] as num).toDouble() : null,
    );
  }

  /// Convert CaffeineIntake to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productName': productName,
      'caffeineAmount': caffeineAmount,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'barcode': barcode,
      'quantity': quantity,
    };
  }

  /// Check if this intake is from today
  bool get isToday {
    final now = DateTime.now();
    return timestamp.year == now.year &&
           timestamp.month == now.month &&
           timestamp.day == now.day;
  }

  /// Get formatted time string
  String get formattedTime {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  /// Get formatted date string
  String get formattedDate {
    return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
  }

  @override
  String toString() {
    return 'CaffeineIntake(id: $id, productName: $productName, caffeineAmount: $caffeineAmount, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CaffeineIntake && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
