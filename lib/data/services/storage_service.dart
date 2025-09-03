import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../domain/models/user_profile.dart';
import '../../domain/models/caffeine_intake.dart';
import '../../utils/app_constants.dart';

/// Service for managing local data storage using SharedPreferences
class StorageService {
  static SharedPreferences? _prefs;

  /// Initialize SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Get SharedPreferences instance
  static SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('StorageService not initialized. Call StorageService.init() first.');
    }
    return _prefs!;
  }

  // User Profile methods
  
  /// Save user profile
  static Future<bool> saveUserProfile(UserProfile profile) async {
    try {
      final json = jsonEncode(profile.toJson());
      await prefs.setString('user_profile', json);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get user profile
  static UserProfile? getUserProfile() {
    try {
      final json = prefs.getString('user_profile');
      if (json == null) return null;
      
      final data = jsonDecode(json) as Map<String, dynamic>;
      return UserProfile.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  /// Save user weight
  static Future<bool> saveUserWeight(double weight) async {
    return await prefs.setDouble(AppConstants.keyUserWeight, weight);
  }

  /// Get user weight
  static double? getUserWeight() {
    return prefs.getDouble(AppConstants.keyUserWeight);
  }

  /// Save user age
  static Future<bool> saveUserAge(int age) async {
    return await prefs.setInt(AppConstants.keyUserAge, age);
  }

  /// Get user age
  static int? getUserAge() {
    return prefs.getInt(AppConstants.keyUserAge);
  }

  // App State methods

  /// Set first time flag
  static Future<bool> setIsFirstTime(bool isFirstTime) async {
    return await prefs.setBool(AppConstants.keyIsFirstTime, isFirstTime);
  }

  /// Check if it's first time
  static bool isFirstTime() {
    return prefs.getBool(AppConstants.keyIsFirstTime) ?? true;
  }

  /// Save dark mode preference
  static Future<bool> setDarkMode(bool isDarkMode) async {
    return await prefs.setBool(AppConstants.keyDarkMode, isDarkMode);
  }

  /// Get dark mode preference
  static bool? getDarkMode() {
    return prefs.getBool(AppConstants.keyDarkMode);
  }

  // Caffeine Intake methods

  /// Save caffeine intakes list
  static Future<bool> saveCaffeineIntakes(List<CaffeineIntake> intakes) async {
    try {
      final jsonList = intakes.map((intake) => intake.toJson()).toList();
      final json = jsonEncode(jsonList);
      await prefs.setString(AppConstants.keyCaffeineIntakes, json);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get caffeine intakes list
  static List<CaffeineIntake> getCaffeineIntakes() {
    try {
      final json = prefs.getString(AppConstants.keyCaffeineIntakes);
      if (json == null) return [];
      
      final jsonList = jsonDecode(json) as List<dynamic>;
      return jsonList.map((item) => CaffeineIntake.fromJson(item as Map<String, dynamic>)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Add new caffeine intake
  static Future<bool> addCaffeineIntake(CaffeineIntake intake) async {
    try {
      final intakes = getCaffeineIntakes();
      intakes.add(intake);
      return await saveCaffeineIntakes(intakes);
    } catch (e) {
      return false;
    }
  }

  /// Remove caffeine intake by ID
  static Future<bool> removeCaffeineIntake(String id) async {
    try {
      final intakes = getCaffeineIntakes();
      intakes.removeWhere((intake) => intake.id == id);
      return await saveCaffeineIntakes(intakes);
    } catch (e) {
      return false;
    }
  }

  /// Get today's caffeine intakes
  static List<CaffeineIntake> getTodayCaffeineIntakes() {
    final allIntakes = getCaffeineIntakes();
    final now = DateTime.now();
    
    return allIntakes.where((intake) {
      return intake.timestamp.year == now.year &&
             intake.timestamp.month == now.month &&
             intake.timestamp.day == now.day;
    }).toList();
  }

  /// Get caffeine intakes for a specific date
  static List<CaffeineIntake> getCaffeineIntakesForDate(DateTime date) {
    final allIntakes = getCaffeineIntakes();
    
    return allIntakes.where((intake) {
      return intake.timestamp.year == date.year &&
             intake.timestamp.month == date.month &&
             intake.timestamp.day == date.day;
    }).toList();
  }

  /// Clear all data
  static Future<bool> clearAllData() async {
    try {
      await prefs.clear();
      return true;
    } catch (e) {
      return false;
    }
  }
}
