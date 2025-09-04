import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../utils/app_colors.dart';
import '../../utils/drink_categories.dart';

/// Custom widget for visual product selection with drink icons
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Seleziona Bevanda',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        
        // Category sections
        _buildCategorySection(
          context,
          'Tazza & Tazzina',
          DrinkCategories.espressoCategory,
          'Espresso, Cappuccino, Tè',
        ),
        const SizedBox(height: 20),
        
        _buildCategorySection(
          context,
          'Caffè Lunghi',
          DrinkCategories.coffeeCategory,
          'Americano, Caffè filtro',
        ),
        const SizedBox(height: 20),
        
        _buildCategorySection(
          context,
          'Energy Drink',
          DrinkCategories.energyDrinkCategory,
          'Red Bull, Monster',
        ),
        const SizedBox(height: 20),
        
        _buildCategorySection(
          context,
          'Bibite',
          DrinkCategories.sodaCategory,
          'Coca-Cola, Pepsi',
        ),
        const SizedBox(height: 24),
        
        // Custom product input
        _buildCustomProductSection(context),
      ],
    );
  }

  Widget _buildCategorySection(
    BuildContext context,
    String title,
    String category,
    String description,
  ) {
    final products = DrinkCategories.getProductsByCategory(category);
    if (products.isEmpty) return const SizedBox.shrink();

    // Get the image path for this category
    final imagePath = DrinkCategories.getImagePath(products.first);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.grey200,
          width: 1,
        ),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        leading: Container(
          width: 40,
          height: 40,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryOrange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Image.asset(
            imagePath,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                LucideIcons.coffee,
                color: AppColors.primaryOrange,
                size: 20,
              );
            },
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          description,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.grey600,
          ),
        ),
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: products.map((product) {
              final isSelected = selectedProduct == product;
              return _buildProductChip(context, product, isSelected);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildProductChip(BuildContext context, String product, bool isSelected) {
    return InkWell(
      onTap: () => onProductChanged(product),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.primaryOrange.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected 
                ? AppColors.primaryOrange
                : AppColors.grey300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              const Icon(
                LucideIcons.check,
                color: AppColors.primaryOrange,
                size: 16,
              ),
              const SizedBox(width: 4),
            ],
            Flexible(
              child: Text(
                product,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isSelected 
                      ? AppColors.primaryOrange
                      : Theme.of(context).colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomProductSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.grey200,
          width: 1,
        ),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.grey200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            LucideIcons.edit3,
            color: AppColors.grey600,
            size: 20,
          ),
        ),
        title: Text(
          'Prodotto Personalizzato',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          'Inserisci un prodotto non in lista',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.grey600,
          ),
        ),
        children: [
          TextFormField(
            initialValue: customProductName,
            decoration: InputDecoration(
              hintText: 'Nome del prodotto personalizzato',
              prefixIcon: const Icon(LucideIcons.coffee, color: AppColors.primaryOrange),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.grey300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.primaryOrange, width: 2),
              ),
            ),
            onChanged: (value) {
              onCustomProductChanged(value);
              if (value.isNotEmpty) {
                onProductChanged(null); // Clear selected product when typing custom
              }
            },
          ),
        ],
      ),
    );
  }
}
