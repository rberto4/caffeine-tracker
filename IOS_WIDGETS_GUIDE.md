# 🍎 Guida Completa Widget iOS

## 📱 Widget iOS vs Android - Condivisione Dati

### ✅ Come Funziona la Condivisione

```
┌─────────────────────────────────────────────────┐
│           FLUTTER APP (Dart)                    │
│                                                 │
│  ┌──────────────────────────────────────────┐  │
│  │   HomeWidgetService.updateWidget()       │  │
│  │                                          │  │
│  │   • Salva dati in SharedPreferences      │  │
│  │     (Android) + App Groups (iOS)         │  │
│  └──────────────┬───────────────────────────┘  │
└─────────────────┼───────────────────────────────┘
                  │
         ┌────────┴────────┐
         │                 │
         ▼                 ▼
┌─────────────────┐  ┌─────────────────┐
│  ANDROID        │  │  iOS            │
│  Widget         │  │  Widget         │
│  (Kotlin)       │  │  (Swift)        │
│                 │  │                 │
│  Legge:         │  │  Legge:         │
│  SharedPref     │  │  App Groups     │
└─────────────────┘  └─────────────────┘
```

### 🎯 Risposta alla Tua Domanda

**Q: I widget iOS e Android possono usare gli stessi dati?**  
**A: SÌ! ✅**

- **Una modifica** in Flutter si riflette su **entrambi** i sistemi
- I **dati sono condivisi** tramite il plugin `home_widget`
- I **file sono separati** (Kotlin per Android, Swift per iOS)
- Ma i **dati provengono dalla stessa fonte** (Flutter)

**Q: Devo modificare entrambi quando cambio qualcosa?**  
**A: Dipende!**

- **Modifica ai DATI** (es. nome bevanda, caffeina): ✅ Una volta in Flutter = aggiorna entrambi
- **Modifica al DESIGN** (es. colori, layout): ❌ Devi modificare separatamente iOS e Android

---

## 🍎 Widget iOS Implementati

### 1. 📱 Single Beverage Widget (Small)
**Dimensione iOS:** Small (158×158 pt)  
**Equivalente Android:** 2x2 Single Beverage Widget

**Caratteristiche:**
- Mostra una singola bevanda
- Design compatto per home screen
- Emoji icon grande
- Nome, caffeina e volume visibili

### 2. 🎨 Quick Add Grid Widget (Medium)
**Dimensione iOS:** Medium (360×158 pt)  
**Equivalente Android:** 4x2 Quick Add Grid Widget

**Caratteristiche:**
- Layout 2x2 con 4 bevande
- Design moderno con cards
- Ogni bevanda tappabile
- Colori personalizzati

### 3. ⚡ Caffeine Gauge Widget (Medium)
**Dimensione iOS:** Medium (360×158 pt)  
**Equivalente Android:** 2x2 Caffeine Gauge Widget

**Caratteristiche:**
- Gauge circolare con progresso
- Mostra caffeina corrente vs limite
- Conteggio assunzioni
- Colori dinamici

---

## 🔧 Setup Progetto Xcode

### Passo 1: Aprire Xcode

```bash
cd ios
open Runner.xcworkspace
```

⚠️ **IMPORTANTE:** Apri sempre `.xcworkspace`, NON `.xcodeproj`!

### Passo 2: Creare Widget Extension

1. In Xcode, vai su **File → New → Target**
2. Cerca e seleziona **Widget Extension**
3. Imposta:
   - **Product Name:** `CaffeineTrackerWidget`
   - **Team:** Il tuo team Apple Developer
   - **Language:** Swift
   - **Include Configuration Intent:** ❌ NO (per ora)
4. Clicca **Finish**
5. Quando chiede "Activate scheme?", clicca **Cancel**

### Passo 3: Configurare App Groups

#### 3.1 Per l'App Principale (Runner)

1. Seleziona target **Runner**
2. Vai su **Signing & Capabilities**
3. Clicca **+ Capability**
4. Aggiungi **App Groups**
5. Clicca **+** e aggiungi: `group.caffeine_tracker.widgets`

#### 3.2 Per il Widget (CaffeineTrackerWidget)

1. Seleziona target **CaffeineTrackerWidget**
2. Vai su **Signing & Capabilities**
3. Clicca **+ Capability**
4. Aggiungi **App Groups**
5. Clicca **+** e aggiungi: `group.caffeine_tracker.widgets` (STESSO gruppo!)

### Passo 4: Sostituire i File

1. **Elimina** i file generati automaticamente:
   - `CaffeineTrackerWidget.swift` (quello generato)
   - `CaffeineTrackerWidget.intentdefinition` (se presente)

