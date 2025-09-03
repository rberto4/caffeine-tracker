import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../domain/providers/user_provider.dart';
import '../../domain/providers/caffeine_provider.dart';
import '../../utils/app_colors.dart';
import 'settings_screen.dart';

/// Screen for user profile management and settings
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 24),
            _buildProfileCard(),
            const SizedBox(height: 16),
            _buildStatsCard(),
            const SizedBox(height: 100), // Bottom padding
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Profilo'),
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const SettingsScreen(),
              ),
            );
          },
          icon: const Icon(LucideIcons.settings),
          tooltip: 'Impostazioni',
        ),
      ],
    );
  }

  Widget _buildProfileHeader() {
    final textTheme = Theme.of(context).textTheme;
    
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primaryOrange.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                LucideIcons.user,
                color: AppColors.primaryOrange,
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Il tuo Profilo',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Visualizza le tue informazioni e statistiche',
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.grey600,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProfileCard() {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        if (!userProvider.hasProfile) {
          return const Center(child: Text('Nessun profilo trovato'));
        }

        final profile = userProvider.userProfile!;
        
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    LucideIcons.user,
                    color: AppColors.primaryOrange,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Informazioni Personali',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Profile Info Rows
              _buildInfoRow(
                'Sesso',
                profile.gender.displayName,
                LucideIcons.users,
              ),
              const SizedBox(height: 16),
              _buildInfoRow(
                'Peso',
                '${profile.weight.toStringAsFixed(1)} ${profile.weightUnit.abbreviation}',
                LucideIcons.scale,
              ),
              const SizedBox(height: 16),
              _buildInfoRow(
                'Età',
                '${profile.age} anni',
                LucideIcons.calendar,
              ),
              const SizedBox(height: 16),
              _buildInfoRow(
                'Limite Giornaliero',
                '${profile.convertCaffeineAmount(profile.maxDailyCaffeine).toStringAsFixed(0)} ${profile.caffeineUnit.abbreviation}',
                LucideIcons.coffee,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.grey600,
          size: 18,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.grey600,
            ),
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCard() {
    return Consumer<CaffeineProvider>(
      builder: (context, caffeineProvider, child) {
        final stats = caffeineProvider.getStatistics();
        
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    LucideIcons.barChart3,
                    color: AppColors.primaryOrange,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Statistiche',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      'Assunzioni Totali',
                      '${stats['totalIntakes']}',
                      LucideIcons.hash,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      'Media Giornaliera',
                      '${(stats['averageDaily'] as double).toInt()}mg',
                      LucideIcons.trendingUp,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      'Picco Giornaliero',
                      '${(stats['maxDaily'] as double).toInt()}mg',
                      LucideIcons.zap,
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      'Giorni Tracciati',
                      '${stats['daysTracked']}',
                      LucideIcons.calendar,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppColors.primaryOrange,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryOrange,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.grey600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
