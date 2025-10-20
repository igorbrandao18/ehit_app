#!/bin/bash

# Script para abrir o Xcode Organizer para upload do IPA
# Autor: Igor Brandão

echo "🚀 Abrindo Xcode Organizer para upload do IPA..."

# Verificar se o archive existe
ARCHIVE_PATH="./Runner.xcarchive"
if [ ! -d "$ARCHIVE_PATH" ]; then
    echo "❌ Erro: Archive não encontrado em $ARCHIVE_PATH"
    echo "💡 Execute primeiro: xcodebuild archive"
    exit 1
fi

echo "📱 Archive encontrado: $ARCHIVE_PATH"
echo "🔧 Abrindo Xcode Organizer..."

# Abrir o Xcode Organizer
open -a Xcode
sleep 3

echo "📋 Instruções para upload:"
echo "1. No Xcode, vá em Window → Organizer"
echo "2. Na aba 'Archives', selecione o archive 'Runner'"
echo "3. Clique em 'Distribute App'"
echo "4. Escolha 'App Store Connect'"
echo "5. Siga as instruções na tela"
echo ""
echo "💡 Dica: O Xcode vai pedir suas credenciais da Apple ID"
echo "📧 Use: brandaodeveloperapp@gmail.com"
echo "🔐 E sua senha normal da Apple ID"

echo "🏁 Xcode Organizer aberto!"
