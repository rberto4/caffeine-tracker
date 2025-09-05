import 'package:flutter/material.dart';
import '../../domain/models/intake.dart';
import '../../utils/app_colors.dart';

/// List item widget for displaying caffeine intake entries
/// NOTE: This widget is deprecated in favor of ModernIntakeListItem
class IntakeListItem extends StatelessWidget {
  final Intake intake;
  final VoidCallback? onDelete;

  const IntakeListItem({
    super.key,
    required this.intake,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Widget deprecated - use ModernIntakeListItem instead
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Text(
        'This widget has been replaced by ModernIntakeListItem',
        style: TextStyle(
          fontSize: 16,
          color: AppColors.grey600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
