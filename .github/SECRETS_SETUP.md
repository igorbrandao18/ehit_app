# Configuração de Secrets para GitHub Actions

Para que o deploy automático funcione, você precisa configurar os seguintes secrets no seu repositório GitHub:

## 🔐 Secrets Necessários

Acesse: `Settings` → `Secrets and variables` → `Actions` → `New repository secret`

### 1. APPLE_ID
- **Valor**: `brandaodeveloperapp@gmail.com`
- **Descrição**: Seu Apple ID para App Store Connect

### 2. APPLE_ID_PASSWORD
- **Valor**: Sua senha do Apple ID
- **Descrição**: Senha da sua conta Apple Developer
- **⚠️ Importante**: Use uma senha específica para apps ou App-Specific Password

### 3. TEAM_ID
- **Valor**: `W66MTSPZ69`
- **Descrição**: Team ID do Apple Developer Portal

### 4. ITC_TEAM_ID
- **Valor**: `127134714`
- **Descrição**: Team ID do App Store Connect

### 5. APP_IDENTIFIER
- **Valor**: `br.com.brandaodeveloper.ehitapp`
- **Descrição**: Bundle identifier do app

## 🔑 Como Configurar App-Specific Password

1. Acesse [appleid.apple.com](https://appleid.apple.com)
2. Faça login com sua conta Apple
3. Vá em "Sign-In and Security" → "App-Specific Passwords"
4. Clique em "Generate an app-specific password"
5. Digite um nome como "GitHub Actions Ehit App"
6. Copie a senha gerada
7. Use essa senha no secret `APPLE_ID_PASSWORD`

## 🚀 Como Funciona

### Deploy Automático
- **Trigger**: A cada push na branch `main`
- **Processo**: 
  1. Checkout do código
  2. Setup do Flutter e Ruby
  3. Instalação de dependências
  4. Build do Flutter iOS
  5. Deploy para TestFlight via Fastlane

### Deploy Manual
- **Trigger**: Via GitHub Actions UI
- **Uso**: Para deploys sob demanda ou testes

## 📱 Verificação do Deploy

Após o push:
1. Acesse a aba "Actions" no GitHub
2. Veja o progresso do workflow
3. Se bem-sucedido, verifique o TestFlight
4. O build aparecerá automaticamente no TestFlight

## 🐛 Troubleshooting

### Erro de Autenticação
- Verifique se os secrets estão configurados corretamente
- Use App-Specific Password em vez da senha normal
- Verifique se o Apple ID tem acesso ao App Store Connect

### Erro de Build
- Verifique se todas as dependências estão no `pubspec.yaml`
- Verifique se o bundle identifier está correto
- Verifique se os certificados estão válidos

### Erro de Fastlane
- Verifique se o `ios/fastlane/Fastfile` está correto
- Verifique se o `ios/fastlane/Appfile` está correto
- Verifique se o bundle install foi executado

## 📋 Checklist de Configuração

- [ ] Secrets configurados no GitHub
- [ ] App-Specific Password criado
- [ ] Fastlane configurado localmente
- [ ] Teste local do `fastlane beta` funcionando
- [ ] Push inicial na branch main feito
- [ ] Workflow executado com sucesso
- [ ] Build apareceu no TestFlight

## 🔄 Workflow de Desenvolvimento

1. **Desenvolvimento**: Trabalhe na branch `develop`
2. **Teste Local**: Use `./fastlane.sh beta` para testar
3. **Merge**: Faça merge para `main` quando pronto
4. **Deploy Automático**: O GitHub Actions fará o deploy
5. **Verificação**: Confirme no TestFlight

## 📞 Suporte

Se encontrar problemas:
1. Verifique os logs do GitHub Actions
2. Teste localmente com `./fastlane.sh beta`
3. Verifique se todos os secrets estão corretos
4. Consulte a documentação do Fastlane
