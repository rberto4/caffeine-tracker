import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

/// Custom widget for visual product selection with drink icons
/// NOTE: This widget is deprecated in favor of the new Beverage system
class VisualProductSelector extends StatelessWidget {
  final String? selectedProduct;
  final Function(String?) onProductChanged;
  final String? customProductName;
  final Function(String) onCustomProductChanged;

  const VisualProductSelector({
    super.key,
    required this.selectedProduct,
    required this.onProductChanged,
    this.customProductName,
    required this.onCustomProductChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Widget deprecated - use BeverageProvider and QuickAddGrid instead
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Text(
        'This widget has been replaced by the new Beverage system',
        style: TextStyle(
          fontSize: 16,
          color: AppColors.grey600,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
