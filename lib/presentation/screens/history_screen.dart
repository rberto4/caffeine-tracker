import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../domain/providers/caffeine_provider.dart';
import '../../utils/app_colors.dart';
import '../widgets/history_chart.dart';
import '../widgets/modern_intake_list_item.dart';
import '../widgets/custom_calendar.dart';

/// Screen showing caffeine intake history and analytics
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime _selectedDate = DateTime.now();
  bool _showCalendar = false;
  int _weekOffset =
      0; // 0 = settimana corrente, -1 = settimana precedente, etc.

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [_buildAnalyticsTab(), _buildHistoryTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),

      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: AppColors.primaryOrange,
            borderRadius: BorderRadius.circular(64),
          ),
          labelColor: Colors.white,
          unselectedLabelColor: isDark ? AppColors.grey300 : AppColors.grey600,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          dividerColor: Colors.transparent,
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          tabs: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Tab(
                height: 48,
                icon: Icon(LucideIcons.barChart3, size: 18),
                text: 'Analisi',
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Tab(
                icon: Icon(LucideIcons.calendarDays, size: 18),
                text: 'Cronologia',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    return Consumer<CaffeineProvider>(
      builder: (context, caffeineProvider, child) {
        final statistics = caffeineProvider.getStatistics();
        final chartData = _getWeekData(caffeineProvider);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
    );
  }

  Widget _buildHistoryTab() {
    return Consumer<CaffeineProvider>(
      builder: (context, caffeineProvider, child) {
        final selectedDayIntakes = caffeineProvider.getIntakesForDate(
          _selectedDate,
        );

        return SingleChildScrollView(
          child: Column(
            children: [
              // Calendar toggle button
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Cronologia Dettagliata',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _showCalendar = !_showCalendar;
                        });
                      },
                      icon: Icon(
                        _showCalendar
                            ? LucideIcons.calendarDays
                            : LucideIcons.calendar,
                        color: AppColors.primaryOrange,
                      ),
                      tooltip: _showCalendar
                          ? 'Nascondi Calendario'
                          : 'Mostra Calendario',
                    ),
                  ],
                ),
              ),

              // Calendar widget
              if (_showCalendar) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CustomCalendar(
                    selectedDate: _selectedDate,
                    onDateSelected: (date) {
                      setState(() {
                        _selectedDate = date;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Selected date info
              if (_showCalendar)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primaryOrange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primaryOrange.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        LucideIcons.calendar,
                        color: AppColors.primaryOrange,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getDateString(_selectedDate),
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              '${selectedDayIntakes.length} ${selectedDayIntakes.length == 1 ? 'assunzione' : 'assunzioni'} - ${caffeineProvider.getTotalForDate(_selectedDate).toStringAsFixed(0)} mg',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppColors.grey600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              // History list
              _showCalendar
                  ? _buildSelectedDateHistory(selectedDayIntakes)
                  : _buildAllHistory(caffeineProvider.intakes),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSelectedDateHistory(List<dynamic> intakes) {
    if (intakes.isEmpty) {
      return SizedBox(
        height: 300,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.coffee, size: 64, color: AppColors.grey400),
              const SizedBox(height: 16),
              Text(
                'Nessuna assunzione di caffeina',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: AppColors.grey600),
              ),
              const SizedBox(height: 8),
              Text(
                _getDateString(_selectedDate),
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.grey500),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.all(16),
          itemCount: intakes.length,
          itemBuilder: (context, index) {
            final intake = intakes[index];
            return ModernIntakeListItem(
              intake: intake,
              showDeleteButton: true,
              showFullDate: false,
              onDelete: () => _deleteIntake(intake.id),
            );
          },
        ),
        const SizedBox(height: 100), // Bottom padding
      ],
    );
  }

  Widget _buildAllHistory(List<dynamic> intakes) {
    if (intakes.isEmpty) {
      return _buildEmptyHistory();
    }

    return Column(
      children: [
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: const EdgeInsets.all(16),
          itemCount: intakes.length,
          itemBuilder: (context, index) {
            final intake = intakes[index];
            return ModernIntakeListItem(
              intake: intake,
              showDeleteButton: true,
              showFullDate: true,  // For week view, show full date
              onDelete: () => _deleteIntake(intake.id),
            );
          },
        ),
        const SizedBox(height: 100), // Bottom padding
      ],
    );
  }

  String _getDateString(DateTime date) {
    final now = DateTime.now();

    if (_isSameDay(date, now)) {
      return 'Oggi';
    } else if (_isSameDay(date, now.subtract(const Duration(days: 1)))) {
      return 'Ieri';
    } else {
      const months = [
        'Gen',
        'Feb',
        'Mar',
        'Apr',
        'Mag',
        'Giu',
        'Lug',
        'Ago',
        'Set',
        'Ott',
        'Nov',
        'Dic',
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Widget _buildStatsCards(Map<String, dynamic> stats) {
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
          '${stats['totalIntakes']}',
          LucideIcons.hash,
          AppColors.info,
        ),
        _buildStatCard(
          'Daily Average',
          '${(stats['averageDaily'] as double).toInt()}mg',
          LucideIcons.trendingUp,
          AppColors.success,
        ),
        _buildStatCard(
          'Daily Peak',
          '${(stats['maxDaily'] as double).toInt()}mg',
          LucideIcons.zap,
          AppColors.warning,
        ),
        _buildStatCard(
          'Days Tracked',
          '${stats['daysTracked']}',
          LucideIcons.calendar,
          AppColors.primaryOrange,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: textTheme.bodySmall?.copyWith(color: AppColors.grey600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildChart(Map<DateTime, double> data) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    _getWeekTitle(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _weekOffset--;
                      });
                    },
                    icon: const Icon(LucideIcons.chevronLeft),
                    tooltip: 'Settimana Precedente',
                  ),
                  IconButton(
                    onPressed: _weekOffset >= 0
                        ? null
                        : () {
                            setState(() {
                              _weekOffset++;
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

  Widget _buildEmptyHistory() {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.barChart3, size: 64, color: AppColors.grey300),
          const SizedBox(height: 16),
          Text(
            'No History Yet',
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.grey500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start tracking your caffeine intake\nto see analytics here',
            style: textTheme.bodyMedium?.copyWith(color: AppColors.grey400),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<void> _deleteIntake(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Intake'),
        content: const Text(
          'Are you sure you want to delete this caffeine intake?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final caffeineProvider = Provider.of<CaffeineProvider>(
        context,
        listen: false,
      );
      await caffeineProvider.removeIntake(id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Intake deleted successfully'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  /// Ottiene i dati per la settimana specificata dal weekOffset
  Map<DateTime, double> _getWeekData(CaffeineProvider provider) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(
      Duration(days: now.weekday - 1 + (_weekOffset * 7)),
    );
    final weekData = <DateTime, double>{};

    for (int i = 0; i < 7; i++) {
      final date = startOfWeek.add(Duration(days: i));
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

  /// Costruisce la card di confronto settimanale
  Widget _buildWeekComparisonCard(CaffeineProvider provider) {
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
    final currentIntakes = _getWeekIntakesCount(provider, currentWeekData);
    final previousIntakes = _getWeekIntakesCount(provider, previousWeekData);

    final caffeineChange = previousTotal > 0
        ? ((currentTotal - previousTotal) / previousTotal * 100)
        : 0.0;
    final intakesChange = previousIntakes > 0
        ? ((currentIntakes - previousIntakes) / previousIntakes * 100)
        : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 5,
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
                LucideIcons.trendingUp,
                color: AppColors.primaryOrange,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Confronto Settimanale',
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
                child: _buildComparisonItem(
                  'Assunzioni',
                  currentIntakes.toString(),
                  intakesChange,
                  LucideIcons.hash,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildComparisonItem(
                  'Caffeina Totale',
                  '${currentTotal.toInt()}mg',
                  caffeineChange,
                  LucideIcons.coffee,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Ottiene i dati della settimana precedente per il confronto
  Map<DateTime, double> _getPreviousWeekData(CaffeineProvider provider) {
    final now = DateTime.now();
    final startOfPreviousWeek = now.subtract(
      Duration(days: now.weekday - 1 + ((_weekOffset - 1) * 7)),
    );
    final weekData = <DateTime, double>{};

    for (int i = 0; i < 7; i++) {
      final date = startOfPreviousWeek.add(Duration(days: i));
      weekData[date] = provider.getTotalForDate(date);
    }

    return weekData;
  }

  /// Conta il numero di assunzioni in una settimana
  int _getWeekIntakesCount(
    CaffeineProvider provider,
    Map<DateTime, double> weekData,
  ) {
    int count = 0;
    for (final date in weekData.keys) {
      count += provider.getIntakesForDate(date).length;
    }
    return count;
  }

  /// Costruisce un elemento di confronto
  Widget _buildComparisonItem(
    String label,
    String value,
    double changePercent,
    IconData icon,
  ) {
    final isPositive = changePercent >= 0;
    final color = isPositive ? AppColors.success : AppColors.error;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.grey600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                isPositive ? LucideIcons.trendingUp : LucideIcons.trendingDown,
                color: color,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                '${changePercent.abs().toStringAsFixed(1)}%',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Expanded(
                child: Text(
                  ' vs precedente',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.grey500),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
