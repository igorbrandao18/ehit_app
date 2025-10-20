#!/bin/bash

# Script para upload do IPA para TestFlight
# Autor: Igor Brandão
# Data: $(date)

echo "🚀 Iniciando upload do IPA para TestFlight..."

# Configurações
IPA_PATH="./build/ehit_app.ipa"
APPLE_ID="brandaodeveloperapp@gmail.com"
APP_SPECIFIC_PASSWORD="hxtw-sqnv-lsee-grbp"

# Verificar se o arquivo IPA existe
if [ ! -f "$IPA_PATH" ]; then
    echo "❌ Erro: Arquivo IPA não encontrado em $IPA_PATH"
    echo "💡 Execute primeiro: flutter build ios --release --no-codesign"
    echo "💡 Depois: xcodebuild archive e xcodebuild -exportArchive"
    exit 1
fi

echo "📱 Arquivo IPA encontrado: $IPA_PATH"
echo "📧 Apple ID: $APPLE_ID"
echo "🔐 Usando App-Specific Password..."

# Fazer o upload
echo "⏳ Fazendo upload para TestFlight..."
echo "⚠️  Nota: Para TestFlight, você precisa de um certificado de distribuição"
echo "💡 Alternativa: Use o Xcode Organizer para fazer o upload"
echo ""
echo "📋 Passos para upload via Xcode:"
echo "1. Abra o Xcode"
echo "2. Vá em Window → Organizer"
echo "3. Selecione o archive 'Runner'"
echo "4. Clique em 'Distribute App'"
echo "5. Escolha 'App Store Connect'"
echo "6. Siga as instruções na tela"
echo ""
echo "🔄 Tentando upload via altool (pode falhar sem certificado de distribuição)..."
xcrun altool --upload-app \
    -f "$IPA_PATH" \
    -u "$APPLE_ID" \
    -p "$APP_SPECIFIC_PASSWORD" \
    --type ios

# Verificar resultado
if [ $? -eq 0 ]; then
    echo "✅ Upload realizado com sucesso!"
    echo "🎉 Seu app está sendo processado pelo TestFlight"
    echo "📱 Você receberá um email quando estiver pronto para teste"
else
    echo "❌ Erro no upload"
    echo "💡 Verifique suas credenciais e conexão com a internet"
    echo "💡 Certifique-se de que a App-Specific Password está correta"
fi

echo "🏁 Script finalizado"
