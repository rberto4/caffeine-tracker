import 'package:flutter/foundation.dart';
import '../models/user_profile.dart';
import '../../data/services/storage_service.dart';
import '../../utils/app_constants.dart';

/// Provider for managing user profile and app state
class UserProvider extends ChangeNotifier {
  UserProfile? _userProfile;
  bool _isFirstTime = true;
  bool _isLoading = false;

  // Getters
  UserProfile? get userProfile => _userProfile;
  bool get isFirstTime => _isFirstTime;
  bool get isLoading => _isLoading;
  bool get hasProfile => _userProfile != null;

  double get userWeight => _userProfile?.weight ?? 70.0;
  int get userAge => _userProfile?.age ?? 25;
  Gender get userGender => _userProfile?.gender ?? Gender.male;
  WeightUnit get weightUnit => _userProfile?.weightUnit ?? WeightUnit.kg;
  CaffeineUnit get caffeineUnit => _userProfile?.caffeineUnit ?? CaffeineUnit.mg;
  double get maxDailyCaffeine => _userProfile?.maxDailyCaffeine ?? AppConstants.maxDailyCaffeineAdult;

  /// Initialize user data from storage
  Future<void> initializeUser() async {
    _isLoading = true;

    try {
      // Check if it's first time
      _isFirstTime = StorageService.isFirstTime();
      
      // Load user profile
      _userProfile = StorageService.getUserProfile();
      
      // If no profile exists but we have weight and age, create profile
      if (_userProfile == null) {
        final weight = StorageService.getUserWeight();
        final age = StorageService.getUserAge();
        
        if (weight != null && age != null) {
          final now = DateTime.now();
          _userProfile = UserProfile(
            weight: weight,
            age: age,
            gender: Gender.male, // Default value
            weightUnit: WeightUnit.kg, // Default value
            caffeineUnit: CaffeineUnit.mg, // Default value
            createdAt: now,
            updatedAt: now,
          );
          await StorageService.saveUserProfile(_userProfile!);
        }
      }
    } catch (e) {
      debugPrint('Error initializing user: $e');
    } finally {
      _isLoading = false;
    }
  }

  /// Complete onboarding and create user profile
  Future<bool> completeOnboarding({
    required double weight,
    required int age,
    Gender gender = Gender.male,
    WeightUnit weightUnit = WeightUnit.kg,
    CaffeineUnit caffeineUnit = CaffeineUnit.mg,
  }) async {
    try {
      final now = DateTime.now();
      _userProfile = UserProfile(
        weight: weight,
        age: age,
        gender: gender,
        weightUnit: weightUnit,
        caffeineUnit: caffeineUnit,
        createdAt: now,
        updatedAt: now,
      );

      // Save to storage
      await StorageService.saveUserProfile(_userProfile!);
      await StorageService.saveUserWeight(weight);
      await StorageService.saveUserAge(age);
      await StorageService.setIsFirstTime(false);

      _isFirstTime = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error completing onboarding: $e');
      return false;
    }
  }

  /// Update user profile
  Future<bool> updateProfile({
    double? weight,
    int? age,
    Gender? gender,
    WeightUnit? weightUnit,
    CaffeineUnit? caffeineUnit,
  }) async {
    if (_userProfile == null) return false;

    try {
      _userProfile = _userProfile!.copyWith(
        weight: weight,
        age: age,
        gender: gender,
        weightUnit: weightUnit,
        caffeineUnit: caffeineUnit,
        updatedAt: DateTime.now(),
      );

      // Save to storage
      await StorageService.saveUserProfile(_userProfile!);
      if (weight != null) await StorageService.saveUserWeight(weight);
      if (age != null) await StorageService.saveUserAge(age);

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error updating profile: $e');
      return false;
    }
  }

  /// Update gender setting
  Future<bool> updateGender(Gender gender) async {
    return await updateProfile(gender: gender);
  }

  /// Update weight unit setting
  Future<bool> updateWeightUnit(WeightUnit unit) async {
    return await updateProfile(weightUnit: unit);
  }

  /// Update caffeine unit setting
  Future<bool> updateCaffeineUnit(CaffeineUnit unit) async {
    return await updateProfile(caffeineUnit: unit);
  }

  /// Convert caffeine amount to display unit
  double convertCaffeineToDisplay(double amountInMg) {
    return _userProfile?.convertCaffeineAmount(amountInMg) ?? amountInMg;
  }

  /// Convert caffeine amount from display to mg
  double convertCaffeineFromDisplay(double displayAmount) {
    return _userProfile?.convertCaffeineToMg(displayAmount) ?? displayAmount;
  }

  /// Get caffeine status for current intake
  CaffeineStatus getCaffeineStatus(double currentIntake) {
    if (_userProfile == null) {
      // Default calculation for unknown profile
      final percentage = (currentIntake / AppConstants.maxDailyCaffeineAdult) * 100;
      if (percentage <= 50) return CaffeineStatus.low;
      if (percentage <= 75) return CaffeineStatus.moderate;
      if (percentage <= 100) return CaffeineStatus.high;
      return CaffeineStatus.excessive;
    }
    
    return _userProfile!.getCaffeineStatus(currentIntake);
  }

  /// Reset user data (for testing purposes)
  Future<void> resetUser() async {
    _userProfile = null;
    _isFirstTime = true;
    await StorageService.clearAllData();
    notifyListeners();
  }

  /// Reset user profile (alias for resetUser)
  Future<void> resetProfile() async {
    await resetUser();
  }
}
