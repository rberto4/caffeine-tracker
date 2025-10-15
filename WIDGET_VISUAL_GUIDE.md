# 📱 Visual Guide - Widget Android

## 🎨 Widget Overview

```
╔═══════════════════════════════════════════════════════════════╗
║                CAFFEINE TRACKER - WIDGET ANDROID              ║
╚═══════════════════════════════════════════════════════════════╝

┌─────────────────────────────────────────────────────────────┐
│  WIDGET 1: Caffeine Gauge (2x2) - ORIGINALE                │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│    ╔════════════╗                                           │
│    ║ Buongiorno ║                                           │
│    ║            ║                                           │
│    ║    ⚪      ║  ← Gauge circolare                       │
│    ║   ╱ ║ ╲    ║                                           │
│    ║  ║  ○  ║   ║                                           │
│    ║   ╲ ║ ╱    ║                                           │
│    ║            ║                                           │
│    ║  150mg     ║  ← Caffeina corrente                     │
│    ║  / 400mg   ║  ← Limite giornaliero                    │
│    ║            ║                                           │
│    ║ 3 assunz.  ║  ← Conteggio intake                      │
│    ╚════════════╝                                           │
│                                                              │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  WIDGET 2: Quick Add (4x1) - ORIGINALE                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌─────┐ ┌─────┐ ┌─────┐ ┌─────┐                          │
│  │ ☕  │ │ 🍵  │ │ ⚡  │ │ 🥤  │                          │
│  │Caffè│ │ Tè  │ │Energ│ │Cola │                          │
│  │95mg │ │40mg │ │80mg │ │34mg │                          │
│  └─────┘ └─────┘ └─────┘ └─────┘                          │
│                                                              │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  WIDGET 3: Single Beverage (2x2) - ⭐ NUOVO!                │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│    ╔═══════════════╗                                        │
│    ║               ║  ← Background con colore bevanda       │
│    ║     ☕        ║  ← Icona grande                        │
│    ║               ║                                         │
│    ║ Caffè         ║  ← Nome bevanda                        │
│    ║ Espresso      ║                                         │
│    ║               ║                                         │
│    ║  [95mg]       ║  ← Caffeina (pill style)               │
│    ║  250ml        ║  ← Volume                              │
│    ║               ║                                         │
│    ║ ╔═══════════╗ ║                                        │
│    ║ ║ + Tocca   ║ ║  ← Pulsante azione                    │
│    ║ ║   x agg.  ║ ║                                        │
│    ║ ╚═══════════╝ ║                                        │
│    ╚═══════════════╝                                        │
│                                                              │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│  WIDGET 4: Quick Add Grid (4x2) - ⭐ NUOVO!                 │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│    ╔═══════════════════════════════════════╗                │
│    ║        Quick Add                      ║  ← Header      │
│    ╠═══════════════╦═══════════════════════╣                │
│    ║               ║                       ║                │
│    ║     ☕        ║        🍵            ║                │
│    ║               ║                       ║                │
│    ║  Caffè        ║      Tè Verde        ║                │
│    ║               ║                       ║                │
│    ║  [95mg]       ║      [40mg]          ║                │
│    ║               ║                       ║                │
│    ╠═══════════════╬═══════════════════════╣                │
│    ║               ║                       ║                │
│    ║     ⚡        ║        🥤            ║                │
│    ║               ║                       ║                │
│    ║  Energy       ║      Cola            ║                │
│    ║               ║                       ║                │
│    ║  [80mg]       ║      [34mg]          ║                │
│    ║               ║                       ║                │
│    ╚═══════════════╩═══════════════════════╝                │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## 🎯 Layout Comparisons

### Layout Orizzontale (4x1 originale)
```
┌────┬────┬────┬────┐
│ ☕ │ 🍵 │ ⚡ │ 🥤 │  Pro: Compatto verticalmente
│ 95 │ 40 │ 80 │ 34 │  Contro: Poco spazio per info
└────┴────┴────┴────┘
```

### Layout Griglia 2x2 (4x2 nuovo)
```
┌──────┬──────┐
│  ☕  │  🍵  │  Pro: Più spazio per ogni bevanda
│ Caffè│  Tè  │  Pro: Design più equilibrato
│ 95mg │ 40mg │  Pro: Più informazioni visibili
├──────┼──────┤
│  ⚡  │  🥤  │
│Energy│ Cola │
│ 80mg │ 34mg │
└──────┴──────┘
```

### Single Widget (2x2 nuovo)
```
┌───────────┐
│    ☕     │  Pro: Focus su una bevanda
│           │  Pro: Tap area grande
│  Caffè    │  Pro: Tutte le info visibili
│  Espresso │  Ideale: Bevanda preferita
│           │
│  [95mg]   │
│  250ml    │
│           │
│[+ Tocca ] │
└───────────┘
```

---

## 🎨 Color Scheme Examples

### Widget con Caffè (Arancione)
```
╔════════════╗
║ Background ║ ← #FF6B35 (Arancione caldo)
║   #FF6B35  ║
║            ║
║  ☕ Caffè  ║ ← Testo bianco
║            ║
║   95mg     ║ ← Pill semi-trasparente bianco
╚════════════╝
```

### Widget con Tè (Verde)
```
╔════════════╗
║ Background ║ ← #4CAF50 (Verde naturale)
║   #4CAF50  ║
║            ║
║  🍵 Tè     ║ ← Testo bianco
║            ║
║   40mg     ║ ← Pill semi-trasparente bianco
╚════════════╝
```

### Widget con Energy Drink (Blu)
```
╔════════════╗
║ Background ║ ← #2196F3 (Blu elettrico)
║   #2196F3  ║
║            ║
║  ⚡ Energy ║ ← Testo bianco
║            ║
║   80mg     ║ ← Pill semi-trasparente bianco
╚════════════╝
```

---

## 📱 Home Screen Layouts

### Setup 1: Focus sul Monitoring
```
╔═══════════════════════════════════╗
║          HOME SCREEN              ║
╠═══════════════════════════════════╣
║                                   ║
║  ┌──────────────────────────┐    ║
║  │  Caffeine Gauge (2x2)    │    ║
║  │                          │    ║
║  │     ⚪ 150mg/400mg       │    ║
║  │                          │    ║
║  └──────────────────────────┘    ║
║                                   ║
║  ┌──────────────────────────┐    ║
║  │  Quick Add Grid (4x2)    │    ║
║  │  ┌─────────┬─────────┐   │    ║
║  │  │   ☕    │   🍵    │   │    ║
║  │  ├─────────┼─────────┤   │    ║
║  │  │   ⚡    │   🥤    │   │    ║
║  │  └─────────┴─────────┘   │    ║
║  └──────────────────────────┘    ║
║                                   ║
╚═══════════════════════════════════╝
```

### Setup 2: Focus sul Quick Add
```
╔═══════════════════════════════════╗
║          HOME SCREEN              ║
╠═══════════════════════════════════╣
║                                   ║
║  ┌──────────────────────────┐    ║
║  │  Quick Add Grid (4x2)    │    ║
║  │  ┌─────────┬─────────┐   │    ║
║  │  │   ☕    │   🍵    │   │    ║
║  │  ├─────────┼─────────┤   │    ║
║  │  │   ⚡    │   🥤    │   │    ║
║  │  └─────────┴─────────┘   │    ║
║  └──────────────────────────┘    ║
║                                   ║
║  ┌────────────┐  ┌────────────┐  ║
║  │  Gauge     │  │  [Clock]   │  ║
║  │  (2x2)     │  │  (2x2)     │  ║
║  └────────────┘  └────────────┘  ║
║                                   ║
╚═══════════════════════════════════╝
```

### Setup 3: Minimalista con Single Widgets
```
╔═══════════════════════════════════╗
║          HOME SCREEN              ║
╠═══════════════════════════════════╣
║                                   ║
║  ┌────────────┐  ┌────────────┐  ║
║  │  Single    │  │  Single    │  ║
║  │  Caffè     │  │  Tè        │  ║
║  │  (2x2)     │  │  (2x2)     │  ║
║  │            │  │            │  ║
║  │   ☕       │  │   🍵       │  ║
║  │  95mg      │  │  40mg      │  ║
║  └────────────┘  └────────────┘  ║
║                                   ║
║  ┌────────────┐  ┌────────────┐  ║
║  │  Gauge     │  │  Calendar  │  ║
║  │  (2x2)     │  │  (2x2)     │  ║
║  └────────────┘  └────────────┘  ║
║                                   ║
╚═══════════════════════════════════╝
```

### Setup 4: Massima Accessibilità
```
╔═══════════════════════════════════╗
║          HOME SCREEN              ║
╠═══════════════════════════════════╣
║                                   ║
║  ┌────────────┐  ┌────────────┐  ║
║  │  Single    │  │  Single    │  ║
║  │  Caffè     │  │  Tè        │  ║
║  │  (2x2)     │  │  (2x2)     │  ║
║  └────────────┘  └────────────┘  ║
║                                   ║
║  ┌────────────┐  ┌────────────┐  ║
║  │  Single    │  │  Single    │  ║
║  │  Energy    │  │  Cola      │  ║
║  │  (2x2)     │  │  (2x2)     │  ║
║  └────────────┘  └────────────┘  ║
║                                   ║
║  ┌──────────────────────────┐    ║
║  │  Gauge (2x2)             │    ║
║  └──────────────────────────┘    ║
║                                   ║
╚═══════════════════════════════════╝
```

---

## 🎯 Interactive Elements

### Tap Areas - Single Widget
```
┌───────────────┐
│ ╔═══════════╗ │
│ ║  Entire   ║ │ ← TAPPABLE: Tutto il widget
│ ║  Widget   ║ │   Action: Aggiungi assunzione
│ ║  Area     ║ │
│ ║           ║ │
│ ║           ║ │
│ ║           ║ │
│ ║           ║ │
│ ╚═══════════╝ │
└───────────────┘
```

### Tap Areas - Grid Widget
```
┌──────────────────┐
│ ┌──────┬──────┐  │
│ │ TAP  │ TAP  │  │ ← TAPPABLE: Ogni card individuale
│ │  1   │  2   │  │   Action: Aggiungi bevanda specifica
│ ├──────┼──────┤  │
│ │ TAP  │ TAP  │  │
│ │  3   │  4   │  │
│ └──────┴──────┘  │
└──────────────────┘
```

---

## 📊 Size Comparison

```
Caffeine Gauge    Quick Add (4x1)    Single Widget      Grid Widget
    (2x2)                               (2x2)             (4x2)

