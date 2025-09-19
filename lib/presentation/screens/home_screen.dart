import 'package:caffeine_tracker/presentation/widgets/box_shadow.dart';
import 'package:caffeine_tracker/presentation/widgets/today_intake_card.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../domain/providers/user_provider.dart';
import '../../domain/providers/intake_provider.dart';
import '../../utils/app_colors.dart';
import '../widgets/caffeine_gauge.dart';
import '../widgets/quick_add_grid.dart';

/// Home screen showing caffeine gauge and quick actions
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey _gaugeKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _refreshData(context),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildGreeting(context),
                const SizedBox(height: 24),
                _buildCaffeineGauge(),
                const SizedBox(height: 24),
                _buildQuickAddSection(context),
                const SizedBox(height: 24),
                _buildTodayIntakeCard(),
                const SizedBox(height: 100), // Bottom padding for navigation
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGreeting(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final now = DateTime.now();
    String greeting;

    if (now.hour < 12) {
      greeting = 'Good Morning! ☕️';
    } else if (now.hour < 17) {
      greeting = 'Good Afternoon! ☕️';
    } else {
      greeting = 'Good Evening! ☕️';
    }

    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                greeting,
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              trailing: IconButton(
                onPressed: () => _refreshData(context),
                icon: const Icon(LucideIcons.refreshCw),
              ),
              subtitle: Text(
                'Track your caffeine intake today',
                style: textTheme.bodyLarge?.copyWith(color: AppColors.grey600),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCaffeineGauge() {
    return Consumer2<UserProvider, IntakeProvider>(
      builder: (context, userProvider, intakeProvider, child) {
        final currentIntake = intakeProvider.todayTotalCaffeine;
        final maxIntake = userProvider.maxDailyCaffeine;

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(20),
            boxShadow: CustomBoxShadow.cardBoxShadows,
          ),
          child: CaffeineGauge(
            key: _gaugeKey,
            currentValue: currentIntake,
            maxValue: maxIntake,
            size: 200,
          ),
        );
      },
    );
  }

  Widget _buildTodayIntakeCard() {
    return const TodayIntakeCard();
  }

  Widget _buildQuickAddSection(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Add',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        QuickAddGrid(gaugeKey: _gaugeKey),
      ],
    );
  }

  Future<void> _refreshData(BuildContext context) async {
    // Refresh providers if needed
    // Currently handled automatically by the providers
  }
}
