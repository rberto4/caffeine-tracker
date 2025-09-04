/// Categories and visual representation for different drink types
class DrinkCategories {
  DrinkCategories._();

  /// Enum for drink categories
  static const String espressoCategory = 'espresso';
  static const String coffeeCategory = 'coffee';
  static const String energyDrinkCategory = 'energy';
  static const String sodaCategory = 'soda';

  /// Map products to their categories and corresponding images
  static const Map<String, DrinkInfo> drinkInfo = {
    // Espresso/Tazza category
    'Espresso (30ml)': DrinkInfo(
      category: espressoCategory,
      imagePath: 'assets/images/coffee-mug.png',
      description: 'Tazzina',
    ),
    'Cappuccino (240ml)': DrinkInfo(
      category: espressoCategory,
      imagePath: 'assets/images/coffee-mug.png',
      description: 'Tazza',
    ),
    'Latte (240ml)': DrinkInfo(
      category: espressoCategory,
      imagePath: 'assets/images/coffee-mug.png',
      description: 'Tazza',
    ),
    'Macchiato (240ml)': DrinkInfo(
      category: espressoCategory,
      imagePath: 'assets/images/coffee-mug.png',
      description: 'Tazza',
    ),
    'Mocha (240ml)': DrinkInfo(
      category: espressoCategory,
      imagePath: 'assets/images/coffee-mug.png',
      description: 'Tazza',
    ),

    // Coffee/Caffè lunghi category
    'Coffee (240ml)': DrinkInfo(
      category: coffeeCategory,
      imagePath: 'assets/images/coffee-cup.png',
      description: 'Caffè lungo',
    ),
    'Americano (240ml)': DrinkInfo(
      category: coffeeCategory,
      imagePath: 'assets/images/coffee-cup.png',
      description: 'Caffè lungo',
    ),
    'Iced Coffee (240ml)': DrinkInfo(
      category: coffeeCategory,
      imagePath: 'assets/images/coffee-cup.png',
      description: 'Caffè freddo',
    ),
    'Frappé (240ml)': DrinkInfo(
      category: coffeeCategory,
      imagePath: 'assets/images/coffee-cup.png',
      description: 'Caffè freddo',
    ),

    // Energy drinks category
    'Red Bull (250ml)': DrinkInfo(
      category: energyDrinkCategory,
      imagePath: 'assets/images/energy-drink.png',
      description: 'Energy drink',
    ),
    'Monster Energy (473ml)': DrinkInfo(
      category: energyDrinkCategory,
      imagePath: 'assets/images/energy-drink.png',
      description: 'Energy drink',
    ),

    // Soda/Bibite category
    'Coca-Cola (355ml)': DrinkInfo(
      category: sodaCategory,
      imagePath: 'assets/images/drink.png',
      description: 'Bibita',
    ),
    'Pepsi (355ml)': DrinkInfo(
      category: sodaCategory,
      imagePath: 'assets/images/drink.png',
      description: 'Bibita',
    ),

    // Tea - using coffee mug as they're typically served in cups
    'Black Tea (240ml)': DrinkInfo(
      category: espressoCategory,
      imagePath: 'assets/images/coffee-mug.png',
      description: 'Tazza',
    ),
    'Green Tea (240ml)': DrinkInfo(
      category: espressoCategory,
      imagePath: 'assets/images/coffee-mug.png',
      description: 'Tazza',
    ),

    // Chocolate - using coffee mug as default
    'Dark Chocolate (28g)': DrinkInfo(
      category: espressoCategory,
      imagePath: 'assets/images/coffee-mug.png',
      description: 'Solido',
    ),
    'Milk Chocolate (28g)': DrinkInfo(
      category: espressoCategory,
      imagePath: 'assets/images/coffee-mug.png',
      description: 'Solido',
    ),
  };

  /// Get drink info for a specific product
  static DrinkInfo? getDrinkInfo(String productName) {
    return drinkInfo[productName];
  }

  /// Get image path for a product, with fallback
  static String getImagePath(String productName) {
    return drinkInfo[productName]?.imagePath ?? 'assets/images/coffee-mug.png';
  }

  /// Get category for a product
  static String getCategory(String productName) {
    return drinkInfo[productName]?.category ?? espressoCategory;
  }

  /// Get all products by category
  static List<String> getProductsByCategory(String category) {
    return drinkInfo.entries
        .where((entry) => entry.value.category == category)
        .map((entry) => entry.key)
        .toList();
  }

  /// Get default image for custom products based on common keywords
  static String getDefaultImageForCustomProduct(String productName) {
    final lowerName = productName.toLowerCase();
    
    if (lowerName.contains('energy') || lowerName.contains('bull') || lowerName.contains('monster')) {
      return 'assets/images/energy-drink.png';
    } else if (lowerName.contains('cola') || lowerName.contains('pepsi') || lowerName.contains('soda') || lowerName.contains('bibita')) {
      return 'assets/images/drink.png';
    } else if (lowerName.contains('americano') || lowerName.contains('lungo') || lowerName.contains('iced') || lowerName.contains('frappé')) {
      return 'assets/images/coffee-cup.png';
    } else {
      // Default to coffee mug for espresso, cappuccino, tea, etc.
      return 'assets/images/coffee-mug.png';
    }
  }
}

/// Data class for drink information
class DrinkInfo {
  final String category;
  final String imagePath;
  final String description;

  const DrinkInfo({
    required this.category,
    required this.imagePath,
    required this.description,
  });
}
