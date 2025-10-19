#!/bin/bash

# Setup Fastlane Match for Ehit App
# Este script configura os certificados pela primeira vez

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

echo "🔐 Ehit App - Setup Fastlane Match"
echo "=================================="
echo ""

# Verificar se estamos no diretório correto
if [ ! -f "ios/fastlane/Matchfile" ]; then
    print_error "Execute este script na raiz do projeto Flutter"
    exit 1
fi

print_status "Verificando dependências..."

# Verificar se o repositório de certificados existe
REPO_URL="git@github.com:igorbrandao18/ehit_certs_apple.git"
if ! git ls-remote "$REPO_URL" &> /dev/null; then
    print_error "Repositório de certificados não encontrado: $REPO_URL"
    print_error "Crie o repositório primeiro no GitHub"
    exit 1
fi

print_success "Repositório de certificados encontrado"

# Solicitar senha do Match
echo ""
print_warning "Você precisa criar uma senha forte para criptografar os certificados"
print_warning "Esta senha será usada para criptografar/descriptografar os certificados"
echo ""
read -s -p "Digite a senha do Match: " MATCH_PASSWORD
echo ""

if [ -z "$MATCH_PASSWORD" ]; then
    print_error "Senha não pode estar vazia"
    exit 1
fi

# Exportar variáveis de ambiente
export MATCH_PASSWORD="$MATCH_PASSWORD"
export APPLE_ID="brandaodeveloperapp@gmail.com"
export TEAM_ID="W66MTSPZ69"
export ITC_TEAM_ID="127134714"
export APP_IDENTIFIER="br.com.brandaodeveloper.ehitapp"

print_status "Configurando certificados..."

# Navegar para o diretório iOS
cd ios

# Executar o setup do Match
print_status "Executando fastlane match_setup..."
bundle exec fastlane match_setup

print_success "Certificados configurados com sucesso!"
print_success "Agora você pode fazer deploy para o TestFlight"

echo ""
print_status "Próximos passos:"
echo "1. Configure os secrets no GitHub (veja .github/SECRETS_SETUP.md)"
echo "2. Faça um push para a branch main"
echo "3. O deploy automático será executado"
echo ""
print_warning "IMPORTANTE: Guarde bem a senha do Match! Você precisará dela sempre."
