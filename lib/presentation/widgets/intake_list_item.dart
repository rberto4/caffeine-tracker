import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../domain/models/caffeine_intake.dart';
import '../../utils/app_colors.dart';

/// List item widget for displaying caffeine intake entries
class IntakeListItem extends StatelessWidget {
  final CaffeineIntake intake;
  final VoidCallback? onDelete;

  const IntakeListItem({
    super.key,
    required this.intake,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildIcon(),
          const SizedBox(width: 16),
          Expanded(
            child: _buildContent(textTheme),
          ),
          _buildTrailing(textTheme),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.primaryOrange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        _getProductIcon(),
        color: AppColors.primaryOrange,
        size: 20,
      ),
    );
  }

  Widget _buildContent(TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          intake.productName,
          style: textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.grey800,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(
              LucideIcons.clock,
              size: 14,
              color: AppColors.grey500,
            ),
            const SizedBox(width: 4),
            Text(
              '${intake.formattedDate} at ${intake.formattedTime}',
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.grey500,
              ),
            ),
          ],
        ),
        if (intake.quantity != null) ...[
          const SizedBox(height: 2),
          Row(
            children: [
              Icon(
                LucideIcons.droplet,
                size: 14,
                color: AppColors.grey500,
              ),
              const SizedBox(width: 4),
              Text(
                'Quantity: ${intake.quantity}',
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.grey500,
                ),
              ),
            ],
          ),
        ],
        if (intake.barcode != null) ...[
          const SizedBox(height: 2),
          Row(
            children: [
              Icon(
                LucideIcons.scan,
                size: 14,
                color: AppColors.grey500,
              ),
              const SizedBox(width: 4),
              Text(
                'Barcode: ${intake.barcode}',
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.grey500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildTrailing(TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primaryOrange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '${intake.caffeineAmount.toInt()}mg',
            style: textTheme.labelMedium?.copyWith(
              color: AppColors.primaryOrange,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (onDelete != null) ...[
          const SizedBox(height: 8),
          GestureDetector(
            onTap: onDelete,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                LucideIcons.trash2,
                size: 16,
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ],
    );
  }

  IconData _getProductIcon() {
    final productName = intake.productName.toLowerCase();
    
    if (productName.contains('coffee') || 
        productName.contains('espresso') ||
        productName.contains('cappuccino') ||
        productName.contains('latte') ||
        productName.contains('americano') ||
        productName.contains('mocha')) {
      return LucideIcons.coffee;
    }
    
    if (productName.contains('tea')) {
      return LucideIcons.leaf;
    }
    
    if (productName.contains('energy') ||
        productName.contains('red bull') ||
        productName.contains('monster')) {
      return LucideIcons.zap;
    }
    
    if (productName.contains('cola') ||
        productName.contains('pepsi') ||
        productName.contains('coke')) {
      return LucideIcons.droplet;
    }
    
    if (productName.contains('chocolate')) {
      return LucideIcons.cookie;
    }
    
    return LucideIcons.coffee; // Default icon
  }
}
