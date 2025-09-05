import 'package:caffeine_tracker/domain/providers/intake_provider.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../utils/app_colors.dart';
import '../widgets/history_chart.dart';

/// Screen showing caffeine intake statistics and analytics
class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  int _weekOffset = 0; // 0 = settimana corrente, -1 = settimana precedente, etc.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Consumer<IntakeProvider>(
          builder: (context, caffeineProvider, child) {
            final statistics = caffeineProvider.getStatistics();
            final chartData = _getWeekData(caffeineProvider);
        
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                   ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 0),
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryOrange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          LucideIcons.barChart2,
                          color: AppColors.primaryOrange,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        "Statistiche",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                                                      fontSize: 24

                        ),
                      ),
                      subtitle: Text(
                        "Statistiche settimanali",
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
                      ),
                    ),
                  const SizedBox(height: 16),
                  _buildChart(chartData),
                  const SizedBox(height: 24),
                  _buildStatsCards(statistics),
                  const SizedBox(height: 24),
                  _buildWeekComparisonCard(caffeineProvider),
                  const SizedBox(height: 100), // Bottom padding
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildChart(Map<DateTime, double> data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
           BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _getWeekTitle(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _weekOffset--; // Vai INDIETRO nelle settimane (verso il passato)
                      });
                    },
                    icon: const Icon(LucideIcons.chevronLeft),
                    tooltip: 'Settimana Precedente',
                  ),
                  IconButton(
                    onPressed: _weekOffset >= 0
                        ? null // Disabilita se siamo nella settimana corrente o nel futuro
                        : () {
                            setState(() {
                              _weekOffset++; // Vai AVANTI nelle settimane (verso il presente)
                            });
                          },
                    icon: const Icon(LucideIcons.chevronRight),
                    tooltip: 'Settimana Successiva',
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(height: 200, child: HistoryChart(data: data)),
        ],
      ),
    );
  }

  Widget _buildStatsCards(IntakeStatistics stats) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 1,
      children: [
        _buildStatCard(
          'Total Intakes',
          '${stats.totalIntakes}',
          LucideIcons.hash,
          AppColors.info,
        ),
        _buildStatCard(
          'Daily Average',
          '${stats.averageCaffeine.toInt()}mg',
          LucideIcons.trendingUp,
          AppColors.success,
        ),
        _buildStatCard(
          'Total Caffeine',
          '${stats.totalCaffeine.toInt()}mg',
          LucideIcons.zap,
          AppColors.warning,
        ),
        _buildStatCard(
          'Total Volume',
          '${(stats.totalVolume / 1000).toStringAsFixed(1)}L',
          LucideIcons.calendar,
          AppColors.primaryOrange,
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
           BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
        ]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.grey600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWeekComparisonCard(IntakeProvider provider) {
    if (_weekOffset >= 0) {
      return const SizedBox.shrink(); // Non mostrare per settimana corrente
    }

    final currentWeekData = _getWeekData(provider);
    final previousWeekData = _getPreviousWeekData(provider);

    final currentTotal = currentWeekData.values.fold(
      0.0,
      (sum, value) => sum + value,
    );
    final previousTotal = previousWeekData.values.fold(
      0.0,
      (sum, value) => sum + value,
    );

    final difference = currentTotal - previousTotal;
    final percentageChange = previousTotal > 0 ? (difference / previousTotal) * 100 : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
       boxShadow: [
           BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Confronto Settimanale',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Questa Settimana',
                    style: TextStyle(fontSize: 12, color: AppColors.grey600),
                  ),
                  Text(
                    '${currentTotal.toInt()} mg',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    difference >= 0 ? '+${difference.toInt()} mg' : '${difference.toInt()} mg',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: difference >= 0 ? AppColors.error : AppColors.success,
                    ),
                  ),
                  Text(
                    '${percentageChange.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 12,
                      color: difference >= 0 ? AppColors.error : AppColors.success,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Ottiene i dati per la settimana specificata dal weekOffset
  Map<DateTime, double> _getWeekData(IntakeProvider provider) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(
      Duration(days: now.weekday - 1 + (-_weekOffset * 7)), // Inversione della logica
    );
    final weekData = <DateTime, double>{};

    for (int i = 0; i < 7; i++) {
      final date = startOfWeek.add(Duration(days: i));
      weekData[date] = provider.getTotalForDate(date);
    }

    return weekData;
  }

  Map<DateTime, double> _getPreviousWeekData(IntakeProvider provider) {
    final now = DateTime.now();
    final startOfPreviousWeek = now.subtract(
      Duration(days: now.weekday - 1 + (-(_weekOffset - 1) * 7)), // Correzione logica
    );
    final weekData = <DateTime, double>{};

    for (int i = 0; i < 7; i++) {
      final date = startOfPreviousWeek.add(Duration(days: i));
      weekData[date] = provider.getTotalForDate(date);
    }

    return weekData;
  }

  /// Ottiene il titolo della settimana corrente
  String _getWeekTitle() {
    if (_weekOffset == 0) {
      return 'Ultimi 7 Giorni';
    } else if (_weekOffset == -1) {
      return 'Settimana Scorsa';
    } else {
      final weeksAgo = -_weekOffset;
      return '$weeksAgo Settimane Fa';
    }
  }
}
