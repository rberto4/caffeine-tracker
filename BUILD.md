# Build Instructions

## Prerequisites

Before building the Caffeine Tracker app, ensure you have the following installed:

### Required Software
- **Flutter SDK 3.22+** - [Download from flutter.dev](https://flutter.dev/docs/get-started/install)
- **Dart SDK 3.9+** (included with Flutter)
- **Android Studio** with Android SDK for Android builds
- **Xcode** (macOS only) for iOS builds
- **Git** for version control

### Development Environment Setup

1. **Verify Flutter Installation**
   ```bash
   flutter doctor
   ```
   Ensure all checkmarks are green or address any issues shown.

2. **Enable Required Platforms**
   ```bash
   flutter config --enable-web
   flutter config --enable-android
   flutter config --enable-ios  # macOS only
   ```

## Building the App

### 1. Clone and Setup
```bash
git clone <repository-url>
cd caffeine_tracker
flutter pub get
dart run build_runner build
```

### 2. Development Builds

**Run on connected device/emulator:**
```bash
flutter run
```

**Run on specific platform:**
```bash
flutter run -d android
flutter run -d ios
flutter run -d chrome
```

**Hot reload during development:**
- Press `r` in terminal for hot reload
- Press `R` for hot restart
- Press `q` to quit

### 3. Release Builds

**Android APK:**
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

**Android App Bundle (recommended for Play Store):**
```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

**iOS (macOS only):**
```bash
flutter build ios --release
# Then use Xcode to archive and export
```

**Web:**
```bash
flutter build web --release
# Output: build/web/
```

### 4. Debug Builds

**Android APK Debug:**
```bash
flutter build apk --debug
```

**Profile Mode (for performance testing):**
```bash
flutter build apk --profile
flutter run --profile
```

## Platform-Specific Notes

### Android
- **Minimum SDK:** 21 (Android 5.0)
- **Target SDK:** 34 (Android 14)
- **Permissions:** Camera access for barcode scanning
- **Signing:** Configure signing keys for release builds

### iOS
- **Minimum Version:** iOS 12.0
- **Permissions:** Camera usage description in Info.plist
- **Code Signing:** Configure Apple Developer account
- **App Store:** Use Xcode for final submission

### Web
- **Limited Features:** Barcode scanning not available
- **Browsers:** Supports modern browsers (Chrome, Firefox, Safari, Edge)
- **Hosting:** Can be deployed to any static hosting service

## Testing

### Unit Tests
```bash
flutter test
```

### Integration Tests
```bash
flutter drive --target=test_driver/app.dart
```

### Widget Tests
```bash
flutter test test/widget_test.dart
```

## Troubleshooting

### Common Issues

1. **Build Failures:**
   - Run `flutter clean` and `flutter pub get`
   - Check for outdated dependencies with `flutter pub outdated`

2. **Hive Generation Issues:**
   - Run `dart run build_runner clean`
   - Then `dart run build_runner build --delete-conflicting-outputs`

3. **Permission Issues (Android):**
   - Ensure camera permission is in AndroidManifest.xml
   - Test on physical device for camera features

4. **iOS Build Issues:**
   - Update Xcode to latest version
   - Clean iOS build: `cd ios && rm -rf Pods/ Podfile.lock && pod install`

### Performance Optimization

**For Release Builds:**
- Use `--obfuscate --split-debug-info=<directory>` for code obfuscation
- Enable R8/ProGuard for Android builds
- Use `--tree-shake-icons` to reduce app size

**Example optimized build:**
```bash
flutter build apk --release --obfuscate --split-debug-info=debug-info --tree-shake-icons
```

## Deployment

### Google Play Store
1. Build AAB: `flutter build appbundle --release`
2. Upload to Play Console
3. Configure store listing and pricing
4. Submit for review

### Apple App Store
1. Build iOS: `flutter build ios --release`
2. Open ios/Runner.xcworkspace in Xcode
3. Archive and upload via Xcode or Transporter
4. Submit via App Store Connect

### Web Hosting
1. Build web: `flutter build web --release`
2. Upload build/web/ contents to hosting service
3. Configure routing for single-page application

## Continuous Integration

### GitHub Actions Example
```yaml
name: Build and Test
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: dart run build_runner build
      - run: flutter test
      - run: flutter build apk --debug
```

For more detailed information, refer to the [Flutter documentation](https://flutter.dev/docs).
