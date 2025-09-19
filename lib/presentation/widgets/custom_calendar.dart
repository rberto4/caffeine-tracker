import 'package:caffeine_tracker/domain/providers/intake_provider.dart';
import 'package:caffeine_tracker/presentation/widgets/box_shadow.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../utils/app_colors.dart';

/// Custom calendar widget for history screen
class CustomCalendar extends StatefulWidget {
  final Function(DateTime) onDateSelected;
  final DateTime selectedDate;

  const CustomCalendar({
    super.key,
    required this.onDateSelected,
    required this.selectedDate,
  });

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  late DateTime _currentMonth;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(
      widget.selectedDate.year,
      widget.selectedDate.month,
    );
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
                boxShadow: CustomBoxShadow.cardBoxShadows

      ),
      child: Column(
        children: [_buildHeader(), _buildWeekDayLabels(), _buildCalendarGrid()],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: _previousMonth,
            icon: const Icon(LucideIcons.chevronLeft),
            color: Theme.of(context).colorScheme.primary,
          ),
          Text(
            _getMonthYearString(_currentMonth),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          IconButton(
            onPressed: _nextMonth,
            icon: const Icon(LucideIcons.chevronRight),
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildWeekDayLabels() {
    const weekDays = ['Lun', 'Mar', 'Mer', 'Gio', 'Ven', 'Sab', 'Dom'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: weekDays.map((day) {
          return Expanded(
            child: Text(
              day,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.grey600,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    return Consumer<IntakeProvider>(
      builder: (context, caffeineProvider, child) {
        final firstDayOfMonth = DateTime(
          _currentMonth.year,
          _currentMonth.month,
          1,
        );
        final firstWeekday = firstDayOfMonth.weekday;

        // Calculate how many days from previous month to show
        final daysFromPrevMonth = firstWeekday - 1;
        final totalCells = 42; // 6 weeks * 7 days

        return Container(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: totalCells,
            itemBuilder: (context, index) {
              final DateTime cellDate = _getCellDate(index, daysFromPrevMonth);
              final bool isCurrentMonth = cellDate.month == _currentMonth.month;
              final bool isSelected = _isSameDay(cellDate, widget.selectedDate);
              final bool isToday = _isSameDay(cellDate, DateTime.now());

              // Get caffeine data for this date
              final dailyIntake = caffeineProvider.getTotalForDate(cellDate);
              final hasData = dailyIntake > 0;

              return _buildDateCell(
                cellDate,
                isCurrentMonth,
                isSelected,
                isToday,
                hasData,
                dailyIntake,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildDateCell(
    DateTime date,
    bool isCurrentMonth,
    bool isSelected,
    bool isToday,
    bool hasData,
    double dailyIntake,
  ) {
    Color backgroundColor = Colors.transparent;
    Color textColor = isCurrentMonth
        ? Theme.of(context).colorScheme.onSurface
        : AppColors.grey400;

    if (isSelected) {
      backgroundColor = Theme.of(context).colorScheme.primary;
      textColor = Colors.white;
    } else if (isToday) {
      backgroundColor = Theme.of(context).colorScheme.primary.withValues(alpha: 0.1);
      textColor = Theme.of(context).colorScheme.primary;
    }

    return GestureDetector(
      onTap: isCurrentMonth ? () => widget.onDateSelected(date) : null,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: hasData && !isSelected
              ? Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1), width: 1)
              : null,
        ),
        child: Stack(
          children: [
            Center(
              child: Text(
                date.day.toString(),
                style: TextStyle(
                  color: textColor,
                  fontWeight: isSelected || isToday
                      ? FontWeight.w700
                      : FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
            if (hasData && !isSelected)
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: _getIntakeColor(dailyIntake),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getIntakeColor(double intake) {
    if (intake == 0) return Colors.transparent;

    // Use caffeine status colors
    final maxIntake = 400.0; // Default max
    final percentage = (intake / maxIntake) * 100;

    if (percentage <= 50) return AppColors.success;
    if (percentage <= 75) return AppColors.warning;
    if (percentage <= 100) return Theme.of(context).colorScheme.primary;
    return AppColors.error;
  }

  DateTime _getCellDate(int index, int daysFromPrevMonth) {
    if (index < daysFromPrevMonth) {
      // Previous month days
      final prevMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
      final daysInPrevMonth = _getDaysInMonth(prevMonth);
      final dayNumber = daysInPrevMonth - (daysFromPrevMonth - index - 1);
      return DateTime(prevMonth.year, prevMonth.month, dayNumber);
    } else {
      // Current or next month days
      final dayNumber = index - daysFromPrevMonth + 1;
      final daysInCurrentMonth = _getDaysInMonth(_currentMonth);

      if (dayNumber <= daysInCurrentMonth) {
        // Current month
        return DateTime(_currentMonth.year, _currentMonth.month, dayNumber);
      } else {
        // Next month
        final nextMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
        return DateTime(
          nextMonth.year,
          nextMonth.month,
          dayNumber - daysInCurrentMonth,
        );
      }
    }
  }

  int _getDaysInMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0).day;
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String _getMonthYearString(DateTime date) {
    const months = [
      'Gennaio',
      'Febbraio',
      'Marzo',
      'Aprile',
      'Maggio',
      'Giugno',
      'Luglio',
      'Agosto',
      'Settembre',
      'Ottobre',
      'Novembre',
      'Dicembre',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    final now = DateTime.now();
    final nextMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);

    // Don't allow navigation beyond current month
    if (nextMonth.isBefore(DateTime(now.year, now.month + 1))) {
      setState(() {
        _currentMonth = nextMonth;
      });
    }
  }
}
