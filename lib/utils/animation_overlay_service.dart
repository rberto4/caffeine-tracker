import 'package:flutter/material.dart';
import '../presentation/widgets/drink_to_gauge_animation.dart';

/// Service per gestire le animazioni overlay nell'app
class AnimationOverlayService {
  static OverlayEntry? _currentOverlay;

  /// Avvia l'animazione del drink che vola verso il gauge
  static void startDrinkToGaugeAnimation({
    required BuildContext context,
    required String productName,
    required double caffeineAmount,
    required GlobalKey buttonKey,
    required GlobalKey gaugeKey,
    required VoidCallback onComplete,
  }) {
    // Rimuovi overlay esistenti
    removeCurrentOverlay();

    // Calcola le posizioni di partenza e arrivo
    final buttonBox = buttonKey.currentContext?.findRenderObject() as RenderBox?;
    final gaugeBox = gaugeKey.currentContext?.findRenderObject() as RenderBox?;

    if (buttonBox == null || gaugeBox == null) {
      onComplete();
      return;
    }

    final buttonPosition = buttonBox.localToGlobal(Offset.zero);
    final buttonCenter = Offset(
      buttonPosition.dx + buttonBox.size.width / 2,
      buttonPosition.dy + buttonBox.size.height / 2,
    );

    final gaugePosition = gaugeBox.localToGlobal(Offset.zero);
    final gaugeCenter = Offset(
      gaugePosition.dx + gaugeBox.size.width / 2,
      gaugePosition.dy + gaugeBox.size.height / 2,
    );

    // Determina il colore del drink
    final drinkColor = _getDrinkColor(productName);

    // Crea l'overlay
    _currentOverlay = OverlayEntry(
      builder: (context) => Material(
        color: Colors.transparent,
        child: DrinkToGaugeAnimation(
          productName: productName,
          caffeineAmount: caffeineAmount,
          startPosition: buttonCenter,
          endPosition: gaugeCenter,
          drinkColor: drinkColor,
          onComplete: () {
            removeCurrentOverlay();
            onComplete();
          },
        ),
      ),
    );

    // Inserisci l'overlay
    Overlay.of(context).insert(_currentOverlay!);
  }

  /// Rimuove l'overlay corrente se esiste
  static void removeCurrentOverlay() {
    _currentOverlay?.remove();
    _currentOverlay = null;
  }

  /// Determina il colore del drink basato sul tipo
  static Color _getDrinkColor(String productName) {
    // Usa un colore arancione standard per tutte le bevande
    return const Color(0xFFFF8A65); // Arancione caffè
  }
}

/// Widget helper per ottenere chiavi globali facilmente
class AnimationTargetProvider extends StatefulWidget {
  final Widget child;
  final GlobalKey? targetKey;

  const AnimationTargetProvider({
    super.key,
    required this.child,
    this.targetKey,
  });

  @override
  State<AnimationTargetProvider> createState() => _AnimationTargetProviderState();
}

class _AnimationTargetProviderState extends State<AnimationTargetProvider> {
  late final GlobalKey _key;

  @override
  void initState() {
    super.initState();
    _key = widget.targetKey ?? GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _key,
      child: widget.child,
    );
  }

  GlobalKey get key => _key;
}
