import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../domain/models/beverage.dart';
import '../../domain/models/intake.dart';
import '../../domain/providers/beverage_provider.dart';
import '../../domain/providers/intake_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_constants.dart';
import '../widgets/custom_standard_button.dart';
import '../widgets/custom_tile_title.dart';
import '../widgets/box_shadow.dart';

/// Screen for adding custom beverage intakes
class OtherIntakesScreen extends StatefulWidget {
  const OtherIntakesScreen({super.key});

  @override
  State<OtherIntakesScreen> createState() => _OtherIntakesScreenState();
}

class _OtherIntakesScreenState extends State<OtherIntakesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _volumeController = TextEditingController();
  final _caffeineController = TextEditingController();

  int _selectedColorIndex = 0;
  int _selectedImageIndex = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Debug: stampa tutti i path delle immagini
    BeverageAssets.debugPrintAllImages();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _volumeController.dispose();
    _caffeineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Aggiungi Bevanda Personalizzata'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildBeveragePreview(),
                const SizedBox(height: 24),
                _buildNameField(),
                const SizedBox(height: 16),
                _buildVolumeField(),
                const SizedBox(height: 16),
                _buildCaffeineField(),
                const SizedBox(height: 24),
                _buildImageSelector(),
                const SizedBox(height: 24),
                _buildColorSelector(),
                const SizedBox(height: 32),
                _buildActionButtons(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: CustomBoxShadow.cardBoxShadows,
      ),
      child: Column(
        children: [
          Icon(LucideIcons.plus, size: 48, color: Colors.white),
          const SizedBox(height: 12),
          Text(
            'Crea la tua bevanda',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Personalizza nome, volume, caffeina, icona e colore',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBeveragePreview() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        boxShadow: CustomBoxShadow.cardBoxShadows,
      ),
      child: Column(
        children: [
          CustomTileTitle(
            tittle: 'Anteprima',
            subtitle: 'Come apparirà la tua bevanda',
            leadingIcon: LucideIcons.eye,
          ),
          const SizedBox(height: 16),
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.getBeverageColor(_selectedColorIndex),
                  AppColors.getBeverageColor(
                    _selectedColorIndex,
                  ).withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: CustomBoxShadow.cardBoxShadows,
            ),
            child: Stack(
              children: [
                // Background watermark
                Positioned(
                  top: -20,
                  right: -10,
                  child: Transform.rotate(
                    angle: 0.3,
                    child: Image.asset(
                      BeverageAssets.getBeverageImage(_selectedImageIndex),
                      width: 80,
                      height: 80,
                      opacity: const AlwaysStoppedAnimation(0.2),
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        print('Errore anteprima background: ${BeverageAssets.getBeverageImage(_selectedImageIndex)}: $error');
                        return Icon(
                          LucideIcons.coffee,
                          color: Colors.white.withValues(alpha: 0.2),
                          size: 40,
                        );
                      },
                    ),
                  ),
                ),
                // Main image
                Center(
                  child: Image.asset(
                    BeverageAssets.getBeverageImage(_selectedImageIndex),
                    width: 48,
                    height: 48,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      print('Errore anteprima main: ${BeverageAssets.getBeverageImage(_selectedImageIndex)}: $error');
                      return const Icon(
                        LucideIcons.coffee,
                        color: Colors.white,
                        size: 32,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _nameController.text.isEmpty
                ? 'Nome bevanda'
                : _nameController.text,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.getBeverageColor(
                    _selectedColorIndex,
                  ).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${_volumeController.text.isEmpty ? '0' : _volumeController.text}ml',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.getBeverageColor(
                    _selectedColorIndex,
                  ).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${_caffeineController.text.isEmpty ? '0' : _caffeineController.text}mg',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nome della bevanda',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            hintText: 'es. Cappuccino della nonna',
            prefixIcon: Icon(LucideIcons.coffee),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Inserisci il nome della bevanda';
            }
            if (value.length < 2) {
              return 'Il nome deve avere almeno 2 caratteri';
            }
            return null;
          },
          onChanged: (_) => setState(() {}),
          textCapitalization: TextCapitalization.words,
        ),
      ],
    );
  }

  Widget _buildVolumeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Volume (ml)',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _volumeController,
          decoration: const InputDecoration(
            hintText: 'es. 250',
            prefixIcon: Icon(LucideIcons.glassWater),
            suffixText: 'ml',
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Inserisci il volume';
            }
            final volume = double.tryParse(value);
            if (volume == null || volume <= 0) {
              return 'Inserisci un volume valido';
            }
            if (volume > 2000) {
              return 'Il volume non può superare 2000ml';
            }
            return null;
          },
          onChanged: (_) => setState(() {}),
        ),
      ],
    );
  }

  Widget _buildCaffeineField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contenuto di caffeina (mg)',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _caffeineController,
          decoration: const InputDecoration(
            hintText: 'es. 75',
            prefixIcon: Icon(LucideIcons.zap),
            suffixText: 'mg',
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Inserisci il contenuto di caffeina';
            }
            final caffeine = double.tryParse(value);
            if (caffeine == null || caffeine < 0) {
              return 'Inserisci un valore valido';
            }
            if (caffeine > 500) {
              return 'Il contenuto di caffeina sembra troppo alto';
            }
            return null;
          },
          onChanged: (_) => setState(() {}),
        ),
      ],
    );
  }

  Widget _buildImageSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTileTitle(
          tittle: 'Scegli un\'icona',
          subtitle: 'Seleziona l\'icona che rappresenta la tua bevanda',
          leadingIcon: LucideIcons.image,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  4, // Aumentato da 4 a 6 per gestire meglio le 18 icone
              childAspectRatio: 1,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: BeverageAssets.allImages.length,
            itemBuilder: (context, index) {
              final isSelected = _selectedImageIndex == index;
              return GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() {
                    _selectedImageIndex = index;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.1)
                        : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey.withValues(alpha: 0.3),
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Image.asset(
                      BeverageAssets.getBeverageImage(index),
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        // Debug: stampa l'errore per capire quale immagine non carica
                        print('Errore caricamento immagine ${BeverageAssets.getBeverageImage(index)}: $error');
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              LucideIcons.coffee,
                              color: Theme.of(context).colorScheme.primary,
                              size: 20,
                            ),
                            Text(
                              'IMG\n${index + 1}',
                              style: TextStyle(fontSize: 8),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildColorSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTileTitle(
          tittle: 'Scegli un colore',
          subtitle: 'Seleziona il colore che rappresenta la tua bevanda',
          leadingIcon: LucideIcons.palette,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(24),
          ),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:
                  5, // Aumentato da 4 a 5 per gestire meglio i 14 colori
              childAspectRatio: 1,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: AppColors.beverageColors.length,
            itemBuilder: (context, index) {
              final color = AppColors.getBeverageColor(index);
              final isSelected = _selectedColorIndex == index;

              return GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() {
                    _selectedColorIndex = index;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isSelected ? Colors.white : Colors.transparent,
                      width: 2,
                    ),
                    boxShadow: isSelected
                        ? CustomBoxShadow.iconBoxShadows
                        : null,
                  ),
                  child: isSelected
                      ? const Icon(
                          LucideIcons.check,
                          color: Colors.white,
                          size: 24,
                        )
                      : null,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        CustomStandardButton(
          text: _isLoading
              ? 'Creazione in corso...'
              : 'Crea e Aggiungi Assunzione',
          icon: _isLoading ? null : LucideIcons.plus,
          onPressed: _isLoading ? null : _createAndAddIntake,
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton.icon(
            onPressed: _isLoading ? null : _createBeverageOnly,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Theme.of(context).colorScheme.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            icon: Icon(
              LucideIcons.save,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            label: Text(
              'Salva solo bevanda',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _createAndAddIntake() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final beverage = _createBeverage();

      // Add beverage to provider
      final beverageProvider = Provider.of<BeverageProvider>(
        context,
        listen: false,
      );
      await beverageProvider.addBeverage(beverage);

      // Create and add intake
      final intake = Intake(
        id: 'intake_${DateTime.now().millisecondsSinceEpoch}',
        beverage: beverage,
        timestamp: DateTime.now(),
      );

      final intakeProvider = Provider.of<IntakeProvider>(
        context,
        listen: false,
      );
      await intakeProvider.addIntake(intake);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bevanda creata e assunzione aggiunta!'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _createBeverageOnly() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final beverage = _createBeverage();

      // Add beverage to provider
      final beverageProvider = Provider.of<BeverageProvider>(
        context,
        listen: false,
      );
      await beverageProvider.addBeverage(beverage);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bevanda salvata con successo!'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Beverage _createBeverage() {
    return Beverage(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      name: _nameController.text.trim(),
      volume: double.parse(_volumeController.text),
      caffeineAmount: double.parse(_caffeineController.text),
      colorIndex: _selectedColorIndex,
      imageIndex: _selectedImageIndex,
    );
  }
}
