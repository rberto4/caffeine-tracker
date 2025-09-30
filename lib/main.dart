import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:home_widget/home_widget.dart';
import 'domain/providers/user_provider.dart';
import 'domain/providers/beverage_provider.dart';
import 'domain/providers/intake_provider.dart';
import 'domain/models/user_profile.dart';
import 'domain/models/beverage.dart';
import 'domain/models/intake.dart';
import 'data/services/storage_service.dart';
import 'utils/default_beverage_service.dart';
import 'utils/home_widget_service.dart';
import 'presentation/screens/onboarding_screen.dart';
import 'presentation/screens/main_screen.dart';
import 'utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register all Hive adapters
  Hive.registerAdapter(UserProfileAdapter());
  Hive.registerAdapter(GenderAdapter());
  Hive.registerAdapter(WeightUnitAdapter());
  Hive.registerAdapter(VolumeUnitAdapter());
  Hive.registerAdapter(CaffeineUnitAdapter());
  Hive.registerAdapter(BeverageAdapter());
  Hive.registerAdapter(IntakeAdapter());
  
  // Initialize storage service
  await StorageService.init();
  
  // Initialize default beverages
  await DefaultBeverageService.initializeDefaultBeverages();
  
  // Initialize home widgets
  await HomeWidget.setAppGroupId('group.com.example.caffeine_tracker');
  
  runApp(const CaffeineTrackerApp());
}

// Global reference to navigate when widget callbacks occur
final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

class CaffeineTrackerApp extends StatelessWidget {
  const CaffeineTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => BeverageProvider()),
        ChangeNotifierProvider(create: (_) => IntakeProvider()),
      ],
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        title: 'Caffeine Tracker',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const AppInitializer(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  bool _isLoading = true;
  bool _isFirstTime = true;
  static const platform = MethodChannel('caffeine_tracker/widget');

  @override
  void initState() {
    super.initState();
    // Set up method channel listener
    platform.setMethodCallHandler(_handleMethodCall);
    // Use post frame callback to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp();
    });
  }

  Future<void> _handleMethodCall(MethodCall call) async {
    if (call.method == 'addBeverage') {
      final beverageId = call.arguments as String;
      await _addBeverageFromWidget(beverageId);
    }
  }

  Future<void> _addBeverageFromWidget(String beverageId) async {
    try {
      final beverageProvider = Provider.of<BeverageProvider>(context, listen: false);
      final intakeProvider = Provider.of<IntakeProvider>(context, listen: false);
      
      // Find the beverage
      final beverages = beverageProvider.defaultBeverages;
      Beverage? beverage;
      
      try {
        beverage = beverages.firstWhere((b) => b.id == beverageId);
      } catch (e) {
        // If not found, use first beverage as fallback
        beverage = beverages.isNotEmpty ? beverages.first : null;
      }
      
      if (beverage != null) {
        // Create intake
        final intake = Intake(
          id: 'widget_intake_${DateTime.now().millisecondsSinceEpoch}',
          beverage: beverage,
          timestamp: DateTime.now(),
        );
        
        await intakeProvider.addIntake(intake);
      }
    } catch (e) {
      debugPrint('Error adding beverage from widget: $e');
    }
  }

  Future<void> _initializeApp() async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final beverageProvider = Provider.of<BeverageProvider>(context, listen: false);
      final intakeProvider = Provider.of<IntakeProvider>(context, listen: false);
      
      // Initialize providers in parallel
      await Future.wait([
        userProvider.initializeUser(),
        beverageProvider.initialize(),
        intakeProvider.initialize(),
      ]);
      
      // Initialize widget service
      await HomeWidgetService.initialize();
      
      if (mounted) {
        setState(() {
          _isFirstTime = userProvider.isFirstTime; 
         _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return _isFirstTime ?  const OnboardingScreen() : const MainScreen();
  }
}
