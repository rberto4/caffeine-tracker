import 'package:flutter/material.dart';
import '../presentation/widgets/drink_to_gauge_animation.dart';
import '../domain/models/beverage.dart';

/// Service per gestire le animazioni overlay nell'app
class AnimationOverlayService {
  static OverlayEntry? _currentOverlay;

  /// Avvia l'animazione del drink che vola verso il gauge
  static void startDrinkToGaugeAnimation({
    required BuildContext context,
    required Beverage beverage,
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

    // Crea l'overlay
    _currentOverlay = OverlayEntry(
      builder: (context) => Material(
        color: Colors.transparent,
        child: DrinkToGaugeAnimation(
          beverage: beverage,
          startPosition: buttonCenter,
          endPosition: gaugeCenter,
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
