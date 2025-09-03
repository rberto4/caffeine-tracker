import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import '../../domain/providers/caffeine_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';

/// Screen for adding new caffeine intake
class AddIntakeScreen extends StatefulWidget {
  const AddIntakeScreen({super.key});

  @override
  State<AddIntakeScreen> createState() => _AddIntakeScreenState();
}

class _AddIntakeScreenState extends State<AddIntakeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _productController = TextEditingController();
  final _caffeineController = TextEditingController();
  final _quantityController = TextEditingController();
  
  DateTime _selectedTime = DateTime.now();
  String? _selectedProduct;
  String? _scannedBarcode;
  bool _isLoading = false;

  @override
  void dispose() {
    _productController.dispose();
    _caffeineController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: _buildAppBar(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildProductSelection(),
              const SizedBox(height: 16),
              _buildCaffeineField(),
              const SizedBox(height: 16),
              _buildQuantityField(),
              const SizedBox(height: 16),
              _buildTimeSelection(),
              const SizedBox(height: 16),
              _buildBarcodeSection(),
              const SizedBox(height: 32),
              _buildSubmitButton(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Add Caffeine Intake'),
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(LucideIcons.arrowLeft),
      ),
    );
  }

  Widget _buildHeader() {
    final textTheme = Theme.of(context).textTheme;
    
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.primaryOrange.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            LucideIcons.plus,
            color: AppColors.primaryOrange,
            size: 28,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Track Your Caffeine',
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Add your caffeine intake to track your daily consumption',
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.grey600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildProductSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: _selectedProduct,
          decoration: InputDecoration(
            hintText: 'Select a product',
            prefixIcon: const Icon(LucideIcons.coffee, color: AppColors.primaryOrange),
          ),
          items: CaffeineProducts.productNames.map((product) {
            return DropdownMenuItem(
              value: product,
              child: Text(product),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedProduct = value;
              _productController.text = value ?? '';
              if (value != null) {
                final caffeine = CaffeineProducts.getCaffeineContent(value);
                _caffeineController.text = caffeine.toString();
              }
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a product';
            }
            return null;
          },
        ),
        const SizedBox(height: 8),
        Text(
          'Or enter custom product name',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.grey500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _productController,
          decoration: InputDecoration(
            hintText: 'Custom product name',
            prefixIcon: const Icon(LucideIcons.edit3, color: AppColors.primaryOrange),
          ),
          onChanged: (value) {
            if (value.isNotEmpty) {
              setState(() {
                _selectedProduct = null;
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildCaffeineField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Caffeine Content (mg)',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _caffeineController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
          ],
          decoration: InputDecoration(
            hintText: 'Enter caffeine amount',
            prefixIcon: const Icon(LucideIcons.zap, color: AppColors.primaryOrange),
            suffixText: 'mg',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter caffeine amount';
            }
            final caffeine = double.tryParse(value);
            if (caffeine == null || caffeine <= 0 || caffeine > 1000) {
              return 'Please enter a valid amount (1-1000 mg)';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildQuantityField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quantity (Optional)',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _quantityController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
          ],
          decoration: InputDecoration(
            hintText: 'e.g., 250 (for 250ml)',
            prefixIcon: const Icon(LucideIcons.droplet, color: AppColors.primaryOrange),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Time',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _selectTime,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(LucideIcons.clock, color: AppColors.primaryOrange),
                const SizedBox(width: 12),
                Text(
                  '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const Spacer(),
                const Icon(LucideIcons.chevronRight, color: AppColors.grey400),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBarcodeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Barcode (Optional)',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.grey300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _scannedBarcode ?? 'No barcode scanned',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: _scannedBarcode != null ? AppColors.grey800 : AppColors.grey500,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: _scanBarcode,
              icon: const Icon(LucideIcons.scan, size: 18),
              label: const Text('Scan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange.withOpacity(0.1),
                foregroundColor: AppColors.primaryOrange,
                elevation: 0,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleSubmit,
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                ),
              )
            : const Text('Add Intake'),
      ),
    );
  }

  Future<void> _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedTime),
    );
    
    if (time != null) {
      setState(() {
        _selectedTime = DateTime(
          _selectedTime.year,
          _selectedTime.month,
          _selectedTime.day,
          time.hour,
          time.minute,
        );
      });
    }
  }

  Future<void> _scanBarcode() async {
    try {
      final result = await BarcodeScanner.scan();
      if (result.rawContent.isNotEmpty) {
        setState(() {
          _scannedBarcode = result.rawContent;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error scanning barcode: ${e.toString()}'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final productName = _productController.text.trim();
    if (productName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a product name'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final caffeineProvider = Provider.of<CaffeineProvider>(context, listen: false);
    
    final success = await caffeineProvider.addIntake(
      productName: productName,
      caffeineAmount: double.parse(_caffeineController.text),
      timestamp: _selectedTime,
      barcode: _scannedBarcode,
      quantity: _quantityController.text.isNotEmpty 
          ? double.tryParse(_quantityController.text) 
          : null,
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (success) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Caffeine intake added successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to add intake. Please try again.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}
