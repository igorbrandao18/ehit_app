# ÊHIT - Music Streaming App 🎵

A modern Flutter music streaming application built with Clean Architecture, featuring Spotify-style functionality with comprehensive music library, playlists, user authentication, and social features.

## 🚀 Deploy Automático

**A cada push na branch `main`, o app é automaticamente enviado para o TestFlight!**

### Como Funciona

1. **Push para main** → GitHub Actions executa automaticamente
2. **Build Flutter** → Compila o projeto iOS
3. **Deploy TestFlight** → Envia para o TestFlight via Fastlane
4. **Notificação** → Build disponível para testes

### Setup do Deploy Automático

1. **Executar Setup Automático**
   ```bash
   ./setup.sh
   ```

2. **Configurar Secrets no GitHub**
   Acesse: `Settings` → `Secrets and variables` → `Actions`
   
   **Secrets necessários:**
   - `APPLE_ID`: `brandaodeveloperapp@gmail.com`
   - `APPLE_ID_PASSWORD`: Sua senha do Apple ID (use App-Specific Password)
   - `TEAM_ID`: `W66MTSPZ69`
   - `ITC_TEAM_ID`: `127134714`
   - `APP_IDENTIFIER`: `br.com.brandaodeveloper.ehitapp`

3. **Primeiro Deploy**
   ```bash
   git add .
   git commit -m "Setup Fastlane and GitHub Actions"
   git push origin main
   ```

### Comandos de Deploy Local

```bash
# Deploy para TestFlight
./fastlane.sh beta

# Deploy com changelog customizado
./fastlane.sh beta-custom "Fixed login bug and improved performance"

# Deploy para App Store
./fastlane.sh release
```

### Bundle Identifier
- **iOS**: `br.com.brandaodeveloper.ehitapp`
- **Android**: `br.com.brandaodeveloper.ehitapp`

## 🎯 Overview

ÊHIT is a Spotify-style music streaming platform that provides users with:
- **Music Library**: Browse and search songs, albums, artists
- **Playlists**: Create, manage, and share playlists
- **User Profiles**: Complete authentication and user preferences
- **Music Player**: Advanced audio playback with controls
- **Social Features**: Follow users, share music, discover new content
- **Offline Mode**: Download music for offline listening

## 🏗️ Architecture

This project follows **Clean Architecture** principles with well-defined layers:

```
lib/
├── core/                           # Shared functionality
│   ├── constants/                  # Global constants
│   ├── errors/                     # Custom error classes
│   ├── utils/                      # General utilities
│   ├── injection/                  # Dependency injection
│   ├── routing/                    # Navigation
│   ├── supabase/                   # Supabase integration
│   ├── audio/                      # Audio services
│   └── social/                     # Social features
├── features/                       # App features
│   ├── music_library/              # Music browsing and search
│   │   ├── data/                   # Data layer
│   │   ├── domain/                 # Domain layer
│   │   └── presentation/           # Presentation layer
│   ├── music_player/               # Audio playback
│   │   ├── data/                   # Data layer
│   │   ├── domain/                 # Domain layer
│   │   └── presentation/           # Presentation layer
│   └── authentication/             # User authentication
│       ├── data/                   # Data layer
│       ├── domain/                 # Domain layer
│       └── presentation/           # Presentation layer
├── shared/                         # Shared components
│   ├── widgets/                    # Reusable widgets
│   ├── design/                     # Design system
│   └── utils/                      # Shared utilities
└── main.dart                       # Application entry point
```

### Architecture Layers

1. **Presentation Layer**: UI components, controllers, and state management
2. **Domain Layer**: Business logic, entities, use cases, and repository interfaces
3. **Data Layer**: Data sources, models, and repository implementations
4. **Core Layer**: Shared utilities, constants, error handling, and dependency injection

## 🛠️ Technology Stack

- **Frontend**: Flutter (Dart)
- **State Management**: Provider + ChangeNotifier
- **Dependency Injection**: GetIt
- **HTTP Client**: Dio
- **Local Storage**: SharedPreferences
- **Backend**: Supabase (Database, Authentication, Storage)
- **JSON Serialization**: json_annotation + build_runner
- **Routing**: GoRouter
- **Testing**: flutter_test + mockito

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0+)
- Dart SDK (3.0+)
- iOS Simulator or Android Emulator
- Supabase account (for backend services)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/igorbrandao18/ehit_app.git
   cd ehit_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Supabase**
   - Create a Supabase project
   - Update `lib/core/constants/app_config.dart` with your Supabase credentials:
   ```dart
   class AppConfig {
     static const String supabaseUrl = 'YOUR_SUPABASE_URL';
     static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
   }
   ```

4. **Run the application**
   ```bash
   flutter run
   ```

## 📱 Features

### Music Library
- Browse songs, albums, and artists
- Search functionality
- Category-based filtering
- Popular and recent content
- Artist detail pages

### Music Player
- Audio playback controls
- Playlist management
- Queue management
- Offline playback
- Background playback

### Authentication
- Email/password login
- User registration
- Biometric authentication
- Password reset
- Email verification
- User profile management

### Social Features
- Follow/unfollow users
- Share music and playlists
- Discover new content
- User activity feed

## 🧪 Testing

The project includes comprehensive testing:

```bash
# Run all tests
flutter test

# Run specific test categories
flutter test test/unit/
flutter test test/widget/
flutter test test/integration/
```

### Test Coverage
- **Unit Tests**: Domain logic, use cases, repositories
- **Widget Tests**: UI components and interactions
- **Integration Tests**: End-to-end user flows

## 📊 Architecture Compliance

- ✅ **Clean Architecture**: 100% compliant
- ✅ **Dependency Injection**: GetIt properly configured
- ✅ **Result Pattern**: Consistent error handling
- ✅ **Design System**: Complete token system
- ✅ **State Management**: Provider + ChangeNotifier
- ✅ **Testing**: Comprehensive test coverage

## 🔧 Development

### Code Generation
```bash
# Generate JSON serialization code
flutter packages pub run build_runner build

# Watch for changes
flutter packages pub run build_runner watch
```

### Code Analysis
```bash
# Run static analysis
flutter analyze

# Fix formatting issues
dart format .
```

### Build
```bash
# Build for Android
flutter build apk

# Build for iOS
flutter build ios
```

## 📚 Documentation

- [Clean Architecture Guide](ARCHITECTURE.mdc)
- [API Documentation](docs/api.md)
- [Contributing Guidelines](CONTRIBUTING.md)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Team

- **Igor Brandão** - Lead Developer
- **Contributors** - See [CONTRIBUTORS.md](CONTRIBUTORS.md)

## 🔗 Links

- [Live Demo](https://ehit-app.vercel.app)
- [Documentation](https://docs.ehit-app.com)
- [API Reference](https://api.ehit-app.com/docs)

## 📈 Project Status

- **Version**: 2.0.0
- **Status**: ✅ Active Development
- **Architecture**: ✅ Clean Architecture (100% compliant)
- **Tests**: ✅ 63 tests passing
- **Coverage**: ✅ 80%+ code coverage

---

**Built with ❤️ using Flutter and Clean Architecture**