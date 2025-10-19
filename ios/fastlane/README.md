# Fastlane Configuration for Ehit App

Este diretório contém a configuração do Fastlane para automatizar o processo de build e deploy do Ehit App para o TestFlight e App Store.

## 🚀 Configuração Inicial

### 1. Instalar Dependências

```bash
cd ios
bundle install
```

### 2. Configurar Variáveis de Ambiente (Opcional)

```bash
cp fastlane/.env.example fastlane/.env
# Edite o arquivo .env com suas configurações específicas
```

## 📱 Comandos Disponíveis

### Usando o Script Helper (Recomendado)

```bash
# Build e upload para TestFlight
./fastlane.sh beta

# Build e upload para TestFlight com changelog customizado
./fastlane.sh beta-custom "Fixed login bug and improved performance"

# Build e upload para App Store
./fastlane.sh release

# Limpar artifacts de build
./fastlane.sh clean

# Setup inicial do Fastlane
./fastlane.sh setup
```

### Usando Fastlane Diretamente

```bash
cd ios

# Build e upload para TestFlight
bundle exec fastlane beta

# Build e upload para TestFlight com changelog customizado
bundle exec fastlane beta_with_changelog changelog:"Sua mensagem aqui"

# Build e upload para App Store
bundle exec fastlane release
```

## 🔧 Configuração

### Appfile
- **app_identifier**: `br.com.brandaodeveloper.ehitapp`
- **apple_id**: `brandaodeveloperapp@gmail.com`
- **team_id**: `W66MTSPZ69` (Developer Portal)
- **itc_team_id**: `127134714` (App Store Connect)

### Fastfile
O arquivo `Fastfile` contém três lanes principais:

1. **beta**: Build e upload para TestFlight
2. **beta_with_changelog**: Build e upload para TestFlight com changelog customizado
3. **release**: Build e upload para App Store

## 📋 Processo de Build

Cada lane executa as seguintes etapas:

1. **Flutter Build**: Limpa e reconstrói o projeto Flutter
2. **Increment Build Number**: Incrementa automaticamente o número de build
3. **iOS Build**: Compila o projeto iOS com configurações otimizadas
4. **Upload**: Envia para TestFlight ou App Store

## ⚙️ Configurações de Export

- **Method**: `app-store`
- **Team ID**: `W66MTSPZ69`
- **Upload Bitcode**: `false` (recomendado para Flutter)
- **Upload Symbols**: `true` (para crash reports)
- **Compile Bitcode**: `false`

## 🔐 Certificados e Provisioning Profiles

O Fastlane gerencia automaticamente:
- Certificados de distribuição
- Provisioning profiles
- App Store Connect API

## 📝 Changelog

Para builds do TestFlight, você pode:
- Usar o changelog padrão: `"New build with latest features and improvements"`
- Personalizar com: `./fastlane.sh beta-custom "Sua mensagem aqui"`

## 🐛 Troubleshooting

### Erro de Certificados
```bash
# Limpar certificados e regenerar
bundle exec fastlane match nuke distribution
bundle exec fastlane match development
```

### Erro de Build
```bash
# Limpar tudo e tentar novamente
./fastlane.sh clean
./fastlane.sh beta
```

### Problemas de Autenticação
```bash
# Re-autenticar com Apple ID
bundle exec fastlane spaceauth -u brandaodeveloperapp@gmail.com
```

## 📚 Recursos Úteis

- [Documentação Fastlane](https://docs.fastlane.tools/)
- [TestFlight Guide](https://docs.fastlane.tools/getting-started/ios/beta-deployment/)
- [App Store Guide](https://docs.fastlane.tools/getting-started/ios/appstore-deployment/)

## 🆘 Suporte

Se encontrar problemas:
1. Verifique se está na branch correta
2. Execute `./fastlane.sh clean` antes de tentar novamente
3. Verifique os logs do Fastlane para mais detalhes
4. Consulte a documentação oficial do Fastlane
