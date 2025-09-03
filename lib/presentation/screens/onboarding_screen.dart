import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../utils/app_colors.dart';
import 'setup_profile_screen.dart';

/// Onboarding screen with introduction slides
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: _buildPages(context),
      onDone: () => _navigateToProfileSetup(context),
      onSkip: () => _navigateToProfileSetup(context),
      showSkipButton: true,
      skip: const Text(
        'Skip',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.primaryOrange,
        ),
      ),
      next: const Icon(
        LucideIcons.chevronRight,
        color: AppColors.primaryOrange,
      ),
      done: const Text(
        'Get Started',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.primaryOrange,
        ),
      ),
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        activeColor: AppColors.primaryOrange,
        color: AppColors.grey300,
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
      globalBackgroundColor: Theme.of(context).colorScheme.surface,
      safeAreaList: const [false, false, false, true],
    );
  }

  List<PageViewModel> _buildPages(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
    return [
      // Welcome Page
      PageViewModel(
        title: "Welcome to Caffeine Tracker",
        body: "Track your daily caffeine intake and stay within healthy limits with our smart monitoring system.",
        image: _buildImage(
          LucideIcons.coffee,
          AppColors.primaryOrange,
        ),
        decoration: PageDecoration(
          titleTextStyle: textTheme.headlineMedium!.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          bodyTextStyle: textTheme.bodyLarge!.copyWith(
            color: AppColors.grey600,
            height: 1.5,
          ),
          imagePadding: const EdgeInsets.only(top: 60),
          pageColor: Theme.of(context).colorScheme.surface,
        ),
      ),

      // Smart Monitoring Page
      PageViewModel(
        title: "Smart Monitoring",
        body: "Get real-time insights into your caffeine levels with our circular gauge indicator and personalized daily limits.",
        image: _buildImage(
          LucideIcons.gauge,
          AppColors.info,
        ),
        decoration: PageDecoration(
          titleTextStyle: textTheme.headlineMedium!.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          bodyTextStyle: textTheme.bodyLarge!.copyWith(
            color: AppColors.grey600,
            height: 1.5,
          ),
          imagePadding: const EdgeInsets.only(top: 60),
          pageColor: Theme.of(context).colorScheme.surface,
        ),
      ),

      // Easy Tracking Page
      PageViewModel(
        title: "Easy Tracking",
        body: "Add your caffeine intake manually or scan barcodes. View detailed analytics and daily trends to optimize your consumption.",
        image: _buildImage(
          LucideIcons.barChart3,
          AppColors.success,
        ),
        decoration: PageDecoration(
          titleTextStyle: textTheme.headlineMedium!.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          bodyTextStyle: textTheme.bodyLarge!.copyWith(
            color: AppColors.grey600,
            height: 1.5,
          ),
          imagePadding: const EdgeInsets.only(top: 60),
          pageColor: Theme.of(context).colorScheme.surface,
        ),
      ),
    ];
  }

  Widget _buildImage(IconData icon, Color color) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 60,
        color: color,
      ),
    );
  }

  void _navigateToProfileSetup(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const SetupProfileScreen(),
      ),
    );
  }
}
