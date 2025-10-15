# ✅ Checklist Test Widget

## 📋 Prima di Testare

- [ ] **Build pulita:**
  ```bash
  cd /Users/robmac/Developer/git/caffeine-tracker
  flutter clean
  flutter pub get
  ```

- [ ] **Verifica file:**
  ```bash
  ./verify_widgets.sh
  ```
  Dovrebbe mostrare: "✅ Tutti i controlli sono passati!"

---

## 📱 Test su Dispositivo Android

### Passo 1: Build & Deploy
- [ ] Connetti dispositivo Android (o avvia emulatore)
- [ ] Esegui: `flutter run`
- [ ] Attendi che l'app si installi e avvii

### Passo 2: Verifica App Funzionante
- [ ] L'app si apre senza crash
- [ ] Quick Add Grid nella home screen funziona
- [ ] Puoi aggiungere assunzioni normalmente
- [ ] Le bevande hanno colori corretti

### Passo 3: Test Single Beverage Widget (2x2)
- [ ] **Aggiungi widget:**
  - Premi a lungo sulla home screen
  - Tocca "Widget"
  - Cerca "Caffeine Tracker"
  - Trova "Single Beverage Widget"
  - Trascina sulla home screen

- [ ] **Verifica aspetto:**
  - [ ] Widget mostra nome bevanda corretto
  - [ ] Widget mostra caffeina (mg) corretta
  - [ ] Widget mostra volume (ml) corretto
  - [ ] Colore di sfondo corrisponde alla bevanda
  - [ ] Icona emoji visibile
  - [ ] Pulsante "Tocca per aggiungere" presente

- [ ] **Test funzionalità:**
  - [ ] Tap sul widget apre l'app
  - [ ] Assunzione viene aggiunta automaticamente
  - [ ] Notifica di conferma appare
  - [ ] Widget si aggiorna con nuovo valore

### Passo 4: Test Quick Add Grid Widget (4x2)
- [ ] **Aggiungi widget:**
  - Premi a lungo sulla home screen
  - Tocca "Widget"
  - Trova "Quick Add Grid Widget"
  - Trascina sulla home screen

- [ ] **Verifica aspetto:**
  - [ ] Layout griglia 2x2 visibile
  - [ ] Tutte e 4 le bevande mostrate
  - [ ] Nomi bevande corretti
  - [ ] Valori caffeina corretti
  - [ ] Colori personalizzati corretti
  - [ ] Icone emoji per ogni bevanda
  - [ ] Header "Quick Add" visibile

- [ ] **Test funzionalità:**
  - [ ] Tap su bevanda top-left funziona
  - [ ] Tap su bevanda top-right funziona
  - [ ] Tap su bevanda bottom-left funziona
  - [ ] Tap su bevanda bottom-right funziona
  - [ ] Ogni tap aggiunge l'assunzione corretta
  - [ ] Notifiche di conferma appaiono
  - [ ] Widget si aggiorna dopo ogni tap

### Passo 5: Test Widget Esistenti
- [ ] **Caffeine Gauge Widget (2x2):**
  - [ ] Si aggiorna con nuove assunzioni
  - [ ] Mostra progresso corretto
  - [ ] Colori cambiano in base al livello

- [ ] **Quick Add Widget (4x1) - Originale:**
  - [ ] Ancora funzionante
  - [ ] Mostra le 4 bevande in orizzontale
  - [ ] Tap aggiunge assunzioni

### Passo 6: Test Aggiornamenti
- [ ] **Modifica una bevanda nell'app:**
  - Vai in Home Screen
  - Long press su una bevanda nella Quick Add Grid
  - Modifica nome/colore/caffeina
  - Salva

