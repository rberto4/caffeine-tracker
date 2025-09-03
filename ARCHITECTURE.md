# Project Structure

## 📁 Directory Overview

```
caffeine_tracker/
├── android/                    # Android platform files
│   ├── app/
│   │   ├── src/main/
│   │   │   ├── AndroidManifest.xml  # Android permissions and configuration
│   │   │   └── kotlin/              # Native Android code
│   │   └── build.gradle.kts         # Android build configuration
│   └── gradle/                      # Gradle wrapper files
├── ios/                        # iOS platform files
│   ├── Runner/
│   │   ├── Info.plist               # iOS configuration and permissions
│   │   └── AppDelegate.swift        # iOS application delegate
│   └── Runner.xcodeproj/            # Xcode project files
├── web/                        # Web platform files
│   ├── index.html                   # Main HTML file
│   └── icons/                       # Web app icons
├── lib/                        # Main Dart code
│   ├── main.dart                    # Application entry point
│   ├── presentation/                # UI Layer
│   │   ├── screens/                 # App screens
│   │   │   ├── onboarding_screen.dart
│   │   │   ├── setup_profile_screen.dart
│   │   │   ├── main_screen.dart
│   │   │   ├── home_screen.dart
│   │   │   ├── add_intake_screen.dart
│   │   │   ├── history_screen.dart
│   │   │   └── profile_screen.dart
│   │   └── widgets/                 # Reusable UI components
│   │       ├── caffeine_gauge.dart
│   │       ├── today_intake_card.dart
│   │       ├── quick_add_grid.dart
│   │       ├── history_chart.dart
│   │       └── intake_list_item.dart
│   ├── domain/                      # Business Logic Layer
│   │   ├── models/                  # Data models
│   │   │   ├── caffeine_intake.dart
│   │   │   └── user_profile.dart
│   │   └── providers/               # State management
│   │       ├── user_provider.dart
│   │       └── caffeine_provider.dart
│   ├── data/                        # Data Layer
│   │   ├── services/                # Data services
│   │   │   └── storage_service.dart
│   │   └── repositories/            # Data repositories (future)
│   └── utils/                       # Utilities and constants
│       ├── app_colors.dart          # Color palette
│       ├── app_theme.dart           # Theme configuration
│       └── app_constants.dart       # App constants
├── assets/                     # Static assets
│   ├── images/                      # Image files
│   └── icons/                       # Icon files
├── test/                       # Test files
├── pubspec.yaml                # Flutter dependencies and configuration
├── README.md                   # Main documentation
├── CHANGELOG.md                # Version history
├── BUILD.md                    # Build instructions
└── analysis_options.yaml      # Code analysis rules
```

## 🏗️ Architecture Layers

### Presentation Layer (`lib/presentation/`)
- **Screens**: Full-screen widgets representing app pages
- **Widgets**: Reusable UI components used across screens
- **Responsibilities**: 
  - User interface rendering
  - User input handling
  - State consumption from providers

### Domain Layer (`lib/domain/`)
- **Models**: Data structures representing business entities
- **Providers**: State management using Provider pattern
- **Responsibilities**:
  - Business logic implementation
  - State management
  - Data validation

### Data Layer (`lib/data/`)
- **Services**: Data access and persistence
- **Repositories**: Future abstraction for multiple data sources
- **Responsibilities**:
  - Local storage management
  - Data serialization/deserialization
  - Future API integration

### Utils Layer (`lib/utils/`)
- **Constants**: App-wide constants and configurations
- **Themes**: UI styling and color schemes
- **Helpers**: Utility functions and extensions

## 📱 Key Components

### State Management
- **Provider Pattern**: Used for reactive state management
- **UserProvider**: Manages user profile and authentication state
- **CaffeineProvider**: Manages caffeine intake data and analytics

### Data Persistence
- **Hive**: Local NoSQL database for complex data (CaffeineIntake)
- **SharedPreferences**: Simple key-value storage for settings
- **Local-First**: All data stored on device, no remote dependencies

### UI Components
- **Material Design 3**: Modern Material You theming
- **Custom Widgets**: Specialized components like CaffeineGauge
- **Responsive Design**: Adaptive layouts for different screen sizes

## 🔄 Data Flow

```
User Interaction
       ↓
   UI Widget
       ↓
   Provider Method
       ↓
   Storage Service
       ↓
   Local Database
       ↓
   State Update
       ↓
   UI Rebuild
```

## 📊 Key Features Implementation

### Caffeine Tracking
- **Quick Add**: Pre-configured buttons with common products
- **Manual Entry**: Custom product and caffeine amount input
- **Barcode Scanning**: Integration with camera for product scanning
- **Time Selection**: Specify intake time for historical entries

### Analytics
- **Real-time Gauge**: Circular progress indicator showing daily intake
- **7-day Chart**: Line chart using FL Chart library
- **Statistics**: Aggregated data showing patterns and trends
- **Status Indicators**: Color-coded warnings based on intake levels

### User Management
- **Onboarding**: Introduction screens with app overview
- **Profile Setup**: Weight and age collection for personalized limits
- **Settings**: Profile editing and data management options

## 🎨 Design System

### Colors (`app_colors.dart`)
- **Primary**: Orange (#FF6B35) for main actions and branding
- **Neutral**: Grayscale palette for text and backgrounds
- **Status**: Green/Yellow/Orange/Red for caffeine level indicators
- **Semantic**: Success, warning, error, and info colors

### Typography (`app_theme.dart`)
- **Font Family**: Google Fonts Outfit for modern appearance
- **Scale**: Hierarchical text sizes from headlines to body text
- **Weights**: Various font weights for proper visual hierarchy

### Spacing & Layout
- **Padding**: Consistent spacing using predefined constants
- **Border Radius**: Rounded corners for modern appearance
- **Elevation**: Subtle shadows for depth and hierarchy

## 🧪 Testing Strategy

### Unit Tests
- Provider logic testing
- Model serialization/deserialization
- Utility function validation

### Widget Tests
- UI component behavior
- User interaction scenarios
- State management integration

### Integration Tests
- End-to-end user flows
- Data persistence verification
- Cross-platform compatibility

## 🚀 Scalability Considerations

### Code Organization
- **Separation of Concerns**: Clear layer boundaries
- **Dependency Injection**: Provider pattern for loose coupling
- **Modular Structure**: Easy to add new features and screens

### Performance
- **Lazy Loading**: Screens loaded on demand
- **Efficient Rebuilds**: Provider pattern minimizes unnecessary rebuilds
- **Optimized Assets**: Compressed images and minimal bundle size

### Future Enhancements
- **Repository Pattern**: Abstract data sources for future API integration
- **Feature Modules**: Separate features into independent modules
- **Internationalization**: Easy to add multi-language support
- **Platform-Specific**: Native implementations for advanced features

## 📝 Documentation

- **README.md**: Overview and getting started guide
- **BUILD.md**: Detailed build and deployment instructions
- **CHANGELOG.md**: Version history and feature additions
- **Inline Comments**: Code documentation for complex logic
- **Architecture Docs**: This file explaining project structure