2. **Copia** i nostri file:
   - Trascina `CaffeineTrackerWidget.swift` nel progetto
   - Trascina `CaffeineTrackerProvider.swift` nel progetto
   - Sovrascrivi `Info.plist` nel widget extension

### Passo 5: Aggiornare Info.plist dell'App

Aggiungi in `ios/Runner/Info.plist`:

```xml
<key>AppGroupContainerIdentifier</key>
<string>group.caffeine_tracker.widgets</string>
```

### Passo 6: Build & Run

```bash
# Torna alla root del progetto
cd ..

# Pulisci e rebuilda
flutter clean
flutter pub get
cd ios
pod install
cd ..

# Run
flutter run
```

---

## 📊 Differenze Tecniche iOS vs Android

### Dimensioni Widget

| iOS | Android | Nome |
|-----|---------|------|
| Small (158×158) | 2×2 (110dp) | Single Beverage |
| Medium (360×158) | 4×2 (250dp) | Quick Add Grid |
| Large (360×379) | 4×4 | Non implementato |

### Linguaggio & Framework

```
┌────────────────────────────────────────┐
│              ANDROID                   │
├────────────────────────────────────────┤
│ Linguaggio: Kotlin                     │
│ Framework:  AppWidgetProvider          │
│ Layout:     XML                        │
│ Data:       SharedPreferences          │
│ Update:     RemoteViews.setXXX()       │
└────────────────────────────────────────┘

┌────────────────────────────────────────┐
│               iOS                      │
├────────────────────────────────────────┤
│ Linguaggio: Swift                      │
│ Framework:  WidgetKit                  │
│ Layout:     SwiftUI                    │
│ Data:       UserDefaults (App Groups)  │
│ Update:     Timeline Provider          │
└────────────────────────────────────────┘
```

### Flusso di Aggiornamento

**Android:**
```kotlin
HomeWidget.saveWidgetData("beverage_0_name", "Caffè")
HomeWidget.updateWidget()
→ QuickAddWidgetProvider.onUpdate()
→ RemoteViews aggiornata
```

**iOS:**
```swift
HomeWidget.saveWidgetData("beverage_0_name", "Caffè")
HomeWidget.updateWidget()
→ WidgetCenter.reloadTimelines()
→ TimelineProvider.getTimeline()
→ SwiftUI View aggiornata
```

---

## 🔄 Condivisione Dati - Esempio Pratico

### In Flutter (home_widget_service.dart)

```dart
static Future<void> updateQuickAddWidget({
  required List<Beverage> defaultBeverages,
}) async {
  for (int i = 0; i < 4; i++) {
    final beverage = defaultBeverages[i];
    
    // Salva per ANDROID (SharedPreferences)
    await HomeWidget.saveWidgetData<String>(
      'beverage_${i}_name', 
      beverage.name
    );
    
    // Salva per iOS (App Groups UserDefaults)
    // STESSO metodo, STESSO dato!
    // Il plugin gestisce automaticamente entrambi i sistemi
  }
  
  // Aggiorna ENTRAMBI
  await HomeWidget.updateWidget(
    androidName: 'QuickAddWidgetProvider',
    iOSName: 'CaffeineTrackerWidget',
  );
}
```

### In Android (Kotlin)

```kotlin
val widgetData = HomeWidgetPlugin.getData(context)
val name = widgetData.getString("beverage_0_name", "")
// Legge da SharedPreferences
```

### In iOS (Swift)

```swift
let sharedDefaults = UserDefaults(suiteName: "group.caffeine_tracker.widgets")
let name = sharedDefaults?.string(forKey: "beverage_0_name")
// Legge da App Groups
```

**Risultato:** ✅ Stesso dato, letto in modi diversi!

---

## 🎨 Design Considerations

### iOS Widget Guidelines

1. **No Interactive Elements:** Widget iOS non sono interattivi come Android
2. **Tap = Open App:** Tutto il widget apre l'app (no tap individuali)
3. **Timeline Updates:** iOS aggiorna via timeline, non on-demand
4. **Dynamic Type:** Rispetta le dimensioni font dell'utente
5. **Dark Mode:** Supporto automatico via SwiftUI

### Differenze di Interazione

**Android:**
```
Single Beverage Widget → Tap → Aggiungi intake
Quick Add Grid → Tap su card → Aggiungi quella bevanda
```

**iOS:**
```
Single Beverage Widget → Tap → Apri app → (utente sceglie)
Quick Add Grid → Tap ovunque → Apri app → (utente sceglie)
```

**Nota:** iOS non supporta tap parziali sui widget. Tutto il widget è un unico pulsante.

---

