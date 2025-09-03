import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../domain/providers/user_provider.dart';
import '../../domain/providers/caffeine_provider.dart';
import '../../domain/models/user_profile.dart';
import '../../utils/app_colors.dart';

/// Screen for app settings
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Impostazioni'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onSurface,
        ),
        titleTextStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (userProvider.userProfile == null) {
            return const Center(
              child: Text('Nessun profilo trovato'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gender Setting
                _buildGenderSetting(userProvider),
                const SizedBox(height: 24),
                
                // Units Settings
                _buildUnitsSettings(userProvider),
                const SizedBox(height: 24),
                
                // Personal Info
                _buildPersonalInfo(userProvider),
                const SizedBox(height: 24),
                
                // Data Management
                _buildDataManagement(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGenderSetting(UserProvider userProvider) {
    return _buildSettingCard(
      title: 'Sesso',
      icon: LucideIcons.users,
      child: Column(
        children: Gender.values.map((gender) {
          return RadioListTile<Gender>(
            title: Text(gender.displayName),
            value: gender,
            groupValue: userProvider.userGender,
            onChanged: (value) async {
              if (value != null) {
                await userProvider.updateGender(value);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Sesso aggiornato a ${value.displayName}'),
                      backgroundColor: AppColors.success,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              }
            },
            activeColor: AppColors.primaryOrange,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildUnitsSettings(UserProvider userProvider) {
    return _buildSettingCard(
      title: 'Unità di Misura',
      icon: LucideIcons.ruler,
      child: Column(
        children: [
          // Weight Unit
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Peso',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SegmentedButton<WeightUnit>(
                  segments: WeightUnit.values.map((unit) {
                    return ButtonSegment<WeightUnit>(
                      value: unit,
                      label: Text(unit.abbreviation),
                    );
                  }).toList(),
                  selected: {userProvider.weightUnit},
                  onSelectionChanged: (values) async {
                    final newUnit = values.first;
                    await userProvider.updateWeightUnit(newUnit);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Unità peso aggiornata a ${newUnit.displayName}'),
                          backgroundColor: AppColors.success,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          // Caffeine Unit
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Caffeina',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SegmentedButton<CaffeineUnit>(
                  segments: CaffeineUnit.values.map((unit) {
                    return ButtonSegment<CaffeineUnit>(
                      value: unit,
                      label: Text(unit.abbreviation),
                    );
                  }).toList(),
                  selected: {userProvider.caffeineUnit},
                  onSelectionChanged: (values) async {
                    final newUnit = values.first;
                    await userProvider.updateCaffeineUnit(newUnit);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Unità caffeina aggiornata a ${newUnit.displayName}'),
                          backgroundColor: AppColors.success,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfo(UserProvider userProvider) {
    final profile = userProvider.userProfile!;
    return _buildSettingCard(
      title: 'Informazioni Personali',
      icon: LucideIcons.user,
      child: Column(
        children: [
          // Editable Weight
          _buildEditableRow(
            'Peso',
            '${profile.weight.toStringAsFixed(1)} ${profile.weightUnit.abbreviation}',
            LucideIcons.scale,
            () => _editWeight(userProvider),
          ),
          const Divider(),
          // Editable Age
          _buildEditableRow(
            'Età',
            '${profile.age} anni',
            LucideIcons.calendar,
            () => _editAge(userProvider),
          ),
          const Divider(),
          // Read-only Daily Limit
          _buildInfoRow(
            'Limite Giornaliero',
            '${profile.convertCaffeineAmount(profile.maxDailyCaffeine).toStringAsFixed(0)} ${profile.caffeineUnit.abbreviation}',
            LucideIcons.coffee,
          ),
        ],
      ),
    );
  }

  Widget _buildDataManagement() {
    return _buildSettingCard(
      title: 'Gestione Dati',
      icon: LucideIcons.database,
      child: Column(
        children: [
          ListTile(
            leading: const Icon(LucideIcons.trash2, color: AppColors.error),
            title: const Text('Cancella tutti i dati'),
            subtitle: const Text('Rimuove tutte le assunzioni di caffeina registrate'),
            onTap: _showDeleteDataDialog,
            contentPadding: EdgeInsets.zero,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(LucideIcons.userX, color: AppColors.error),
            title: const Text('Reset profilo'),
            subtitle: const Text('Cancella il profilo utente e riavvia l\'onboarding'),
            onTap: _showResetProfileDialog,
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildEditableRow(String label, String value, IconData icon, VoidCallback onEdit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.grey600,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.grey600,
              ),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: onEdit,
            icon: const Icon(LucideIcons.edit2, size: 16),
            color: AppColors.primaryOrange,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.grey200,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: AppColors.primaryOrange,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.grey600,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.grey600,
              ),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _editWeight(UserProvider userProvider) async {
    final weightController = TextEditingController(
      text: userProvider.userWeight.toString(),
    );
    
    final result = await showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifica Peso'),
        content: TextField(
          controller: weightController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
          ],
          decoration: InputDecoration(
            labelText: 'Peso (${userProvider.weightUnit.abbreviation})',
            suffixText: userProvider.weightUnit.abbreviation,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annulla'),
          ),
          TextButton(
            onPressed: () {
              final weight = double.tryParse(weightController.text);
              if (weight != null && weight > 0 && weight <= 500) {
                Navigator.of(context).pop(weight);
              }
            },
            child: const Text('Salva'),
          ),
        ],
      ),
    );

    if (result != null) {
      await userProvider.updateProfile(weight: result);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Peso aggiornato a ${result.toStringAsFixed(1)} ${userProvider.weightUnit.abbreviation}'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
    weightController.dispose();
  }

  void _editAge(UserProvider userProvider) async {
    final ageController = TextEditingController(
      text: userProvider.userAge.toString(),
    );
    
    final result = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifica Età'),
        content: TextField(
          controller: ageController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: const InputDecoration(
            labelText: 'Età (anni)',
            suffixText: 'anni',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annulla'),
          ),
          TextButton(
            onPressed: () {
              final age = int.tryParse(ageController.text);
              if (age != null && age >= 10 && age <= 120) {
                Navigator.of(context).pop(age);
              }
            },
            child: const Text('Salva'),
          ),
        ],
      ),
    );

    if (result != null) {
      await userProvider.updateProfile(age: result);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Età aggiornata a $result anni'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
    ageController.dispose();
  }

  void _showDeleteDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancella tutti i dati'),
        content: const Text(
          'Sei sicuro di voler cancellare tutte le assunzioni di caffeina registrate? Questa azione non può essere annullata.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annulla'),
          ),
          TextButton(
            onPressed: () async {
              final caffeineProvider = Provider.of<CaffeineProvider>(context, listen: false);
              await caffeineProvider.clearAllData();
              if (mounted) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tutti i dati delle assunzioni sono stati cancellati'),
                    backgroundColor: AppColors.success,
                  ),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Cancella'),
          ),
        ],
      ),
    );
  }

  void _showResetProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset profilo'),
        content: const Text(
          'Sei sicuro di voler resettare il profilo? Verrai riportato alla schermata di onboarding e tutti i dati verranno cancellati.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annulla'),
          ),
          TextButton(
            onPressed: () async {
              final userProvider = Provider.of<UserProvider>(context, listen: false);
              final caffeineProvider = Provider.of<CaffeineProvider>(context, listen: false);
              
              await caffeineProvider.clearAllData();
              await userProvider.resetProfile();
              
              if (mounted) {
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
