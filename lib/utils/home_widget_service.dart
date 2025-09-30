import 'package:home_widget/home_widget.dart';
import 'package:flutter/material.dart';
import '../domain/providers/intake_provider.dart';
import '../domain/providers/beverage_provider.dart';
import '../domain/models/beverage.dart';
import '../domain/models/intake.dart';

/// Service for managing home screen widgets
class HomeWidgetService {
  static const String _caffeineGaugeWidgetName = 'CaffeineGaugeWidgetProvider';
  static const String _quickAddWidgetName = 'QuickAddWidgetProvider';

  /// Initialize the home widget service
  static Future<void> initialize() async {
    await HomeWidget.setAppGroupId('group.caffeine_tracker.widgets');
  }

  /// Update the caffeine gauge widget with current data
  static Future<void> updateCaffeineGaugeWidget({
    required double currentCaffeine,
    required double maxCaffeine,
    required int totalIntakes,
  }) async {
    try {
      final percentage = maxCaffeine > 0 ? (currentCaffeine / maxCaffeine * 100).clamp(0, 100) : 0;
      
      await HomeWidget.saveWidgetData<double>('current_caffeine', currentCaffeine);
      await HomeWidget.saveWidgetData<double>('max_caffeine', maxCaffeine);
      await HomeWidget.saveWidgetData<double>('caffeine_percentage', percentage.toDouble());
      await HomeWidget.saveWidgetData<int>('total_intakes', totalIntakes);
      await HomeWidget.saveWidgetData<String>('last_updated', DateTime.now().toIso8601String());
      
      await HomeWidget.updateWidget(
        name: _caffeineGaugeWidgetName,
        androidName: _caffeineGaugeWidgetName,
        iOSName: _caffeineGaugeWidgetName,
      );
    } catch (e) {
      debugPrint('Error updating caffeine gauge widget: $e');
    }
  }

  /// Update the quick add widget with available beverages
  static Future<void> updateQuickAddWidget({
    required List<Beverage> defaultBeverages,
  }) async {
    try {
      // Save up to 4 default beverages for the widget
      final beveragesToShow = defaultBeverages.take(4).toList();
      
      for (int i = 0; i < 4; i++) {
        if (i < beveragesToShow.length) {
          final beverage = beveragesToShow[i];
          await HomeWidget.saveWidgetData<String>('beverage_${i}_id', beverage.id);
          await HomeWidget.saveWidgetData<String>('beverage_${i}_name', beverage.name);
          await HomeWidget.saveWidgetData<double>('beverage_${i}_caffeine', beverage.caffeineAmount);
          await HomeWidget.saveWidgetData<double>('beverage_${i}_volume', beverage.volume);
          await HomeWidget.saveWidgetData<String>('beverage_${i}_color', beverage.color.value.toString());
          await HomeWidget.saveWidgetData<String>('beverage_${i}_image', beverage.imagePath);
        } else {
          // Clear unused slots
          await HomeWidget.saveWidgetData<String>('beverage_${i}_id', '');
        }
      }
      
      await HomeWidget.saveWidgetData<String>('widget_last_updated', DateTime.now().toIso8601String());
      
      await HomeWidget.updateWidget(
        name: _quickAddWidgetName,
        androidName: _quickAddWidgetName,
        iOSName: _quickAddWidgetName,
      );
    } catch (e) {
      debugPrint('Error updating quick add widget: $e');
    }
  }

  /// Handle widget tap actions
  static Future<void> handleWidgetAction(String action, Map<String, String> data) async {
    try {
      switch (action) {
        case 'add_beverage':
          final beverageId = data['beverage_id'];
          if (beverageId != null && beverageId.isNotEmpty) {
            await _addBeverageIntake(beverageId);
          }
          break;
        case 'open_app':
          // App will be opened automatically
          break;
        case 'open_quick_add':
          // Navigate to quick add screen when app opens
          break;
      }
    } catch (e) {
      debugPrint('Error handling widget action: $e');
    }
  }

  /// Add a beverage intake from widget
  static Future<void> _addBeverageIntake(String beverageId) async {
    // This will be called when the app is opened from widget
    // We'll store the action and process it when providers are available
    await HomeWidget.saveWidgetData<String>('pending_intake_id', beverageId);
    await HomeWidget.saveWidgetData<String>('pending_intake_timestamp', DateTime.now().toIso8601String());
  }

  /// Check for pending intake from widget and process it
  static Future<void> processPendingIntake({
    required BeverageProvider beverageProvider,
    required IntakeProvider intakeProvider,
  }) async {
    try {
      final pendingBeverageId = await HomeWidget.getWidgetData<String>('pending_intake_id');
      final pendingTimestamp = await HomeWidget.getWidgetData<String>('pending_intake_timestamp');
      
      if (pendingBeverageId != null && pendingBeverageId.isNotEmpty) {
        // Find the beverage
        final beverages = beverageProvider.defaultBeverages;
        final beverage = beverages.isNotEmpty 
            ? beverages.firstWhere((b) => b.id == pendingBeverageId, orElse: () => beverages.first)
            : null;
        
        if (beverage != null) {
          // Create intake
          final intake = Intake(
            id: 'widget_intake_${DateTime.now().millisecondsSinceEpoch}',
            beverage: beverage,
            timestamp: pendingTimestamp != null 
                ? DateTime.tryParse(pendingTimestamp) ?? DateTime.now()
                : DateTime.now(),
          );
          
          await intakeProvider.addIntake(intake);
          
          // Clear pending intake
          await HomeWidget.saveWidgetData<String>('pending_intake_id', '');
          await HomeWidget.saveWidgetData<String>('pending_intake_timestamp', '');
          
          debugPrint('Processed pending intake: ${beverage.name}');
        }
      }
    } catch (e) {
      debugPrint('Error processing pending intake: $e');
    }
  }

  /// Get caffeine level color based on percentage
  static Color getCaffeineLevelColor(double percentage) {
    if (percentage <= 25) {
      return const Color(0xFF4CAF50); // Green
    } else if (percentage <= 50) {
      return const Color(0xFFFFEB3B); // Yellow
    } else if (percentage <= 75) {
      return const Color(0xFFFF9800); // Orange
    } else {
      return const Color(0xFFF44336); // Red
    }
  }

  /// Format caffeine amount for display
  static String formatCaffeineAmount(double amount) {
    if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}g';
    }
    return '${amount.toInt()}mg';
  }

  /// Get greeting based on time of day
  static String getTimeBasedGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Buongiorno ☕️';
    } else if (hour < 17) {
      return 'Buon pomeriggio ☕️';
    } else {
      return 'Buonasera ☕️';
    }
  }
}