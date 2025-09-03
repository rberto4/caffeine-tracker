import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../domain/providers/caffeine_provider.dart';
import '../../utils/app_colors.dart';

/// Grid widget for quick adding popular caffeine products
class QuickAddGrid extends StatelessWidget {
  const QuickAddGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final quickProducts = [
      {'name': 'Espresso (30ml)', 'caffeine': 63.0, 'icon': LucideIcons.coffee},
      {'name': 'Coffee (240ml)', 'caffeine': 95.0, 'icon': LucideIcons.coffee},
      {'name': 'Red Bull (250ml)', 'caffeine': 80.0, 'icon': LucideIcons.zap},
      {'name': 'Green Tea (240ml)', 'caffeine': 25.0, 'icon': LucideIcons.leaf},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: quickProducts.length,
      itemBuilder: (context, index) {
        final product = quickProducts[index];
        return _buildQuickAddCard(
          context,
          product['name'] as String,
          product['caffeine'] as double,
          product['icon'] as IconData,
        );
      },
    );
  }

  Widget _buildQuickAddCard(
    BuildContext context,
    String productName,
    double caffeineAmount,
    IconData icon,
  ) {
    final textTheme = Theme.of(context).textTheme;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _addQuickIntake(context, productName, caffeineAmount),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.grey200,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primaryOrange,
                  size: 24,
                ),
              ),
              
              const SizedBox(height: 12),
              
              Text(
                productName.split('(')[0].trim(), // Remove volume info for display
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 4),
              
              Text(
                '${caffeineAmount.toInt()}mg',
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.primaryOrange,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addQuickIntake(
    BuildContext context,
    String productName,
    double caffeineAmount,
  ) async {
    final caffeineProvider = Provider.of<CaffeineProvider>(context, listen: false);
    
    // Show loading
    _showLoadingSnackbar(context);
    
    final success = await caffeineProvider.addIntake(
      productName: productName,
      caffeineAmount: caffeineAmount,
    );
    
    // Remove loading snackbar
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    
    if (success) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                LucideIcons.checkCircle,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Added $productName',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                LucideIcons.xCircle,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Failed to add intake. Please try again.',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  void _showLoadingSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Adding intake...',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: AppColors.primaryOrange,
        duration: const Duration(minutes: 1), // Will be hidden manually
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