## 🚀 Testing iOS Widgets

### Simulator

```bash
flutter run
# Widget appariranno nella Widget Gallery
# Long press sulla home screen → Widget → Caffeine Tracker
```

### Device Fisico

1. Build su device: `flutter run --release`
2. Long press sulla home screen
3. Tap sul pulsante **+** in alto a sinistra
4. Cerca "Caffeine Tracker"
5. Trascina il widget desiderato

### Debug Widget

```bash
# Xcode console
# Seleziona scheme: CaffeineTrackerWidget
# Run
# Scegli "Today View" o widget preview
```

---

## 📝 File Structure iOS

```
ios/
├── Runner/                          # App principale
│   ├── AppDelegate.swift
│   ├── Info.plist                  # ← Aggiungi AppGroup
│   └── ...
│
├── CaffeineTrackerWidget/          # Widget Extension
│   ├── CaffeineTrackerWidget.swift # ← Widget views
│   ├── CaffeineTrackerProvider.swift # ← Data provider
│   ├── Info.plist                  # ← Widget configuration
│   └── Assets.xcassets/            # ← Widget icons
│
└── Runner.xcworkspace/             # ← APRI QUESTO
```

---

## 🐛 Troubleshooting iOS

### Widget non appare nella galleria

**Soluzione:**
```bash
flutter clean
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
flutter run
```

### Widget mostra "Unable to Load"

**Problema:** App Groups non configurato correttamente

**Soluzione:**
1. Verifica che Runner e Widget abbiano STESSO App Group
2. Verifica che `group.caffeine_tracker.widgets` sia nel codice

### Widget non si aggiorna

**Problema:** Timeline non viene ricaricato

**Soluzione:**
```swift
// In Flutter, dopo update:
await HomeWidget.updateWidget(
  iOSName: 'CaffeineTrackerWidget'
);
```

### Build failed - Signing

**Problema:** Certificato sviluppatore

**Soluzione:**
1. Xcode → Signing & Capabilities
2. Team → Seleziona il tuo team
3. Per entrambi: Runner e CaffeineTrackerWidget

---

## 📊 Comparison Matrix

| Feature | Android | iOS | Condiviso? |
|---------|---------|-----|------------|
| **Linguaggio** | Kotlin | Swift | ❌ |
| **Framework** | AppWidgetProvider | WidgetKit | ❌ |
| **Layout** | XML | SwiftUI | ❌ |
| **Dati** | SharedPreferences | App Groups | ✅ |
| **Update Logic** | Flutter | Flutter | ✅ |
| **Tap Individuali** | ✅ Sì | ❌ No | - |
| **Dark Mode** | Manual | Automatic | - |
| **Dimensioni** | Celle (2x2) | Small/Medium | - |

---

## 🎯 Workflow Completo

### Scenario: Aggiungi una nuova bevanda

1. **Utente modifica nell'app** (Flutter)
   ```dart
   beverageProvider.addBeverage(newBeverage);
   ```

2. **BeverageProvider aggiorna widget** (Flutter)
   ```dart
   await HomeWidgetService.updateQuickAddWidget(
     defaultBeverages: [...beverages]
   );
   ```

3. **Plugin salva dati** (home_widget)
   - Android: SharedPreferences
   - iOS: App Groups UserDefaults

4. **Widget si aggiornano** (automatico)
   - Android: RemoteViews.update()
   - iOS: WidgetCenter.reloadTimelines()

5. **Utente vede cambiamenti** (entrambi i sistemi)
   - ✅ Stessi dati
   - ✅ Design diverso ma coerente

---

## 📚 Risorse

### Documentazione Apple
- [WidgetKit](https://developer.apple.com/documentation/widgetkit)
- [App Groups](https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_security_application-groups)
- [SwiftUI](https://developer.apple.com/xcode/swiftui/)

### Plugin Flutter
- [home_widget](https://pub.dev/packages/home_widget)

---

## ✅ Checklist Setup iOS

- [ ] Xcode workspace aperto
- [ ] Widget Extension creata
- [ ] App Groups configurato (Runner)
- [ ] App Groups configurato (Widget)
- [ ] File Swift copiati nel progetto
- [ ] Info.plist aggiornato
- [ ] Build successful
- [ ] Widget appare nella galleria
- [ ] Widget mostra dati corretti
- [ ] Tap widget apre l'app

---

**Conclusione:** iOS e Android **condividono i dati** ma usano **codice separato** per il rendering! 🎉

Una modifica ai dati in Flutter si riflette automaticamente su entrambi i sistemi, ma il design e l'interazione sono gestiti separatamente in Kotlin (Android) e Swift (iOS).
