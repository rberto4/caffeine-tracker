import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'domain/providers/user_provider.dart';
import 'domain/providers/beverage_provider.dart';
import 'domain/providers/intake_provider.dart';
import 'domain/models/user_profile.dart';
import 'domain/models/beverage.dart';
import 'domain/models/intake.dart';
import 'data/services/storage_service.dart';
import 'utils/default_beverage_service.dart';
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
  
  runApp(const CaffeineTrackerApp());
}

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

  @override
  void initState() {
    super.initState();
    // Use post frame callback to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeApp();
    });
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
