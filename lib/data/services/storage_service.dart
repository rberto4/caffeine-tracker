import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../domain/models/user_profile.dart';
import '../../utils/app_constants.dart';

/// Service for managing local data storage using SharedPreferences
/// Note: Intake data is now managed by Hive through IntakeProvider
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

  /// Save user weight (legacy support)
  static Future<bool> saveUserWeight(double weight) async {
    return await prefs.setDouble(AppConstants.keyUserWeight, weight);
  }

  /// Get user weight (legacy support)
  static double? getUserWeight() {
    return prefs.getDouble(AppConstants.keyUserWeight);
  }

  /// Save user age (legacy support)
  static Future<bool> saveUserAge(int age) async {
    return await prefs.setInt(AppConstants.keyUserAge, age);
  }

  /// Get user age (legacy support)
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
