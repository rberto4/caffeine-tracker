import 'package:caffeine_tracker/domain/providers/intake_provider.dart';
import 'package:caffeine_tracker/domain/providers/user_provider.dart';
import 'package:caffeine_tracker/presentation/widgets/box_shadow.dart';
import 'package:caffeine_tracker/presentation/widgets/custom_tile_title.dart';
import 'package:caffeine_tracker/presentation/widgets/stats_cards.dart';
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
  int _weekOffset =
      0; // 0 = settimana corrente, -1 = settimana precedente, etc.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Consumer2<IntakeProvider, UserProvider>(
          builder: (context, caffeineProvider, userProvider, child) {
            final chartData = _getWeekData(caffeineProvider);
            final weekStats = _getWeekStatistics(caffeineProvider);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomTileTitle(
                    tittle: 'Statistiche',
                    subtitle: 'Panoramica settimanale',
                    leadingIcon: LucideIcons.barChart2,
                    trailingWidget: SizedBox(),
                  ),
                  const SizedBox(height: 16),
                  _buildChart(chartData),
                  const SizedBox(height: 24),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        LucideIcons.grid,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      "Dati settimanali",
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Consumo di caffeina e volume totale per la settimana selezionata',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildStatsCards(weekStats, userProvider),
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
                boxShadow: CustomBoxShadow.cardBoxShadows

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
          const SizedBox(height: 16),
          SizedBox(height: 200, child: HistoryChart(data: data)),
        ],
      ),
    );
  }

  Widget _buildStatsCards(
    Map<String, double> weekStats,
    UserProvider userProvider,
  ) {
    final statsCards = StatsCards(context);
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      childAspectRatio: 1,
      children: [
        statsCards.buildStatCard(
          'Total Intakes',
          '${weekStats['totalIntakes']!.toInt()}',
          LucideIcons.hash,
          AppColors.info,
        ),
        statsCards.buildStatCard(
          'Daily Average',
          '${userProvider.userProfile!.convertCaffeineAmount(weekStats['averageCaffeine']!).toInt()}${userProvider.caffeineUnit.abbreviation}',
          LucideIcons.trendingUp,
          AppColors.success,
        ),
        statsCards.buildStatCard(
          'Total Caffeine',
          '${userProvider.userProfile!.convertCaffeineAmount(weekStats['totalCaffeine']!).toInt()}${userProvider.caffeineUnit.abbreviation}',
          LucideIcons.fuel,
          AppColors.warning,
        ),
        statsCards.buildStatCard(
          'Total Volume',
          _formatVolume(weekStats['totalVolume']!, userProvider),
          LucideIcons.calendar,
          AppColors.primaryOrange,
        ),
      ],
    );
  }

 

  Widget _buildWeekComparisonCard(
    IntakeProvider provider,
    UserProvider userProvider,
  ) {
    final currentWeekStats = _getWeekStatistics(provider);
    final globalStats = provider.getStatistics();

    // Calcola medie globali settimanali
    final globalDays = globalStats.totalIntakes > 0
        ? provider
              .intakes()
              .map(
                (i) => DateTime(
                  i.timestamp.year,
                  i.timestamp.month,
                  i.timestamp.day,
                ),
              )
              .toSet()
              .length
        : 1;
    final globalWeeksApprox = (globalDays / 7).ceil().clamp(1, double.infinity);

    final globalWeeklyAvgCaffeine =
        globalStats.totalCaffeine / globalWeeksApprox;
    final globalWeeklyAvgVolume = globalStats.totalVolume / globalWeeksApprox;
    final globalWeeklyAvgIntakes =
        globalStats.totalIntakes.toDouble() / globalWeeksApprox;

    return Column(
      children: [
        // Confronto con media globale
        _buildComparisonCard('Media Globale', currentWeekStats, {
          'totalCaffeine': globalWeeklyAvgCaffeine,
          'totalVolume': globalWeeklyAvgVolume,
          'totalIntakes': globalWeeklyAvgIntakes,
        }, userProvider),

        // Confronto con settimana corrente (solo se non siamo nella settimana corrente)
        if (_weekOffset < 0) ...[
          const SizedBox(height: 16),
          _buildComparisonCard(
            'Settimana Corrente',
            currentWeekStats,
            _getWeekStatisticsForOffset(provider, 0), // Settimana corrente
            userProvider,
          ),
        ],
      ],
    );
  }

  Widget _buildComparisonCard(
    String title,
    Map<String, double> currentStats,
    Map<String, double> compareStats,
    UserProvider userProvider,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        boxShadow: CustomBoxShadow.cardBoxShadows,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),

          // Confronto Caffeina
          _buildComparisonRow(
            'Caffeina',
            '${userProvider.userProfile!.convertCaffeineAmount(currentStats['totalCaffeine']!).toInt()} ${userProvider.caffeineUnit.abbreviation}',
            currentStats['totalCaffeine']! - compareStats['totalCaffeine']!,
            compareStats['totalCaffeine']!,
            userProvider.caffeineUnit.abbreviation,
            userProvider,
          ),

          // Confronto Volume
          _buildComparisonRow(
            'Volume',
            _formatVolume(currentStats['totalVolume']!, userProvider),
            currentStats['totalVolume']! - compareStats['totalVolume']!,
            compareStats['totalVolume']!,
            userProvider.userProfile!.volumeUnit.abbreviation,
            userProvider,
          ),

          // Confronto Assunzioni
          _buildComparisonRow(
            'Assunzioni',
            '${currentStats['totalIntakes']!.toInt()}',
            currentStats['totalIntakes']! - compareStats['totalIntakes']!,
            compareStats['totalIntakes']!,
            '',
            userProvider,
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonRow(
    String label,
    String currentValue,
    double difference,
    double compareValue,
    String unit,
    UserProvider userProvider,
  ) {
    final percentageChange = compareValue > 0
        ? (difference / compareValue) * 100
        : 0.0;

    // Convert difference to display unit based on label
    String formattedDifference;
    if (label == 'Caffeina') {
      final convertedDifference = userProvider.userProfile!
          .convertCaffeineAmount(difference);
      formattedDifference = difference >= 0
          ? '+${convertedDifference.abs().toInt()} $unit'
          : '-${convertedDifference.abs().toInt()} $unit';
    } else if (label == 'Volume') {
      formattedDifference = _formatVolumeDifference(
        difference,
        userProvider,
        difference >= 0,
      );
    } else {
      formattedDifference = difference >= 0
          ? '+${difference.abs().toInt()}'
          : '-${difference.abs().toInt()}';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              Text(
                currentValue,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formattedDifference,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: difference >= 0 ? AppColors.error : AppColors.success,
                ),
              ),
              Text(
                '${percentageChange.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 10,
                  color: difference >= 0 ? AppColors.error : AppColors.success,
                ),
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
      Duration(
        days: now.weekday - 1 + (-_weekOffset * 7),
      ), // Inversione della logica
    );
    final weekData = <DateTime, double>{};

    for (int i = 0; i < 7; i++) {
      final date = startOfWeek.add(Duration(days: i));
      weekData[date] = provider.getTotalForDate(date);
    }

    return weekData;
  }

  /// Calcola le statistiche per la settimana selezionata
  Map<String, double> _getWeekStatistics(IntakeProvider provider) {
    final weekData = _getWeekData(provider);

    // Calcola statistiche basate sui dati della settimana
    final totalCaffeine = weekData.values.fold(
      0.0,
      (sum, value) => sum + value,
    );

    // Calcola il numero di giorni con assunzioni
    final daysWithIntakes = weekData.values.where((value) => value > 0).length;

    // Media su 7 giorni
    final averageCaffeine = totalCaffeine / 7;

    // Calcola volume totale e numero totale di assunzioni per la settimana
    double totalVolume = 0.0;
    int totalIntakes = 0;
    for (final date in weekData.keys) {
      totalVolume += provider.getTotalVolumeForDate(date);
      totalIntakes += provider.getIntakesForDate(date).length;
    }

    return {
      'totalCaffeine': totalCaffeine,
      'totalIntakes': totalIntakes.toDouble(),
      'averageCaffeine': averageCaffeine,
      'totalVolume': totalVolume,
      'daysWithIntakes': daysWithIntakes.toDouble(),
    };
  }

  /// Ottiene le statistiche per un offset specifico
  Map<String, double> _getWeekStatisticsForOffset(
    IntakeProvider provider,
    int offset,
  ) {
    final originalOffset = _weekOffset;
    _weekOffset = offset;
    final stats = _getWeekStatistics(provider);
    _weekOffset = originalOffset;
    return stats;
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

  /// Formatta il volume in base alle unità e ai valori
  String _formatVolume(double volumeInMl, UserProvider userProvider) {
    final unit = userProvider.userProfile!.volumeUnit;

    // Se l'unità dell'utente è già litri, usa sempre litri con 2 decimali
    if (unit.abbreviation == 'l') {
      final convertedVolume = userProvider.userProfile!.convertVolumeAmount(
        volumeInMl,
      );
      return '${convertedVolume.toStringAsFixed(2)}${unit.abbreviation}';
    }

    // Se il volume è > 999ml, convertilo automaticamente in litri
    if (volumeInMl > 999) {
      final volumeInLiters = volumeInMl / 1000;
      return '${volumeInLiters.toStringAsFixed(2)}L';
    }

    // Altrimenti usa l'unità dell'utente senza decimali
    final convertedVolume = userProvider.userProfile!.convertVolumeAmount(
      volumeInMl,
    );
    return '${convertedVolume.toInt()}${unit.abbreviation}';
  }

  /// Formatta la differenza di volume per i confronti
  String _formatVolumeDifference(
    double differenceInMl,
    UserProvider userProvider,
    bool isPositive,
  ) {
    final unit = userProvider.userProfile!.volumeUnit;
    final sign = isPositive ? '+' : '-';
    final absDifference = differenceInMl.abs();

    // Se l'unità dell'utente è già litri, usa sempre litri con 2 decimali
    if (unit.abbreviation == 'l') {
      final convertedDifference = userProvider.userProfile!.convertVolumeAmount(
        absDifference,
      );
      return '$sign${convertedDifference.toStringAsFixed(2)} ${unit.abbreviation}';
    }

    // Se la differenza è > 999ml, convertila automaticamente in litri
    if (absDifference > 999) {
      final differenceInLiters = absDifference / 1000;
      return '$sign${differenceInLiters.toStringAsFixed(2)} L';
    }

    // Altrimenti usa l'unità dell'utente senza decimali
    final convertedDifference = userProvider.userProfile!.convertVolumeAmount(
      absDifference,
    );
    return '$sign${convertedDifference.toInt()} ${unit.abbreviation}';
  }
}
