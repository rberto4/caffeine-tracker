import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../domain/providers/user_provider.dart';
import '../../domain/providers/caffeine_provider.dart';
import '../../utils/app_colors.dart';
import '../widgets/caffeine_gauge.dart';
import '../widgets/today_intake_card.dart';
import '../widgets/quick_add_grid.dart';
import 'add_intake_screen.dart';

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

                const SizedBox(height: 24),
                _buildAddButton(context),
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
    return Consumer2<UserProvider, CaffeineProvider>(
      builder: (context, userProvider, caffeineProvider, child) {
        final currentIntake = caffeineProvider.todayTotalCaffeine;
        final maxIntake = userProvider.maxDailyCaffeine;

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
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
        QuickAddGrid(
          gaugeKey: _gaugeKey,
        ),
      ],
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton.icon(
        onPressed: () => _navigateToAddIntake(context),
        icon: const Icon(LucideIcons.plus),
        label: const Text('Add Caffeine Intake'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryOrange,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
        ),
      ),
    );
  }

  Future<void> _refreshData(BuildContext context) async {
    final caffeineProvider = Provider.of<CaffeineProvider>(
      context,
      listen: false,
    );
    await caffeineProvider.initializeData();
  }

  void _navigateToAddIntake(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const AddIntakeScreen()));
  }
}
