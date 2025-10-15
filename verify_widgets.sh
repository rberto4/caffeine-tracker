#!/bin/bash

# Script di verifica per i nuovi widget Android
# Verifica che tutti i file necessari siano stati creati correttamente

echo "🔍 Verifica Widget Android per Caffeine Tracker"
echo "================================================"
echo ""

# Colori per output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

SUCCESS=0
FAILED=0

# Funzione per verificare esistenza file
check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✓${NC} $1"
        ((SUCCESS++))
    else
        echo -e "${RED}✗${NC} $1 ${RED}(MANCANTE)${NC}"
        ((FAILED++))
    fi
}

echo "📱 Verifica Kotlin Providers:"
echo "----------------------------"
check_file "android/app/src/main/kotlin/com/example/caffeine_tracker/SingleBeverageWidgetProvider.kt"
check_file "android/app/src/main/kotlin/com/example/caffeine_tracker/QuickAddGridWidgetProvider.kt"
check_file "android/app/src/main/kotlin/com/example/caffeine_tracker/CaffeineGaugeWidgetProvider.kt"
check_file "android/app/src/main/kotlin/com/example/caffeine_tracker/QuickAddWidgetProvider.kt"
echo ""

echo "🎨 Verifica Layout XML:"
echo "----------------------"
check_file "android/app/src/main/res/layout/single_beverage_widget.xml"
check_file "android/app/src/main/res/layout/quick_add_grid_widget.xml"
check_file "android/app/src/main/res/layout/caffeine_gauge_widget.xml"
check_file "android/app/src/main/res/layout/quick_add_widget.xml"
echo ""

echo "📋 Verifica Widget Info XML:"
echo "---------------------------"
check_file "android/app/src/main/res/xml/single_beverage_widget_info.xml"
check_file "android/app/src/main/res/xml/quick_add_grid_widget_info.xml"
check_file "android/app/src/main/res/xml/caffeine_gauge_widget_info.xml"
check_file "android/app/src/main/res/xml/quick_add_widget_info.xml"
echo ""

echo "🎯 Verifica Risorse:"
echo "------------------"
check_file "android/app/src/main/res/drawable/ic_coffee_watermark.xml"
check_file "android/app/src/main/res/values/strings.xml"
check_file "android/app/src/main/res/values-it/strings.xml"
echo ""

echo "⚙️ Verifica File Flutter:"
echo "-----------------------"
check_file "lib/utils/home_widget_service.dart"
check_file "lib/domain/providers/beverage_provider.dart"
check_file "lib/domain/providers/intake_provider.dart"
echo ""

echo "📄 Verifica Manifest:"
echo "--------------------"
check_file "android/app/src/main/AndroidManifest.xml"
echo ""

echo "📚 Verifica Documentazione:"
echo "--------------------------"
check_file "ANDROID_WIDGETS_GUIDE.md"
check_file "NEW_WIDGETS_GUIDE.md"
echo ""

# Verifica contenuti specifici nei file
echo "🔎 Verifica contenuti AndroidManifest:"
echo "-------------------------------------"
if grep -q "SingleBeverageWidgetProvider" "android/app/src/main/AndroidManifest.xml"; then
    echo -e "${GREEN}✓${NC} SingleBeverageWidgetProvider registrato"
    ((SUCCESS++))
else
    echo -e "${RED}✗${NC} SingleBeverageWidgetProvider NON registrato"
    ((FAILED++))
fi

if grep -q "QuickAddGridWidgetProvider" "android/app/src/main/AndroidManifest.xml"; then
    echo -e "${GREEN}✓${NC} QuickAddGridWidgetProvider registrato"
    ((SUCCESS++))
else
    echo -e "${RED}✗${NC} QuickAddGridWidgetProvider NON registrato"
    ((FAILED++))
fi
echo ""

echo "🔎 Verifica stringhe localizzate:"
echo "--------------------------------"
if grep -q "single_beverage_widget_description" "android/app/src/main/res/values/strings.xml"; then
    echo -e "${GREEN}✓${NC} Descrizione Single Widget (EN)"
    ((SUCCESS++))
else
    echo -e "${RED}✗${NC} Descrizione Single Widget (EN) mancante"
    ((FAILED++))
fi

if grep -q "quick_add_grid_widget_description" "android/app/src/main/res/values/strings.xml"; then
    echo -e "${GREEN}✓${NC} Descrizione Grid Widget (EN)"
    ((SUCCESS++))
else
    echo -e "${RED}✗${NC} Descrizione Grid Widget (EN) mancante"
    ((FAILED++))
fi

if grep -q "single_beverage_widget_description" "android/app/src/main/res/values-it/strings.xml"; then
    echo -e "${GREEN}✓${NC} Descrizione Single Widget (IT)"
    ((SUCCESS++))
else
    echo -e "${RED}✗${NC} Descrizione Single Widget (IT) mancante"
    ((FAILED++))
fi

if grep -q "quick_add_grid_widget_description" "android/app/src/main/res/values-it/strings.xml"; then
    echo -e "${GREEN}✓${NC} Descrizione Grid Widget (IT)"
    ((SUCCESS++))
else
    echo -e "${RED}✗${NC} Descrizione Grid Widget (IT) mancante"
    ((FAILED++))
fi
echo ""

# Riepilogo finale
echo "================================================"
echo "📊 Riepilogo Verifica:"
echo "================================================"
echo -e "${GREEN}Successi: $SUCCESS${NC}"
echo -e "${RED}Errori: $FAILED${NC}"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}✅ Tutti i controlli sono passati!${NC}"
    echo ""
    echo "🚀 Prossimi passi:"
    echo "  1. flutter clean"
    echo "  2. flutter pub get"
    echo "  3. flutter run"
    echo "  4. Aggiungi i widget alla home screen Android"
    echo ""
    exit 0
else
    echo -e "${RED}❌ Alcuni file mancano o hanno problemi${NC}"
    echo ""
    echo "⚠️  Controlla i file marcati in rosso"
    echo ""
    exit 1
fi
