import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/intake.dart';

/// Statistics for caffeine intake
class IntakeStatistics {
  final double totalCaffeine;
  final double averageCaffeine;
  final int totalIntakes;
  final double totalVolume;
  final DateTime? lastIntake;

  IntakeStatistics({
    required this.totalCaffeine,
    required this.averageCaffeine,
    required this.totalIntakes,
    required this.totalVolume,
    this.lastIntake,
  });
}

/// Provider for managing caffeine intakes
class IntakeProvider extends ChangeNotifier {
  static const String _intakesBoxName = 'intakes';
  Box<Intake>? _box;
  List<Intake> _intakes = [];
  bool _isLoading = false;

  List<Intake> intakes (){
    return [..._intakes];
  }
  bool get isLoading => _isLoading;

  /// Get today's intakes
  List<Intake> get todayIntakes {
    return _intakes.where((intake) => intake.isToday).toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  /// Get today's total caffeine
  double get todayTotalCaffeine {
    return todayIntakes.fold(0.0, (sum, intake) => sum + intake.beverage.caffeineAmount);
  }

  /// Get today's total volume
  double get todayTotalVolume {
    return todayIntakes.fold(0.0, (sum, intake) => sum + intake.beverage.volume);
  }

  /// Initialize the provider
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      _box = await Hive.openBox<Intake>(_intakesBoxName);
      await _loadIntakes();
    } catch (e) {
      debugPrint('Error initializing IntakeProvider: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load all intakes from storage
  Future<void> _loadIntakes() async {
    if (_box == null) return;
    _intakes = _box!.values.toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    notifyListeners();
  }

  /// Add a new intake
  Future<void> addIntake(Intake intake) async {
    if (_box == null) return;

    await _box!.put(intake.id, intake);
    _intakes.add(intake);
    _intakes.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    notifyListeners();
  }

  /// Update an existing intake
  Future<void> updateIntake(Intake intake) async {
    if (_box == null) return;

    await _box!.put(intake.id, intake);
    
    final index = _intakes.indexWhere((i) => i.id == intake.id);
    if (index != -1) {
      _intakes[index] = intake;
      _intakes.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    }

    notifyListeners();
  }

  /// Delete an intake
  Future<void> deleteIntake(String id) async {
    if (_box == null) return;

    await _box!.delete(id);
    _intakes.removeWhere((i) => i.id == id);
    notifyListeners();
  }

  /// Get intakes for a specific date
  List<Intake> getIntakesForDate(DateTime date) {
    return _intakes.where((intake) => intake.isFromDate(date)).toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  /// Get total caffeine for a specific date
  double getTotalForDate(DateTime date) {
    return getIntakesForDate(date).fold(
      0.0, 
      (sum, intake) => sum + intake.beverage.caffeineAmount
    );
  }

  /// Get total volume for a specific date
  double getTotalVolumeForDate(DateTime date) {
    return getIntakesForDate(date).fold(
      0.0, 
      (sum, intake) => sum + intake.beverage.volume
    );
  }

  /// Get statistics for a date range
  IntakeStatistics getStatistics({DateTime? startDate, DateTime? endDate}) {
    List<Intake> filteredIntakes = _intakes;

    if (startDate != null) {
      filteredIntakes = filteredIntakes.where((intake) => 
        intake.timestamp.isAfter(startDate.subtract(const Duration(days: 1)))
      ).toList();
    }

    if (endDate != null) {
      filteredIntakes = filteredIntakes.where((intake) => 
        intake.timestamp.isBefore(endDate.add(const Duration(days: 1)))
      ).toList();
    }

    if (filteredIntakes.isEmpty) {
      return IntakeStatistics(
        totalCaffeine: 0.0,
        averageCaffeine: 0.0,
        totalIntakes: 0,
        totalVolume: 0.0,
        lastIntake: null,
      );
    }

    final totalCaffeine = filteredIntakes.fold(0.0, (sum, intake) => sum + intake.beverage.caffeineAmount);
    final totalVolume = filteredIntakes.fold(0.0, (sum, intake) => sum + intake.beverage.volume);
    final totalIntakes = filteredIntakes.length;
    
    // Calculate average per day
    final days = startDate != null && endDate != null 
      ? endDate.difference(startDate).inDays + 1
      : 1;
    final averageCaffeine = totalCaffeine / days;

    final lastIntake = filteredIntakes.isNotEmpty 
      ? filteredIntakes.first.timestamp 
      : null;

    return IntakeStatistics(
      totalCaffeine: totalCaffeine,
      averageCaffeine: averageCaffeine,
      totalIntakes: totalIntakes,
      totalVolume: totalVolume,
      lastIntake: lastIntake,
    );
  }

  /// Get weekly statistics (last 7 days)
  IntakeStatistics get weeklyStatistics {
    final endDate = DateTime.now();
    final startDate = endDate.subtract(const Duration(days: 6));
    return getStatistics(startDate: startDate, endDate: endDate);
  }

  /// Get monthly statistics (last 30 days)
  IntakeStatistics get monthlyStatistics {
    final endDate = DateTime.now();
    final startDate = endDate.subtract(const Duration(days: 29));
    return getStatistics(startDate: startDate, endDate: endDate);
  }

  /// Get intake by ID
  Intake? getIntakeById(String id) {
    try {
      return _intakes.firstWhere((intake) => intake.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Clear all intakes (for testing/reset)
  Future<void> clearAllIntakes() async {
    if (_box == null) return;

    await _box!.clear();
    _intakes.clear();
    notifyListeners();
  }

  /// Get chart data for the last N days
  List<MapEntry<DateTime, double>> getChartData(int days) {
    final now = DateTime.now();
    final data = <MapEntry<DateTime, double>>[];

    for (int i = days - 1; i >= 0; i--) {
      final date = DateTime(now.year, now.month, now.day - i);
      final total = getTotalForDate(date);
      data.add(MapEntry(date, total));
    }

    return data;
  }

  @override
  void dispose() {
    _box?.close();
    super.dispose();
  }
}
