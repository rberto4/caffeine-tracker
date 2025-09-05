import 'package:caffeine_tracker/domain/providers/intake_provider.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../utils/app_colors.dart';
import '../widgets/modern_intake_list_item.dart';
import '../widgets/custom_calendar.dart';

/// Screen showing caffeine intake calendar and detailed history
class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  bool _showCalendar = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
     
      body: Consumer<IntakeProvider>(
        builder: (context, intakeProvider, child) {
          final selectedDayIntakes = intakeProvider.getIntakesForDate(
            _selectedDate,
          );

          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Calendar toggle button
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Cronologia',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 24
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
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryOrange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          LucideIcons.calendar,
                          color: AppColors.primaryOrange,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        _getDateString(_selectedDate),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '${selectedDayIntakes.length} ${selectedDayIntakes.length == 1 ? 'assunzione' : 'assunzioni'} - ${intakeProvider.getTotalForDate(_selectedDate).toStringAsFixed(0)} mg',
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
                      ),
                    ),
            
                  // History list
                  _showCalendar
                      ? _buildSelectedDateHistory(selectedDayIntakes)
                      : _buildAllHistory(intakeProvider.intakes),
                ],
              ),
            ),
          );
        },
      ),
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
                ).textTheme.bodySmall?.copyWith(color: AppColors.grey500),
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
              onDelete: () => _deleteIntake(intake.id),
            );
          },
        ),
        const SizedBox(height: 100), // Bottom padding
      ],
    );
  }

  Widget _buildEmptyHistory() {
    return SizedBox(
      height: 400,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.coffee, size: 80, color: AppColors.grey400),
            const SizedBox(height: 24),
            Text(
              'Nessuna assunzione registrata',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.grey600,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Inizia a registrare le tue assunzioni di caffeina',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.grey500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
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

  Future<void> _deleteIntake(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Conferma eliminazione'),
          content: const Text(
            'Sei sicuro di voler eliminare questa assunzione di caffeina?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Annulla'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.error,
              ),
              child: const Text('Elimina'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      final intakeProvider = Provider.of<IntakeProvider>(context, listen: false);
      await intakeProvider.deleteIntake(id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Assunzione eliminata con successo'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }
}
