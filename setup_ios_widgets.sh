#!/bin/bash

# Script per configurare i widget iOS
# Esegui questo script dopo aver creato la Widget Extension in Xcode

echo "🍎 Setup Widget iOS per Caffeine Tracker"
echo "=========================================="
echo ""

# Colori
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}⚠️  PREREQUISITI:${NC}"
echo "   1. Xcode installato"
echo "   2. Widget Extension creata in Xcode"
echo "   3. App Groups configurato"
echo ""

read -p "Hai completato i prerequisiti? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo -e "${RED}❌ Completa prima i prerequisiti!${NC}"
    echo ""
    echo "Segui la guida: IOS_WIDGETS_GUIDE.md"
    exit 1
fi

echo ""
echo "🔍 Verificando struttura iOS..."
echo ""

# Controlla che la directory ios esista
if [ ! -d "ios" ]; then
    echo -e "${RED}❌ Directory ios/ non trovata!${NC}"
    echo "Assicurati di essere nella root del progetto Flutter"
    exit 1
fi

echo -e "${GREEN}✓${NC} Directory ios/ trovata"

# Controlla che i file Swift esistano
if [ ! -f "ios/CaffeineTrackerWidget/CaffeineTrackerWidget.swift" ]; then
    echo -e "${RED}❌ File CaffeineTrackerWidget.swift non trovato!${NC}"
    echo "I file Swift dovrebbero essere in ios/CaffeineTrackerWidget/"
    exit 1
fi

echo -e "${GREEN}✓${NC} File Swift widget trovati"

# Controlla che Info.plist esista
if [ ! -f "ios/CaffeineTrackerWidget/Info.plist" ]; then
    echo -e "${RED}❌ Info.plist widget non trovato!${NC}"
    exit 1
fi

echo -e "${GREEN}✓${NC} Info.plist widget trovato"

echo ""
echo "📝 Prossimi passi manuali in Xcode:"
echo ""
echo "1. ${YELLOW}Apri Xcode:${NC}"
echo "   cd ios && open Runner.xcworkspace"
echo ""
echo "2. ${YELLOW}Seleziona target Runner${NC}"
echo "   → Signing & Capabilities"
echo "   → + Capability → App Groups"
echo "   → + Aggiungi: group.caffeine_tracker.widgets"
echo ""
echo "3. ${YELLOW}Seleziona target CaffeineTrackerWidget${NC}"
echo "   → Signing & Capabilities"
echo "   → + Capability → App Groups"
echo "   → + Aggiungi: group.caffeine_tracker.widgets"
echo ""
echo "4. ${YELLOW}Build & Run${NC}"
echo "   → Seleziona scheme Runner"
echo "   → Product → Build"
echo "   → Product → Run"
echo ""
echo "5. ${YELLOW}Test Widget${NC}"
echo "   → Long press sulla home screen"
echo "   → Widget → Caffeine Tracker"
echo ""

read -p "Vuoi aprire Xcode ora? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo ""
    echo "🚀 Aprendo Xcode..."
    cd ios && open Runner.xcworkspace
    echo ""
    echo -e "${GREEN}✅ Xcode aperto!${NC}"
    echo ""
    echo "Segui i passi sopra per completare la configurazione."
else
    echo ""
    echo "👍 Ok, puoi aprire Xcode manualmente con:"
    echo "   cd ios && open Runner.xcworkspace"
fi

echo ""
echo "📚 Documentazione:"
echo "   - IOS_WIDGETS_GUIDE.md"
echo "   - MULTI_PLATFORM_WIDGETS.md"
echo "   - WIDGETS_ARCHITECTURE.md"
echo ""
echo "🎉 Setup iOS pronto per la configurazione Xcode!"
