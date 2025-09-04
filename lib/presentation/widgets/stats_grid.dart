import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

/// Widget riutilizzabile per mostrare statistiche in una griglia
class StatsGrid extends StatelessWidget {
  final List<StatCard> stats;
  final String? title;
  final IconData? titleIcon;

  const StatsGrid({
    super.key,
    required this.stats,
    this.title,
    this.titleIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                if (titleIcon != null) ...[
                  Icon(
                    titleIcon,
                    color: AppColors.primaryOrange,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  title!,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        if (title != null) const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
          children: stats.map((stat) => _buildStatCard(context, stat)).toList(),
        ),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, StatCard stat) {
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
              color: stat.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(stat.icon, color: stat.color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            stat.value,
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: stat.color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            stat.title,
            style: textTheme.bodySmall?.copyWith(color: AppColors.grey600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Data class per rappresentare una statistica
class StatCard {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });
}
