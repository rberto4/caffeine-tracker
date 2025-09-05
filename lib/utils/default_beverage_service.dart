import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/models/beverage.dart';

/// Service for managing default beverages
class DefaultBeverageService {
  static const String _defaultBeveragesKey = 'default_beverages_loaded';
  static const String _beveragesBoxName = 'beverages';

  /// Initialize default beverages on first app launch
  static Future<void> initializeDefaultBeverages() async {
    final prefs = await SharedPreferences.getInstance();
    final hasLoaded = prefs.getBool(_defaultBeveragesKey) ?? false;
    
    if (!hasLoaded) {
      await _loadDefaultBeverages();
      await prefs.setBool(_defaultBeveragesKey, true);
    }
  }

  /// Load the 4 default beverages into Hive storage
  static Future<void> _loadDefaultBeverages() async {
    final box = await Hive.openBox<Beverage>(_beveragesBoxName);
    
    final defaultBeverages = _getDefaultBeverages();
    
    for (final beverage in defaultBeverages) {
      await box.put(beverage.id, beverage);
    }
  }

  /// Get the list of default beverages
  static List<Beverage> _getDefaultBeverages() {
    return [
      Beverage.withSuggestions(
        id: 'default_espresso',
        name: 'Espresso',
        volume: 30.0,
        caffeineAmount: 63.0,
        colorIndex: 3, // Purple for espresso
        imageIndex: 0, // coffee-cup.png
      ),
      Beverage.withSuggestions(
        id: 'default_coffee',
        name: 'Coffee',
        volume: 240.0,
        caffeineAmount: 95.0,
        colorIndex: 6, // brow for coffee
        imageIndex: 4, // coffee-mug.png
      ),
      Beverage.withSuggestions(
        id: 'default_red_bull',
        name: 'Red Bull',
        volume: 250.0,
        caffeineAmount: 80.0,
        colorIndex: 4, // Red for Red Bull
        imageIndex: 6, // energy-drink.png
      ),
      Beverage.withSuggestions(
        id: 'default_green_tea',
        name: 'Green Tea',
        volume: 240.0,
        caffeineAmount: 25.0,
        colorIndex: 1, // Green for tea
        imageIndex: 5, // tea-cup.png
      ),
    ];
  }

  /// Get all default beverages from storage
  static Future<List<Beverage>> getDefaultBeverages() async {
    final box = await Hive.openBox<Beverage>(_beveragesBoxName);
    final defaultIds = ['default_espresso', 'default_coffee', 'default_red_bull', 'default_green_tea'];
    
    final beverages = <Beverage>[];
    for (final id in defaultIds) {
      final beverage = box.get(id);
      if (beverage != null) {
        beverages.add(beverage);
      }
    }
    
    return beverages;
  }

  /// Get a specific default beverage by ID
  static Future<Beverage?> getDefaultBeverage(String id) async {
    final box = await Hive.openBox<Beverage>(_beveragesBoxName);
    return box.get(id);
  }

  /// Update a default beverage (makes it customizable)
  static Future<void> updateDefaultBeverage(Beverage beverage) async {
    final box = await Hive.openBox<Beverage>(_beveragesBoxName);
    await box.put(beverage.id, beverage);
  }

  /// Reset default beverages to original values
  static Future<void> resetDefaultBeverages() async {
    final box = await Hive.openBox<Beverage>(_beveragesBoxName);
    final defaultBeverages = _getDefaultBeverages();
    
    for (final beverage in defaultBeverages) {
      await box.put(beverage.id, beverage);
    }
  }

  /// Check if default beverages are initialized
  static Future<bool> areDefaultBeveragesInitialized() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_defaultBeveragesKey) ?? false;
  }
}
