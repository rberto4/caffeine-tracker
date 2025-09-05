# Guida ai Nuovi Modelli

Questo documento spiega come utilizzare i nuovi modelli `Beverage` e `Intake` che sostituiscono il precedente modello `CaffeineIntake`.

## Modello Beverage

Il modello `Beverage` rappresenta una bevanda generica con le seguenti proprietà:

- `id`: Identificativo univoco
- `name`: Nome della bevanda
- `volume`: Quantità di liquido in millilitri
- `caffeineAmount`: Quantità di caffeina in milligrammi
- `colorIndex`: Indice del colore dalla palette `AppColors.beverageColors`
- `imageIndex`: Indice dell'immagine dalla lista `BeverageAssets.allImages`

### Esempio di utilizzo:

```dart
// Creazione di una bevanda
final beverage = Beverage(
  id: 'bev_001',
  name: 'Espresso',
  volume: 30.0,
  caffeineAmount: 63.0,
  colorIndex: 4, // Rosso/Marrone per il caffè
  imageIndex: 0, // coffee-cup.png
);

// Creazione con suggerimenti automatici
final beverage2 = Beverage.withSuggestions(
  id: 'bev_002',
  name: 'Green Tea',
  volume: 240.0,
  caffeineAmount: 25.0,
  // colorIndex e imageIndex vengono suggeriti automaticamente
);

// Accesso alle proprietà
Color beverageColor = beverage.color;
String imagePath = beverage.imagePath;
```

## Modello Intake

Il modello `Intake` rappresenta un singolo consumo di una bevanda:

- `id`: Identificativo univoco
- `beverage`: Oggetto `Beverage` consumato
- `timestamp`: Data e ora del consumo

### Esempio di utilizzo:

```dart
// Creazione di un intake
final intake = Intake(
  id: 'int_001',
  beverage: beverage,
  timestamp: DateTime.now(),
);

// Metodi di formattazione
String time = intake.formattedTime; // "14:30"
String date = intake.formattedDate; // "04/09/2025"
String relativeTime = intake.relativeTime; // "2 ore fa"
String italianDate = intake.formattedDateItalian; // "Mercoledì, 4 Settembre 2025"

// Controlli di data
bool isToday = intake.isToday;
bool isFromYesterday = intake.isFromDate(DateTime.now().subtract(Duration(days: 1)));
```

## Modello UserProfile Aggiornato

Il modello `UserProfile` ora include le unità di misura per i liquidi:

### Nuovi Enum:

- `VolumeUnit`: ml, l, oz (once fluide)
- `CaffeineUnit`: mg, oz (once)

### Metodi di conversione:

```dart
final profile = UserProfile(
  weight: 70.0,
  age: 30,
  gender: Gender.male,
  volumeUnit: VolumeUnit.ml,
  caffeineUnit: CaffeineUnit.mg,
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);

// Conversioni di volume
double volumeInMl = profile.convertVolumeToMl(1.0); // Se unit è l, restituisce 1000
double displayVolume = profile.convertVolumeAmount(1000.0); // Se unit è l, restituisce 1.0

// Conversioni di caffeina
double caffeineInMg = profile.convertCaffeineToMg(1.0); // Se unit è oz, converte a mg
double displayCaffeine = profile.convertCaffeineAmount(63.0); // Converte da mg alla unit impostata
```

## Colori e Immagini

### Colori delle bevande:

I colori sono definiti in `AppColors.beverageColors`:
- Blu (0)
- Verde (1) 
- Arancione (2)
- Viola (3)
- Rosso (4)
- Teal (5)

### Immagini disponibili:

Le immagini sono gestite da `BeverageAssets`:
- coffee-cup.png
- coffee-cup-2.png
- coffee-cup-3.png
- coffee-cup-4.png
- coffee-mug.png
- tea-cup.png
- energy-drink.png
- energy-drink-2.png
- energy-drink-3.png
- soft-drink.png
- hot-cocoa.png
- drink.png

## Migrazione

Durante la migrazione dal vecchio modello `CaffeineIntake`, puoi convertire così:

```dart
// Vecchio modello
CaffeineIntake oldIntake = ...;

// Creazione della bevanda
final beverage = Beverage.withSuggestions(
  id: 'bev_${oldIntake.id}',
  name: oldIntake.productName,
  volume: oldIntake.quantity ?? 240.0, // Default se non specificato
  caffeineAmount: oldIntake.caffeineAmount,
);

// Creazione del nuovo intake
final newIntake = Intake(
  id: oldIntake.id,
  beverage: beverage,
  timestamp: oldIntake.timestamp,
);
```
