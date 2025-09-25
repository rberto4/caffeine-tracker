/// App-wide constants for Caffeine Tracker
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Caffeine Tracker';
  static const String appVersion = '1.0.0';

  // Caffeine calculations
  static const double maxCaffeinePerKgBodyWeight = 6.0; // mg per kg body weight
  static const double maxDailyCaffeineAdult = 400.0; // mg per day for adults
  static const double maxDailyCaffeineYouth = 100.0; // mg per day for youth (under 18)

  // Storage keys
  static const String keyIsFirstTime = 'is_first_time';
  static const String keyUserWeight = 'user_weight';
  static const String keyUserAge = 'user_age';
  static const String keyCaffeineIntakes = 'caffeine_intakes';
  static const String keyDarkMode = 'dark_mode';

  // Animation durations
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // UI constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double extraLargePadding = 32.0;
  
  static const double defaultBorderRadius = 12.0;
  static const double largeBorderRadius = 16.0;
  static const double cardElevation = 2.0;

  // Gauge constants
  static const double gaugeStartAngle = 220;
  static const double gaugeSweepAngle = 100;
  static const double gaugeRadius = 120;

  // Chart constants
  static const int daysToShow = 7;
  static const double chartHeight = 200;
}

/// Caffeine content for common products
class CaffeineProducts {
  static const Map<String, double> products = {
    'Espresso (30ml)': 63.0,
    'Coffee (240ml)': 95.0,
    'Black Tea (240ml)': 40.0,
    'Green Tea (240ml)': 25.0,
    'Red Bull (250ml)': 80.0,
    'Monster Energy (473ml)': 160.0,
    'Coca-Cola (355ml)': 34.0,
    'Pepsi (355ml)': 38.0,
    'Dark Chocolate (28g)': 12.0,
    'Milk Chocolate (28g)': 6.0,
    'Cappuccino (240ml)': 75.0,
    'Latte (240ml)': 63.0,
    'Americano (240ml)': 95.0,
    'Macchiato (240ml)': 75.0,
    'Mocha (240ml)': 95.0,
    'Iced Coffee (240ml)': 100.0,
    'Frappé (240ml)': 70.0,
  };

  static List<String> get productNames => products.keys.toList()..sort();
  
  static double getCaffeineContent(String productName) {
    return products[productName] ?? 0.0;
  }
}

/// Beverage image assets
class BeverageAssets {
  BeverageAssets._();

  // Available beverage images
  static const String coffeeCup1 = 'assets/images/coffee-cup-1.png';
  static const String coffeeCup2 = 'assets/images/coffee-cup-2.png';
  static const String coffeeCup3 = 'assets/images/coffee-cup-3.png';
  static const String coffeeCup4 = 'assets/images/coffee-cup-4.png';
  static const String coffeeMug1 = 'assets/images/coffee-mug-1.png';
  static const String teaCup1 = 'assets/images/tea-cup-1.png';
  static const String teaPot1 = 'assets/images/tea-pot-1.png';
  static const String energyDrink1 = 'assets/images/energy-drink-1.png';
  static const String energyDrink2 = 'assets/images/energy-drink-2.png';
  static const String energyDrink3 = 'assets/images/energy-drink-3.png';
  static const String energyDrink4 = 'assets/images/energy-drink-4.png';
  static const String energyDrink5 = 'assets/images/energy-drink-5.png';
  static const String energyDrink6 = 'assets/images/energy-drink-6.png';
  static const String colaBottle1 = 'assets/images/cola-bottle-1.png';
  static const String hotCocoa1 = 'assets/images/hot-cocoa-1.png';
  static const String preWorkout1 = 'assets/images/pre-workout-1.png';
  static const String preWorkout2 = 'assets/images/pre-workout-2.png';

  /// List of all available beverage images
  static const List<String> allImages = [
    coffeeCup1,
    coffeeCup2,
    coffeeCup3,
    coffeeCup4,
    coffeeMug1,
    teaCup1,
    teaPot1,
    energyDrink1,
    energyDrink2,
    energyDrink3,
    energyDrink4,
    energyDrink5,
    energyDrink6,
    colaBottle1,
    hotCocoa1,
    preWorkout1,
    preWorkout2,
  ];

  /// Get beverage image by index
  static String getBeverageImage(int index) {
    return allImages[index % allImages.length];
  }

  /// Get suggested image for beverage type
  static String getSuggestedImageForType(String beverageName) {
    final name = beverageName.toLowerCase();
    
    if (name.contains('coffee') || name.contains('espresso') || 
        name.contains('cappuccino') || name.contains('latte') ||
        name.contains('americano') || name.contains('macchiato') ||
        name.contains('mocha')) {
      return coffeeCup1;
    } else if (name.contains('tea') && name.contains('pot')) {
      return teaPot1;
    } else if (name.contains('tea')) {
      return teaCup1;
    } else if (name.contains('pre-workout') || name.contains('preworkout') ||
               name.contains('pre workout')) {
      return preWorkout1;
    } else if (name.contains('energy') || name.contains('red bull') || 
               name.contains('monster')) {
      return energyDrink1;
    } else if (name.contains('coca') || name.contains('pepsi') || 
               name.contains('cola')) {
      return colaBottle1;
    } else if (name.contains('cocoa') || name.contains('chocolate')) {
      return hotCocoa1;
    } else {
      return coffeeCup1;
    }
  }

}
