# Caffeine Tracker 📱☕

A modern, elegant Flutter app for tracking your daily caffeine intake with smart analytics and personalized limits.

![Flutter](https://img.shields.io/badge/Flutter-3.22+-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.9+-blue.svg)
![Platform](https://img.shields.io/badge/Platform-Android%20|%20iOS-green.svg)

## ✨ Features

### 🎯 Core Functionality
- **Smart Caffeine Tracking**: Add caffeine intake manually or scan barcodes
- **Personalized Limits**: Automatic daily limit calculation based on weight and age
- **Real-time Monitoring**: Beautiful circular gauge showing current intake levels
- **Quick Add**: Pre-configured buttons for popular caffeine products
- **Comprehensive History**: Detailed intake logs with timestamps

### 📊 Analytics & Insights
- **7-day Charts**: Visual trends using fl_chart
- **Statistics Dashboard**: Daily averages, peaks, and consumption patterns
- **Status Indicators**: Color-coded caffeine level warnings (Low/Moderate/High/Excessive)
- **Progress Tracking**: Monitor your consumption habits over time

### 🎨 User Experience
- **Elegant Design**: Modern flat design with orange accent colors
- **Dark/Light Theme**: Automatic theme switching based on system preferences
- **Smooth Animations**: Fluid transitions and micro-interactions
- **Intuitive Navigation**: Clean bottom navigation with three main sections
- **Responsive Layout**: Optimized for all screen sizes

### 🔒 Privacy & Storage
- **Local-First**: All data stored locally on device (Hive + SharedPreferences)
- **No Internet Required**: Works completely offline
- **Data Control**: Export/clear data options in profile settings

## 🚀 Getting Started

### Prerequisites
- Flutter 3.22+ installed
- Dart SDK 3.9+
- Android Studio / VS Code with Flutter extensions
- Physical device or emulator for testing

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/caffeine_tracker.git
   cd caffeine_tracker
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate required files**
   ```bash
   dart run build_runner build
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

### Build for Release

**Android APK:**
```bash
flutter build apk --release
```

**Android App Bundle:**
```bash
flutter build appbundle --release
```

**iOS:**
```bash
flutter build ios --release
```

## 🏗️ Architecture

The app follows a clean, scalable architecture:

```
lib/
├── presentation/          # UI Layer
│   ├── screens/          # App screens
│   └── widgets/          # Reusable UI components
├── domain/               # Business Logic Layer
│   ├── models/          # Data models
│   └── providers/       # State management (Provider)
├── data/                # Data Layer
│   ├── repositories/    # Data repositories
│   └── services/        # Local storage services
└── utils/               # Utilities
    ├── app_colors.dart  # Color palette
    ├── app_theme.dart   # Theme configuration
    └── app_constants.dart # App constants
```

## 📦 Key Dependencies

| Package | Purpose |
|---------|---------|
| `provider` | State management |
| `hive_flutter` | Local database |
| `shared_preferences` | Simple key-value storage |
| `google_fonts` | Outfit font family |
| `fl_chart` | Charts and graphs |
| `lucide_icons` | Modern icon set |
| `introduction_screen` | Onboarding flow |
| `barcode_scan2` | Barcode scanning |

## 🔧 Configuration

### Customizing Caffeine Products
Edit `lib/utils/app_constants.dart` to add/modify caffeine products:

```dart
static const Map<String, double> products = {
  'Your Product (Volume)': caffeineAmount,
  // Add more products...
};
```

### Adjusting Daily Limits
Modify caffeine calculation constants in `app_constants.dart`:

```dart
static const double maxCaffeinePerKgBodyWeight = 6.0; // mg per kg
static const double maxDailyCaffeineAdult = 400.0;   // mg per day
```

### Theming
Customize colors in `lib/utils/app_colors.dart`:

```dart
static const Color primaryOrange = Color(0xFFFF6B35);
// Modify other colors...
```

## 📱 Screenshots

| Onboarding | Home Screen | Add Intake | History |
|------------|-------------|------------|---------|
| ![Onboarding](screenshots/onboarding.png) | ![Home](screenshots/home.png) | ![Add](screenshots/add.png) | ![History](screenshots/history.png) |

## 🧪 Testing

Run tests with:
```bash
flutter test
```

Run integration tests:
```bash
flutter drive --target=test_driver/app.dart
```

## 📋 Roadmap

- [ ] Widget support for quick caffeine tracking
- [ ] Export data to CSV/JSON
- [ ] Caffeine metabolism tracking
- [ ] Sleep impact analysis
- [ ] Social sharing features
- [ ] Multi-language support
- [ ] Wear OS companion app

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

If you find this project helpful, please consider:
- ⭐ Starring the repository
- 🐛 Reporting bugs via GitHub Issues
- 💡 Suggesting new features
- 🔄 Contributing code improvements

## 📞 Contact

**Developer**: Your Name  
**Email**: your.email@example.com  
**GitHub**: [@yourusername](https://github.com/yourusername)

---

Built with ❤️ using Flutter and lots of ☕
