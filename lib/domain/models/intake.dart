import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'beverage.dart';

part 'intake.g.dart';

/// Model representing a single caffeine intake entry
@HiveType(typeId: 7)
class Intake extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final Beverage beverage;

  @HiveField(2)
  final DateTime timestamp;

  Intake({
    required this.id,
    required this.beverage,
    required this.timestamp,
  });

  /// Create an Intake from JSON
  factory Intake.fromJson(Map<String, dynamic> json) {
    return Intake(
      id: json['id'] as String,
      beverage: Beverage.fromJson(json['beverage'] as Map<String, dynamic>),
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int),
    );
  }

  /// Convert Intake to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'beverage': beverage.toJson(),
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  /// Check if this intake is from today
  bool get isToday {
    final now = DateTime.now();
    return timestamp.year == now.year &&
           timestamp.month == now.month &&
           timestamp.day == now.day;
  }

  /// Check if this intake is from a specific date
  bool isFromDate(DateTime date) {
    return timestamp.year == date.year &&
           timestamp.month == date.month &&
           timestamp.day == date.day;
  }

  /// Get formatted time string (HH:mm)
  String get formattedTime {
    return DateFormat.Hm().format(timestamp);
  }

  /// Get formatted time string with locale support
  String getFormattedTime([String? locale]) {
    return DateFormat.Hm(locale).format(timestamp);
  }

  /// Get formatted date string (dd/MM/yyyy)
  String get formattedDate {
    return DateFormat('dd/MM/yyyy').format(timestamp);
  }

  /// Get formatted date string with locale support
  String getFormattedDate([String? locale]) {
    return DateFormat.yMd(locale).format(timestamp);
  }

  /// Get formatted datetime string (dd/MM/yyyy HH:mm)
  String get formattedDateTime {
    return DateFormat('dd/MM/yyyy HH:mm').format(timestamp);
  }

  /// Get formatted datetime string with locale support
  String getFormattedDateTime([String? locale]) {
    return DateFormat.yMd(locale).add_Hm().format(timestamp);
  }

  /// Get relative time string (e.g., "2 hours ago", "Yesterday", etc.)
  String get relativeTime {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Ora';
        } else {
          return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minuto' : 'minuti'} fa';
        }
      } else {
        return '${difference.inHours} ${difference.inHours == 1 ? 'ora' : 'ore'} fa';
      }
    } else if (difference.inDays == 1) {
      return 'Ieri alle $formattedTime';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} giorni fa';
    } else {
      return formattedDate;
    }
  }

  /// Get day name in Italian
  String get dayName {
    const dayNames = [
      'Lunedì',
      'Martedì',
      'Mercoledì',
      'Giovedì',
      'Venerdì',
      'Sabato',
      'Domenica'
    ];
    return dayNames[timestamp.weekday - 1];
  }

  /// Get month name in Italian
  String get monthName {
    const monthNames = [
      'Gennaio',
      'Febbraio',
      'Marzo',
      'Aprile',
      'Maggio',
      'Giugno',
      'Luglio',
      'Agosto',
      'Settembre',
      'Ottobre',
      'Novembre',
      'Dicembre'
    ];
    return monthNames[timestamp.month - 1];
  }

  /// Get formatted date with Italian day and month names
  String get formattedDateItalian {
    return '$dayName, ${timestamp.day} $monthName ${timestamp.year}';
  }

  /// Create a copy with updated values
  Intake copyWith({
    String? id,
    Beverage? beverage,
    DateTime? timestamp,
  }) {
    return Intake(
      id: id ?? this.id,
      beverage: beverage ?? this.beverage,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  String toString() {
    return 'Intake(id: $id, beverage: ${beverage.name}, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Intake && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
