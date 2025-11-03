# Testes - Ehit App

Este diretório contém os testes automatizados do aplicativo Ehit App.

## Estrutura

```
test/
├── unit/                          # Testes unitários
│   ├── core/
│   │   └── utils/
│   │       ├── audio_position_helper_test.dart
│   │       └── result_test.dart
│   └── shared/
│       └── utils/
│           └── responsive_utils_test.dart
└── README.md
```

## Tipos de Testes

### Unitários (`test/unit/`)

Testes que verificam unidades individuais de código (classes, funções) de forma isolada:

- **`audio_position_helper_test.dart`**: Testa a lógica de rastreamento manual de posição de áudio, incluindo:
  - Início e parada do tracking
  - Pausa e retomada
  - Seek (buscar posição)
  - Múltiplos ciclos de pause/resume
  - Callbacks de atualização

- **`result_test.dart`**: Testa o tipo `Result<T>` usado para tratamento de erros:
  - Sucesso e erro
  - Extensões (`isSuccess`, `isError`, `dataOrNull`, `errorMessage`)
  - Método `map` para transformação
  - Método `when` para pattern matching

- **`responsive_utils_test.dart`**: Testa utilitários responsivos:
  - Detecção de tipo de dispositivo (mobile/tablet/desktop)
  - Tamanhos responsivos (spacing, font, icon, image)
  - Dimensões de tela

## Como Executar

### Todos os testes unitários:
```bash
flutter test test/unit/
```

### Teste específico:
```bash
flutter test test/unit/core/utils/audio_position_helper_test.dart
```

### Com coverage:
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## Cobertura Atual

- ✅ `AudioPositionHelper` - 100% cobertura de casos críticos
- ✅ `Result<T>` - Cobertura completa
- ✅ `ResponsiveUtils` - Cobertura de métodos principais

## Testes de Integração e E2E

⚠️ **Nota Importante**: Os testes de integração e e2e em `test/integration/` e `test/e2e/` foram criados mas requerem plugins nativos (`just_audio`) que não funcionam em testes unitários. 

Para executar testes de integração completos:

1. **Integration Tests**: Use `integration_test/` directory (no Flutter, esses testes rodam em dispositivos reais/emuladores)
2. **Mocks**: Para testes unitários, crie mocks do `AudioPlayerService` e `just_audio`
3. **CI/CD**: Configure para rodar integration tests em ambientes que suportam plugins nativos

### Testes de Integração Criados (requerem plugins nativos):

- ✅ `test/integration/audio/audio_player_service_integration_test.dart` - Fluxos de reprodução
- ✅ `test/integration/playlist/playlist_management_integration_test.dart` - Gerenciamento de playlist
- ✅ `test/e2e/music_playback_flow_test.dart` - Cenários completos de usuário

**Para executar em ambiente real:**
```bash
flutter test integration_test/
```

## Próximos Passos

1. **Widgets** - Testes de componentes de UI (MiniPlayer, SongListItem, etc.)
2. **Mocks** - Criar mocks do `just_audio` para testes unitários do `AudioPlayerService`
3. **Integration Tests** - Mover para `integration_test/` e configurar para CI/CD

## Boas Práticas

1. **Nomenclatura**: Use descrições claras do comportamento testado
2. **Isolamento**: Cada teste deve ser independente
3. **Arrange-Act-Assert**: Estruture os testes em 3 fases
4. **Mocks**: Use mocks para dependências externas (ex: `just_audio`)
5. **Coverage**: Mantenha cobertura alta em código crítico (áudio, navegação)

## Dependências de Teste

- `flutter_test` - Framework de testes do Flutter
- `mockito` - Para criar mocks
- `integration_test` - Para testes de integração (futuro)
