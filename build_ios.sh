#!/bin/bash

# Script para automatizar build iOS do Flutter
# Uso: ./build_ios.sh [version] [build_number]

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Função para log
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Verificar se estamos no diretório correto
if [ ! -f "pubspec.yaml" ]; then
    error "Execute este script na raiz do projeto Flutter"
fi

# Ler versão atual do pubspec.yaml
CURRENT_VERSION=$(grep "^version:" pubspec.yaml | sed -E 's/version: ([0-9]+\.[0-9]+\.[0-9]+)\+([0-9]+)/\1 \2/')
CURRENT_VERSION_STRING=$(echo $CURRENT_VERSION | awk '{print $1}')
CURRENT_BUILD=$(echo $CURRENT_VERSION | awk '{print $2}')

# Incrementar automaticamente
if [ "$1" = "" ] && [ "$2" = "" ]; then
    # Extrair major.minor.patch
    IFS='.' read -r MAJOR MINOR PATCH <<< "$CURRENT_VERSION_STRING"
    # Incrementar patch
    PATCH=$((PATCH + 1))
    VERSION="$MAJOR.$MINOR.$PATCH"
    BUILD_NUMBER=$((CURRENT_BUILD + 1))
else
    # Usar versões passadas como parâmetro
    VERSION=${1:-"$CURRENT_VERSION_STRING"}
    BUILD_NUMBER=${2:-"$CURRENT_BUILD"}
fi

log "Iniciando build iOS..."
log "Versão atual: $CURRENT_VERSION_STRING+$CURRENT_BUILD"
log "Nova versão: $VERSION+$BUILD_NUMBER"

# 1. Atualizar versão no pubspec.yaml
log "Atualizando versão no pubspec.yaml..."
sed -i '' "s/version: [0-9.]*+[0-9]*/version: $VERSION+$BUILD_NUMBER/" pubspec.yaml

# Verificar se a atualização foi feita
if grep -q "version: $VERSION+$BUILD_NUMBER" pubspec.yaml; then
    log "✅ Versão atualizada no pubspec.yaml: $VERSION+$BUILD_NUMBER"
else
    error "❌ Falha ao atualizar versão no pubspec.yaml"
fi

# 2. Limpar projeto
log "Limpando projeto..."
flutter clean
flutter pub get

# 3. Executar testes
log "Executando testes..."
flutter test || warning "Alguns testes falharam, continuando..."

# 4. Build Flutter iOS
log "Fazendo build Flutter iOS..."
flutter build ios --release --no-codesign

# 5. Navegar para iOS e configurar Xcode
cd ios

# 6. Atualizar versão no Info.plist
log "Atualizando versão no Info.plist..."
/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $VERSION" Runner/Info.plist
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $BUILD_NUMBER" Runner/Info.plist

# 7. Build com Xcode
log "Fazendo build com Xcode..."
xcodebuild -workspace Runner.xcworkspace \
    -scheme Runner \
    -configuration Release \
    -destination generic/platform=iOS \
    -archivePath Runner.xcarchive \
    archive

# 8. Exportar IPA
log "Exportando IPA..."
xcodebuild -exportArchive \
    -archivePath Runner.xcarchive \
    -exportPath . \
    -exportOptionsPlist ExportOptions.plist

# 9. Verificar se o IPA foi criado
if [ -f "ehit_app.ipa" ]; then
    log "✅ Build concluído com sucesso!"
    log "IPA criado: $(pwd)/ehit_app.ipa"
    log "Tamanho: $(du -h ehit_app.ipa | cut -f1)"
elif [ -f "Runner.ipa" ]; then
    log "✅ Build concluído com sucesso!"
    log "IPA criado: $(pwd)/Runner.ipa"
    log "Tamanho: $(du -h Runner.ipa | cut -f1)"
else
    error "❌ Falha ao criar IPA"
fi

# 10. Voltar para diretório raiz
cd ..

# 11. Upload para TestFlight
log "Fazendo upload para TestFlight..."
UPLOAD_FILE=""
if [ -f "ios/ehit_app.ipa" ]; then
    UPLOAD_FILE="ios/ehit_app.ipa"
elif [ -f "ios/Runner.ipa" ]; then
    UPLOAD_FILE="ios/Runner.ipa"
fi

if [ -n "$UPLOAD_FILE" ]; then
    log "📤 Enviando $UPLOAD_FILE para App Store Connect..."
    
    # Tentar upload via altool
    if xcrun altool --upload-app \
        --type ios \
        --file "$UPLOAD_FILE" \
        --username "brandaodeveloperapp@gmail.com" \
        --password "hxtw-sqnv-lsee-grbp" 2>&1 | grep -q "No errors"; then
        log "✅ Upload realizado com sucesso!"
        log "🎉 O app está sendo processado e estará disponível no TestFlight em breve"
    else
        log "⚠️  Upload via altool falhou"
        log "💡 Tentar via Transporter:"
        log "1. Abra o app 'Transporter'"
        log "2. Arraste o arquivo $UPLOAD_FILE"
        log "3. Clique em 'Deliver'"
    fi
else
    error "❌ Arquivo IPA não encontrado para upload"
fi

log "🎉 Build iOS finalizado!"
log "📱 Versão: $VERSION ($BUILD_NUMBER)"
log "📦 Arquivo: $UPLOAD_FILE"
