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

# Parâmetros
VERSION=${1:-"1.0.13"}
BUILD_NUMBER=${2:-"7"}

log "Iniciando build iOS..."
log "Versão: $VERSION"
log "Build Number: $BUILD_NUMBER"

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

log "🎉 Build iOS finalizado!"
log "Para fazer upload manual:"
log "1. Abra o Transporter app"
log "2. Arraste o arquivo ios/Runner.ipa"
log "3. Clique em 'Deliver'"
