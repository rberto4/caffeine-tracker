import 'package:flutter/foundation.dart';
import '../models/caffeine_intake.dart';
import '../../data/services/storage_service.dart';

/// Provider for managing caffeine intake data and analytics
class CaffeineProvider extends ChangeNotifier {
  List<CaffeineIntake> _intakes = [];
  bool _isLoading = false;

  // Getters
  List<CaffeineIntake> get intakes => _intakes;
  bool get isLoading => _isLoading;

  /// Get today's caffeine intakes
  List<CaffeineIntake> get todayIntakes {
    final now = DateTime.now();
    return _intakes.where((intake) {
      return intake.timestamp.year == now.year &&
             intake.timestamp.month == now.month &&
             intake.timestamp.day == now.day;
    }).toList()..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  /// Get total caffeine for today
  double get todayTotalCaffeine {
    return todayIntakes.fold(0.0, (total, intake) => total + intake.caffeineAmount);
  }

  /// Get caffeine intakes for the last 7 days
  Map<DateTime, double> get last7DaysData {
    final now = DateTime.now();
    final data = <DateTime, double>{};
    
    for (int i = 6; i >= 0; i--) {
      final date = DateTime(now.year, now.month, now.day - i);
      final dayIntakes = getIntakesForDate(date);
      final total = dayIntakes.fold(0.0, (sum, intake) => sum + intake.caffeineAmount);
      data[date] = total;
    }
    
    return data;
  }

  /// Initialize caffeine data from storage
  Future<void> initializeData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _intakes = StorageService.getCaffeineIntakes();
      // Sort by timestamp descending (newest first)
      _intakes.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    } catch (e) {
      debugPrint('Error loading caffeine data: $e');
      _intakes = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add new caffeine intake
  Future<bool> addIntake({
    required String productName,
    required double caffeineAmount,
    DateTime? timestamp,
    String? barcode,
    double? quantity,
  }) async {
    try {
      final intake = CaffeineIntake(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        productName: productName,
        caffeineAmount: caffeineAmount,
        timestamp: timestamp ?? DateTime.now(),
        barcode: barcode,
        quantity: quantity,
      );

      // Add to local list
      _intakes.insert(0, intake); // Add at beginning (newest first)
      
      // Save to storage
      await StorageService.addCaffeineIntake(intake);
      
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error adding caffeine intake: $e');
      return false;
    }
  }

  /// Remove caffeine intake
  Future<bool> removeIntake(String id) async {
    try {
      _intakes.removeWhere((intake) => intake.id == id);
      await StorageService.removeCaffeineIntake(id);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error removing caffeine intake: $e');
      return false;
    }
  }

  /// Get intakes for a specific date
  List<CaffeineIntake> getIntakesForDate(DateTime date) {
    return _intakes.where((intake) {
      return intake.timestamp.year == date.year &&
             intake.timestamp.month == date.month &&
             intake.timestamp.day == date.day;
    }).toList()..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }

  /// Get caffeine total for a specific date
  double getTotalForDate(DateTime date) {
    final dayIntakes = getIntakesForDate(date);
    return dayIntakes.fold(0.0, (total, intake) => total + intake.caffeineAmount);
  }

  /// Get caffeine intake statistics
  Map<String, dynamic> getStatistics() {
    if (_intakes.isEmpty) {
      return {
        'totalIntakes': 0,
        'averageDaily': 0.0,
        'maxDaily': 0.0,
        'mostConsumedProduct': 'None',
        'daysTracked': 0,
      };
    }

    // Group by date
    final dailyTotals = <String, double>{};
    final productCounts = <String, int>{};

    for (final intake in _intakes) {
      final dateKey = '${intake.timestamp.year}-${intake.timestamp.month}-${intake.timestamp.day}';
      dailyTotals[dateKey] = (dailyTotals[dateKey] ?? 0.0) + intake.caffeineAmount;
      productCounts[intake.productName] = (productCounts[intake.productName] ?? 0) + 1;
    }

    final maxDaily = dailyTotals.values.isEmpty ? 0.0 : dailyTotals.values.reduce((a, b) => a > b ? a : b);
    final averageDaily = dailyTotals.values.isEmpty ? 0.0 : dailyTotals.values.reduce((a, b) => a + b) / dailyTotals.values.length;
    
    String mostConsumedProduct = 'None';
    if (productCounts.isNotEmpty) {
      int maxCount = 0;
      productCounts.forEach((product, count) {
        if (count > maxCount) {
          maxCount = count;
          mostConsumedProduct = product;
        }
      });
    }

    return {
      'totalIntakes': _intakes.length,
      'averageDaily': averageDaily,
      'maxDaily': maxDaily,
      'mostConsumedProduct': mostConsumedProduct,
      'daysTracked': dailyTotals.length,
    };
  }

  /// Clear all caffeine data
  Future<void> clearAllData() async {
    _intakes.clear();
    await StorageService.clearAllData();
    notifyListeners();
  }
}