┌─────────┐      ┌───┬───┬───┬───┐   ┌─────────┐     ┌───────────┐
│         │      │ ☕│ 🍵│ ⚡│ 🥤│   │   ☕    │     │  ☕  │ 🍵 │
│    ⚪   │      └───┴───┴───┴───┘   │  Caffè  │     │ ─────┼──── │
│         │                           │  95mg   │     │  ⚡  │ 🥤 │
└─────────┘                           └─────────┘     └───────────┘

  110x110dp         250x55dp          110x110dp        250x110dp
   (2x2)             (4x1)              (2x2)            (4x2)
```

---

## 🎨 Widget States

### Normal State
```
╔═══════════╗
║  ☕       ║  ← Colore pieno della bevanda
║  Caffè    ║  ← Testo bianco leggibile
║  [95mg]   ║  ← Pill con background semi-trasparente
╚═══════════╝
```

### Pressed State (Android ripple effect)
```
╔═══════════╗
║  ☕       ║  ← Ripple overlay bianco semi-trasparente
║  Caffè    ║     animato al centro dell'area tap
║  [95mg]   ║
╚═══════════╝
```

### Updating State
```
╔═══════════╗
║  ☕       ║  ← Widget rimane responsive
║  Caffè    ║     Dati si aggiornano in background
║  [95mg]→  ║  ← Nuovo valore appare
╚═══════════╝     (no loading spinner necessario)
```

---

## 💡 Design Philosophy

### Principi di Design Applicati:

1. **Colore come Identità**
   - Ogni bevanda ha il suo colore distintivo
   - Riconoscimento immediato visivo
   - Coerenza con l'app principale

2. **Gerarchia Informazioni**
   ```
   Priorità 1: Icona + Nome
   Priorità 2: Caffeina (mg)
   Priorità 3: Volume (ml) - Solo Single Widget
   Priorità 4: Call-to-Action
   ```

3. **Accessibilità**
   - Testo bianco su sfondi colorati (contrasto > 4.5:1)
   - Tap area > 48dp x 48dp
   - Font size ≥ 10sp (leggibile anche da lontano)

4. **Performance**
   - Zero animazioni pesanti
   - Update istantaneo
   - Memoria footprint minimale

---

**Created:** 5 Ottobre 2025  
**Version:** 1.0.0  
**Design by:** GitHub Copilot + Flutter Material Design 3
