#!/bin/bash

# Ehit App - Setup Script
# Este script configura automaticamente o ambiente para deploy automático

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

echo "🚀 Ehit App - Setup de Deploy Automático"
echo "========================================"
echo ""

# Verificar se estamos no diretório correto
if [ ! -f "pubspec.yaml" ]; then
    print_error "Execute este script na raiz do projeto Flutter"
    exit 1
fi

print_status "Verificando dependências..."

# Verificar Flutter
if ! command -v flutter &> /dev/null; then
    print_error "Flutter não encontrado. Instale o Flutter primeiro."
    exit 1
fi

# Verificar Ruby
if ! command -v ruby &> /dev/null; then
    print_error "Ruby não encontrado. Instale o Ruby primeiro."
    exit 1
fi

# Verificar Git
if ! command -v git &> /dev/null; then
    print_error "Git não encontrado. Instale o Git primeiro."
    exit 1
fi

print_success "Dependências verificadas!"

# Instalar dependências Flutter
print_status "Instalando dependências Flutter..."
flutter pub get

# Instalar dependências iOS
print_status "Instalando dependências iOS..."
cd ios
bundle install
cd ..

print_success "Dependências instaladas!"

# Verificar configuração do Git
print_status "Verificando configuração do Git..."
if [ -z "$(git config user.name)" ] || [ -z "$(git config user.email)" ]; then
    print_warning "Configure seu Git primeiro:"
    echo "git config --global user.name 'Seu Nome'"
    echo "git config --global user.email 'seu@email.com'"
    echo ""
fi

# Verificar se é um repositório Git
if [ ! -d ".git" ]; then
    print_warning "Inicializando repositório Git..."
    git init
    git add .
    git commit -m "Initial commit - Ehit App setup"
fi

print_status "Configuração do projeto concluída!"
echo ""
print_warning "Próximos passos:"
echo ""
echo "1. 📱 Configure os secrets no GitHub:"
echo "   - Acesse: Settings → Secrets and variables → Actions"
echo "   - Adicione os secrets listados em .github/SECRETS_SETUP.md"
echo ""
echo "2. 🔑 Crie um App-Specific Password:"
echo "   - Acesse: https://appleid.apple.com"
echo "   - Gere uma senha específica para apps"
echo "   - Use no secret APPLE_ID_PASSWORD"
echo ""
echo "3. 🚀 Faça o primeiro push:"
echo "   git add ."
echo "   git commit -m 'Setup Fastlane and GitHub Actions'"
echo "   git push origin main"
echo ""
echo "4. ✅ Verifique o deploy:"
echo "   - Acesse a aba Actions no GitHub"
echo "   - Confirme que o workflow executou"
echo "   - Verifique o TestFlight"
echo ""
print_success "Setup concluído! 🎉"
