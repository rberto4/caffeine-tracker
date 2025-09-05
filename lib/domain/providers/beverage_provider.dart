import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/beverage.dart';
import '../../utils/default_beverage_service.dart';

/// Provider for managing beverages
class BeverageProvider extends ChangeNotifier {
  static const String _beveragesBoxName = 'beverages';
  Box<Beverage>? _box;
  List<Beverage> _beverages = [];
  List<Beverage> _defaultBeverages = [];
  bool _isLoading = false;

  List<Beverage> get beverages => _beverages;
  List<Beverage> get defaultBeverages => _defaultBeverages;
  bool get isLoading => _isLoading;

  /// Initialize the provider
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      _box = await Hive.openBox<Beverage>(_beveragesBoxName);
      
      // Initialize default beverages if first time
      await DefaultBeverageService.initializeDefaultBeverages();
      
      // Load all beverages
      await _loadBeverages();
      await _loadDefaultBeverages();
    } catch (e) {
      debugPrint('Error initializing BeverageProvider: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load all beverages from storage
  Future<void> _loadBeverages() async {
    if (_box == null) return;

    _beverages = _box!.values.toList();
    notifyListeners();
  }

  /// Load default beverages
  Future<void> _loadDefaultBeverages() async {
    _defaultBeverages = await DefaultBeverageService.getDefaultBeverages();
    notifyListeners();
  }

  /// Add a new beverage
  Future<void> addBeverage(Beverage beverage) async {
    if (_box == null) return;

    await _box!.put(beverage.id, beverage);
    _beverages.add(beverage);
    notifyListeners();
  }

  /// Update an existing beverage
  Future<void> updateBeverage(Beverage beverage) async {
    if (_box == null) return;

    await _box!.put(beverage.id, beverage);
    
    final index = _beverages.indexWhere((b) => b.id == beverage.id);
    if (index != -1) {
      _beverages[index] = beverage;
    }

    // Update default beverages list if it's a default beverage
    final defaultIndex = _defaultBeverages.indexWhere((b) => b.id == beverage.id);
    if (defaultIndex != -1) {
      _defaultBeverages[defaultIndex] = beverage;
    }

    notifyListeners();
  }

  /// Delete a beverage
  Future<void> deleteBeverage(String id) async {
    if (_box == null) return;

    // Don't allow deletion of default beverages
    if (id.startsWith('default_')) {
      return;
    }

    await _box!.delete(id);
    _beverages.removeWhere((b) => b.id == id);
    notifyListeners();
  }

  /// Get beverage by ID
  Beverage? getBeverageById(String id) {
    return _beverages.firstWhere(
      (beverage) => beverage.id == id,
      orElse: () => throw StateError('Beverage not found'),
    );
  }

  /// Get beverages by name (search)
  List<Beverage> searchBeverages(String query) {
    if (query.isEmpty) return _beverages;
    
    return _beverages.where((beverage) => 
      beverage.name.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  /// Get custom beverages (non-default)
  List<Beverage> get customBeverages {
    return _beverages.where((b) => !b.id.startsWith('default_')).toList();
  }

  /// Reset default beverages to original values
  Future<void> resetDefaultBeverages() async {
    await DefaultBeverageService.resetDefaultBeverages();
    await _loadDefaultBeverages();
    await _loadBeverages();
  }

  @override
  void dispose() {
    _box?.close();
    super.dispose();
  }
}
