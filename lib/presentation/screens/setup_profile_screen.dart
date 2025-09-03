import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../domain/providers/user_provider.dart';
import '../../domain/models/user_profile.dart';
import '../../utils/app_colors.dart';
import 'main_screen.dart';

/// Screen for setting up user profile (weight and age)
class SetupProfileScreen extends StatefulWidget {
  const SetupProfileScreen({super.key});

  @override
  State<SetupProfileScreen> createState() => _SetupProfileScreenState();
}

class _SetupProfileScreenState extends State<SetupProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  final _ageController = TextEditingController();
  bool _isLoading = false;
  
  // New settings
  Gender _selectedGender = Gender.male;
  WeightUnit _selectedWeightUnit = WeightUnit.kg;
  CaffeineUnit _selectedCaffeineUnit = CaffeineUnit.mg;

  @override
  void dispose() {
    _weightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  
                  // Header
                  _buildHeader(textTheme),
                  
                  const SizedBox(height: 40),
                  
                  // Form fields
                  _buildWeightField(),
                  const SizedBox(height: 24),
                  _buildAgeField(),
                  const SizedBox(height: 24),
                  _buildGenderField(),
                  const SizedBox(height: 24),
                  _buildUnitsSettings(),
                  const SizedBox(height: 40),
                  _buildInfoCard(),
                  const SizedBox(height: 40),
                  
                  // Submit button
                  _buildSubmitButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(TextTheme textTheme) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.primaryOrange.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            LucideIcons.user,
            size: 40,
            color: AppColors.primaryOrange,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Configura il tuo Profilo',
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Abbiamo bisogno del tuo peso, età e preferenze per calcolare il tuo limite giornaliero di caffeina personalizzato.',
          style: textTheme.bodyLarge?.copyWith(
            color: AppColors.grey600,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildWeightField() {
    return TextFormField(
      controller: _weightController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
      ],
      decoration: InputDecoration(
        labelText: 'Peso (${_selectedWeightUnit.abbreviation})',
        prefixIcon: const Icon(LucideIcons.scale, color: AppColors.primaryOrange),
        suffixText: _selectedWeightUnit.abbreviation,
        hintText: 'Inserisci il tuo peso',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Inserisci il tuo peso';
        }
        final weight = double.tryParse(value);
        final maxWeight = _selectedWeightUnit == WeightUnit.kg ? 300.0 : 660.0; // ~300kg in lbs
        if (weight == null || weight <= 0 || weight > maxWeight) {
          return 'Inserisci un peso valido (1-${maxWeight.toInt()} ${_selectedWeightUnit.abbreviation})';
        }
        return null;
      },
    );
  }

  Widget _buildAgeField() {
    return TextFormField(
      controller: _ageController,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      decoration: InputDecoration(
        labelText: 'Età (anni)',
        prefixIcon: const Icon(LucideIcons.calendar, color: AppColors.primaryOrange),
        suffixText: 'anni',
        hintText: 'Inserisci la tua età',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Inserisci la tua età';
        }
        final age = int.tryParse(value);
        if (age == null || age < 10 || age > 120) {
          return 'Inserisci un\'età valida (10-120 anni)';
        }
        return null;
      },
    );
  }

  Widget _buildGenderField() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(LucideIcons.users, color: AppColors.primaryOrange, size: 20),
                const SizedBox(width: 12),
                Text(
                  'Sesso',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: Gender.values.map((gender) {
              return Expanded(
                child: RadioListTile<Gender>(
                  title: Text(gender.displayName),
                  value: gender,
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value!;
                    });
                  },
                  activeColor: AppColors.primaryOrange,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildUnitsSettings() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(LucideIcons.settings, color: AppColors.primaryOrange, size: 20),
                const SizedBox(width: 12),
                Text(
                  'Unità di Misura',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text('Peso:', style: Theme.of(context).textTheme.bodyMedium),
                    ),
                    SegmentedButton<WeightUnit>(
                      segments: WeightUnit.values.map((unit) {
                        return ButtonSegment<WeightUnit>(
                          value: unit,
                          label: Text(unit.abbreviation),
                        );
                      }).toList(),
                      selected: {_selectedWeightUnit},
                      onSelectionChanged: (values) {
                        setState(() {
                          _selectedWeightUnit = values.first;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text('Caffeina:', style: Theme.of(context).textTheme.bodyMedium),
                    ),
                    SegmentedButton<CaffeineUnit>(
                      segments: CaffeineUnit.values.map((unit) {
                        return ButtonSegment<CaffeineUnit>(
                          value: unit,
                          label: Text(unit.abbreviation),
                        );
                      }).toList(),
                      selected: {_selectedCaffeineUnit},
                      onSelectionChanged: (values) {
                        setState(() {
                          _selectedCaffeineUnit = values.first;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.info.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            LucideIcons.info,
            color: AppColors.info,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Your data is stored locally on your device and never shared.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.info,
              ),
            ),
          ),
        ],
      ),
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
            : const Text('Completa Configurazione'),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final weight = double.parse(_weightController.text);
    final age = int.parse(_ageController.text);

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    final success = await userProvider.completeOnboarding(
      weight: weight,
      age: age,
      gender: _selectedGender,
      weightUnit: _selectedWeightUnit,
      caffeineUnit: _selectedCaffeineUnit,
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (success) {
        // Navigate to main screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const MainScreen(),
          ),
        );
      } else {
        // Show error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Errore nel salvataggio del profilo. Riprova.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}
