import 'package:caffeine_tracker/presentation/widgets/custom_tile_title.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../domain/providers/intake_provider.dart';
import '../../utils/app_colors.dart';
import 'modern_intake_list_item.dart';

/// Card widget displaying today's caffeine intake summary
class TodayIntakeCard extends StatelessWidget {
  const TodayIntakeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Consumer<IntakeProvider>(
      builder: (context, intakeProvider, child) {
        final todayIntakes = intakeProvider.todayIntakes;
        final totalCaffeine = intakeProvider.todayTotalCaffeine;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Header
            CustomTileTitle(
              tittle: 'Assunzioni di oggi',
              subtitle: 'Visualizza le ultime 3 assunzioni e la caffeina totale',
              leadingIcon: LucideIcons.coffee,
              trailingWidget: const SizedBox(),
            ),

            const SizedBox(height: 16),

            if (todayIntakes.isEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: _buildEmptyState(textTheme),
              )
            else
              _buildIntakesList(
                todayIntakes,
                totalCaffeine,
                textTheme,
                context,
              ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState(TextTheme textTheme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 48),
        Icon(LucideIcons.coffee, size: 48, color: AppColors.grey300),
        const SizedBox(height: 12),
        Text(
          'No caffeine intake today',
          style: textTheme.bodyLarge?.copyWith(
            color: AppColors.grey500,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Start tracking your caffeine consumption',
          style: textTheme.bodyMedium?.copyWith(color: AppColors.grey400),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildIntakesList(
    List<dynamic> intakes,
    double totalCaffeine,
    TextTheme textTheme,
    BuildContext context,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Summary
        _buildSummaryRow(intakes.length, totalCaffeine, textTheme, context),
        const SizedBox(height: 8),
        // Recent intakes (max 3)
        Column(
          children: [
            ...intakes
                .take(3)
                .map(
                  (intake) => ModernIntakeListItem(
                    intake: intake,
                    onDelete: () => _deleteIntake(context, intake.id),
                  ),
                ),
          ],
        ),

        if (intakes.length > 3) ...[
          const SizedBox(height: 8),
          Center(
            child: Text(
              '+${intakes.length - 3} more items',
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.grey500,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ] else ...[
          const SizedBox(height: 8),
        ],
      ],
    );
  }

  /// Elimina un intake dalla lista
  Future<void> _deleteIntake(BuildContext context, String intakeId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Elimina Assunzione'),
        content: const Text(
          'Sei sicuro di voler eliminare questa assunzione di caffeina?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Annulla'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Elimina'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final intakeProvider = Provider.of<IntakeProvider>(
        context,
        listen: false,
      );
      await intakeProvider.deleteIntake(intakeId);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Assunzione eliminata con successo'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  Widget _buildSummaryRow(
    int count,
    double totalCaffeine,
    TextTheme textTheme,
    BuildContext context,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$count ${count == 1 ? 'Item' : 'Items'}',
              style: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            Text(
              'Total consumed',
              style: textTheme.bodySmall?.copyWith(color: AppColors.grey500),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${totalCaffeine.toInt()}mg',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryOrange,
              ),
            ),
            Text(
              'Caffeine',
              style: textTheme.bodySmall?.copyWith(color: AppColors.grey500),
            ),
          ],
        ),
      ],
    );
  }
}