- [ ] **Verifica aggiornamento widget:**
  - [ ] Torna alla home screen
  - [ ] Widget mostrano i nuovi dati
  - [ ] (Se non si aggiornano, riapri l'app)

### Passo 7: Test Layout Multipli
- [ ] **Aggiungi più widget contemporaneamente:**
  - [ ] 1x Caffeine Gauge Widget
  - [ ] 1x Quick Add Grid Widget
  - [ ] 2x Single Beverage Widget (stesso tipo)
  
- [ ] **Verifica:**
  - [ ] Tutti i widget si vedono correttamente
  - [ ] Nessun overlap o glitch visivo
  - [ ] Tutti i widget sono funzionanti

---

## 🐛 Test Edge Cases

### Test Bevande Vuote
- [ ] Cosa succede se non ci sono bevande predefinite?
- [ ] Widget mostra placeholder appropriato?

### Test Valori Estremi
- [ ] Widget con caffeina 0mg
- [ ] Widget con caffeina 500mg
- [ ] Widget con nome molto lungo
- [ ] Widget con nome molto corto

### Test Performance
- [ ] Tap widget è reattivo (< 1 secondo)?
- [ ] App non crasha quando tocchi widget?
- [ ] Widget non causano lag nella home screen?

---

## 📊 Checklist Visiva

### Single Beverage Widget
```
┌─────────────────┐
│ ☕              │  ← Emoji icona
│                 │
│ Caffè Espresso  │  ← Nome (max 2 righe)
│                 │
│ [95mg]          │  ← Caffeina (pill)
│ 250ml           │  ← Volume
│                 │
│ [+ Tocca x agg] │  ← Pulsante
└─────────────────┘
```

### Quick Add Grid Widget
```
┌───────────────────┐
│   Quick Add       │  ← Header
├─────────┬─────────┤
│  ☕     │   🍵    │  ← Emoji icons
│ Caffè   │  Tè     │  ← Nomi
│ [95mg]  │ [40mg]  │  ← Caffeina
├─────────┼─────────┤
│  ⚡     │   🥤    │
│ Energy  │  Cola   │
│ [80mg]  │ [34mg]  │
└─────────┴─────────┘
```

---

## ✅ Criteri di Successo

Il test è SUPERATO se:
1. ✅ Tutti e 4 i widget sono visibili nella lista widget
2. ✅ Single Beverage Widget si può aggiungere e funziona
3. ✅ Quick Add Grid Widget si può aggiungere e funziona
4. ✅ Tap su ogni widget aggiunge correttamente l'assunzione
5. ✅ Widget si aggiornano quando si aggiunge intake nell'app
6. ✅ Nessun crash o errore durante l'uso
7. ✅ Design è pulito e leggibile
8. ✅ Colori corrispondono alle bevande configurate

---

## 🐛 Problemi Comuni e Soluzioni

### Widget non appare nella lista
**Soluzione:**
```bash
flutter clean
cd android && ./gradlew clean
cd ..
flutter run
```

### Widget mostra dati vecchi
**Soluzione:**
1. Apri l'app Caffeine Tracker
2. Naviga nella home screen
3. Widget dovrebbero aggiornarsi

### Widget non risponde al tap
**Soluzione:**
1. Rimuovi widget dalla home
2. Forza stop dell'app
3. Riapri l'app
4. Aggiungi nuovamente il widget

### Colori non corretti
**Soluzione:**
Verifica che `beverage.color.value.toString()` sia salvato correttamente in SharedPreferences.

---

## 📝 Note per il Testing

- **Dispositivo consigliato:** Android 12 o superiore
- **Emulatore:** Qualsiasi emulatore Android (Pixel 5+)
- **Tempo test:** ~15-20 minuti per test completo
- **Build time:** ~2-3 minuti prima test

---

## 📸 Screenshot da Fare (Opzionale)

Per documentazione:
- [ ] Screenshot widget lista (tutti e 4 i widget)
- [ ] Screenshot home screen con Single Widget
- [ ] Screenshot home screen con Grid Widget
- [ ] Screenshot setup completo (tutti i widget insieme)
- [ ] Screenshot dopo tap (notifica conferma)

---

## 🎯 Prossimi Passi Dopo Test

Se tutto funziona:
- [ ] Commit delle modifiche
- [ ] Update README con info widget
- [ ] Considera di implementare configurazione widget
- [ ] Pianifica supporto iOS widget

Se ci sono problemi:
- [ ] Documenta il problema
- [ ] Controlla i log Android: `flutter logs`
- [ ] Verifica AndroidManifest.xml
- [ ] Controlla sintassi Kotlin

---

**Buon Testing! 🚀**

**Data:** 5 Ottobre 2025  
**Versione:** 1.0.0  
**Widget:** 4 totali (2 nuovi)
