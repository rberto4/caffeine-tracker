import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../domain/providers/caffeine_provider.dart';
import '../../utils/app_colors.dart';
import '../widgets/history_chart.dart';
import '../widgets/intake_list_item.dart';
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
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAnalyticsTab(),
                _buildHistoryTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Cronologia e Analisi'),
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
    );
  }

  Widget _buildTabBar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.grey800 : AppColors.grey100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColors.primaryOrange,
          borderRadius: BorderRadius.circular(10),
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
        tabs: const [
          Tab(
            icon: Icon(LucideIcons.barChart3, size: 18),
            text: 'Analisi',
          ),
          Tab(
            icon: Icon(LucideIcons.list, size: 18),
            text: 'Cronologia',
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    return Consumer<CaffeineProvider>(
      builder: (context, caffeineProvider, child) {
        final statistics = caffeineProvider.getStatistics();
        final chartData = caffeineProvider.last7DaysData;
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildStatsCards(statistics),
              const SizedBox(height: 24),
              _buildChart(chartData),
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
        final selectedDayIntakes = caffeineProvider.getIntakesForDate(_selectedDate);
        
        return Column(
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
                      _showCalendar ? LucideIcons.calendarDays : LucideIcons.calendar,
                      color: AppColors.primaryOrange,
                    ),
                    tooltip: _showCalendar ? 'Nascondi Calendario' : 'Mostra Calendario',
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
                  border: Border.all(color: AppColors.primaryOrange.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(LucideIcons.calendar, color: AppColors.primaryOrange, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getDateString(_selectedDate),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${selectedDayIntakes.length} ${selectedDayIntakes.length == 1 ? 'assunzione' : 'assunzioni'} - ${caffeineProvider.getTotalForDate(_selectedDate).toStringAsFixed(0)} mg',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.grey600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            
            // History list
            Expanded(
              child: _showCalendar 
                  ? _buildSelectedDateHistory(selectedDayIntakes)
                  : _buildAllHistory(caffeineProvider.intakes),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSelectedDateHistory(List<dynamic> intakes) {
    if (intakes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.coffee,
              size: 64,
              color: AppColors.grey400,
            ),
            const SizedBox(height: 16),
            Text(
              'Nessuna assunzione di caffeina',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.grey600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _getDateString(_selectedDate),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.grey500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: intakes.length,
      itemBuilder: (context, index) {
        final intake = intakes[index];
        return IntakeListItem(
          intake: intake,
          onDelete: () => _deleteIntake(intake.id),
        );
      },
    );
  }

  Widget _buildAllHistory(List<dynamic> intakes) {
    if (intakes.isEmpty) {
      return _buildEmptyHistory();
    }
    
    return RefreshIndicator(
      onRefresh: () => Provider.of<CaffeineProvider>(context, listen: false).initializeData(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: intakes.length + 1, // +1 for bottom padding
        itemBuilder: (context, index) {
          if (index == intakes.length) {
            return const SizedBox(height: 100); // Bottom padding
          }
          
          final intake = intakes[index];
          return IntakeListItem(
            intake: intake,
            onDelete: () => _deleteIntake(intake.id),
          );
        },
      ),
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
        'Gen', 'Feb', 'Mar', 'Apr', 'Mag', 'Giu',
        'Lug', 'Ago', 'Set', 'Ott', 'Nov', 'Dic'
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
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.2,
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

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    final textTheme = Theme.of(context).textTheme;
    
    return Container(
      padding: const EdgeInsets.all(16),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
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
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.grey600,
            ),
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
                'Last 7 Days',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: HistoryChart(data: data),
          ),
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
          Icon(
            LucideIcons.barChart3,
            size: 64,
            color: AppColors.grey300,
          ),
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
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.grey400,
            ),
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
        content: const Text('Are you sure you want to delete this caffeine intake?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      final caffeineProvider = Provider.of<CaffeineProvider>(context, listen: false);
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
}
