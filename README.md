# Atmos - Weather Application

A production-grade Flutter weather application built with clean architecture principles, demonstrating best practices in software engineering.

## Architecture Overview

The application follows **Layered Clean Architecture** with strict separation of concerns:

```
Presentation Layer (UI, Screens, Providers)
         ↓
   Domain Layer (Entities, Use Cases, Contracts)
         ↓
    Data Layer (DTOs, Repositories, Data Sources)
         ↓
    Core Layer (Constants, Extensions, Utilities)
```

### Layer Responsibilities

**Presentation Layer** (`lib/features/weather/presentation/`)
- Screens: User interface pages
- Providers: State management using Provider + ChangeNotifier
- Widgets: Reusable UI components
- No business logic, API calls, or networking

**Domain Layer** (`lib/features/weather/domain/`)
- Entities: Core business models (immutable, independent of framework)
- Repositories: Abstract contracts (interfaces)
- Use Cases: Business logic operations
- Zero Flutter dependencies

**Data Layer** (`lib/features/weather/data/`)
- DTOs: Data Transfer Objects from API responses
- Repositories: Concrete implementations
- Remote Data Source: API communication (Dio)
- Local Data Source: Cache management (Hive)
- Mappers: DTO → Entity conversion

**Core Layer** (`lib/core/`)
- Constants: App-wide configuration
- Extensions: Utility methods on built-in types
- Error Handling: Failure classes
- Theme: Material 3 Design System

## Project Structure

```
lib/
├── app/                          # App configuration
│   ├── app.dart                  # Main MaterialApp
│   └── app_theme.dart            # Theme definition
├── core/                         # Shared resources
│   ├── constants/
│   │   └── constants.dart        # Constants
│   ├── error/
│   │   └── failure_handler.dart  # Failure classes
│   ├── extensions/
│   │   └── extensions.dart       # Utility extensions
│   └── exports/
│       └── exports.dart          # Barrel file
├── di/
│   └── service_locator.dart      # Dependency injection setup
├── features/
│   └── weather/                  # Weather feature
│       ├── data/
│       │   ├── dto/
│       │   │   └── weather_dto.dart
│       │   ├── remote/
│       │   │   ├── api_client.dart
│       │   │   └── remote_datasource.dart
│       │   ├── local/
│       │   │   └── local_datasource.dart
│       │   ├── mapper/
│       │   │   └── entity_mapper.dart
│       │   └── repository/
│       │       └── repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   └── weather_entity.dart
│       │   ├── repositories/
│       │   │   └── weather_repository.dart
│       │   └── usecases/
│       │       └── weather_usecases.dart
│       └── presentation/
│           ├── providers/
│           │   ├── weather_provider.dart
│           │   ├── search_provider.dart
│           │   ├── favorites_provider.dart
│           │   └── settings_provider.dart
│           ├── screens/
│           │   ├── home_screen.dart
│           │   ├── search_screen.dart
│           │   ├── forecast_screen.dart
│           │   ├── settings_screen.dart
│           │   ├── favorites_screen.dart
│           │   └── bottom_nav_wrapper.dart
│           └── widgets/
│               ├── common_widgets.dart
│               └── weather_widgets.dart
└── main.dart
```

## Key Features

### 1. Current Weather Display
- Real-time temperature and conditions
- Feels-like temperature
- Humidity, wind speed, pressure
- Visibility and UV index
- Sunrise/sunset times

### 2. City Search
- Geocoding API integration
- Recent search history
- Search result caching

### 3. 7-Day Forecast
- Daily min/max temperatures
- Weather conditions
- Rainfall data

### 4. Offline Support
- Hive local caching
- Automatic cache updates
- Cached data fallback

### 5. Favorites Management
- Save favorite cities
- Quick access to favorites
- Favorite toggle functionality

### 6. Customizable Settings
- Temperature units (°C, °F)
- Wind speed units (km/h, m/s, mph)
- Pressure units (hPa, mb)
- Time format (24h, 12h)
- Refresh interval
- Notification toggle

## State Management

Using **Provider with ChangeNotifier** for reactive state management:

- `WeatherProvider`: Current weather and forecast state
- `SearchProvider`: City search state
- `FavoritesProvider`: Favorite cities management
- `SettingsProvider`: User preferences

Each provider handles:
- Loading states
- Success states
- Error states
- Offline states

## API Integration

**Open-Meteo API** (Free, No Authentication Required)
- Weather forecast endpoint
- Geocoding endpoint
- Supports multiple locations
- Real-time data updates

## Data Flow

```
User Interaction
       ↓
Provider (UI State)
       ↓
Use Case (Business Logic)
       ↓
Repository (Data Orchestration)
       ↓
Remote/Local Data Source
       ↓
Mapper (DTO → Entity)
       ↓
Entity (Domain Model)
       ↓
Provider (Update UI)
       ↓
Widget Rebuild
```

## Error Handling

Failure types:
- `NetworkFailure`: Network connectivity issues
- `TimeoutFailure`: Request timeout
- `ServerFailure`: Server-side errors
- `CacheFailure`: Local storage errors
- `ParsingFailure`: JSON parsing errors
- `NotFoundFailure`: Resource not found
- `UnknownFailure`: Generic errors

## Dependency Injection

Using `GetIt` service locator for:
- Repository registration
- Use case registration
- Provider registration
- Data source registration

```dart
// Setup in service_locator.dart
getIt.registerSingleton<WeatherRepository>(
  WeatherRepositoryImpl(
    remoteDataSource: getIt<RemoteWeatherDataSource>(),
    localDataSource: getIt<LocalWeatherDataSource>(),
  ),
);
```

## Design System

**Material 3 Design with Custom Theme**
- Primary Color: Blue (#2563EB)
- Secondary Color: Amber (#FBBF24)
- Proper contrast ratios
- Responsive spacing system
- Rounded corners (8px, 12px, 16px, 24px)

## Performance Optimizations

- Hive caching for offline support
- API response caching
- Efficient list rendering with ListView
- Null safety throughout
- Optimized imports with barrel files

## Code Quality

- Clean code principles
- Single Responsibility Principle
- Dependency Injection
- Proper naming conventions
- Comprehensive error handling
- Type-safe with Dart null safety
- Linting rules enforced

## Setup & Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

4. **Build APK/iOS**
   ```bash
   flutter build apk  # Android
   flutter build ios  # iOS
   ```

## Testing

Architecture supports unit testing:
- Providers can be tested with MockRepository
- Use cases are pure functions
- Entities are immutable
- No Flutter dependencies in domain layer

## Future Enhancements

- Unit and widget tests
- Integration tests
- Real-time updates with WebSocket
- Multiple language support
- User authentication
- Weather alerts
- Advanced analytics
- Performance metrics

## License

MIT License - See LICENSE file for details

---

**Built with ❤️ using Flutter**
