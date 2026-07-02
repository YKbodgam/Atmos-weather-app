import 'package:get_it/get_it.dart';
import 'package:atmos/features/weather/data/local/local_datasource.dart';
import 'package:atmos/features/weather/data/remote/api_client.dart';
import 'package:atmos/features/weather/data/remote/remote_datasource.dart';
import 'package:atmos/features/weather/data/repository/repository_impl.dart';
import 'package:atmos/features/weather/domain/repositories/weather_repository.dart';
import 'package:atmos/features/weather/domain/usecases/weather_usecases.dart';
import 'package:atmos/features/weather/presentation/providers/favorites_provider.dart';
import 'package:atmos/features/weather/presentation/providers/search_provider.dart';
import 'package:atmos/features/weather/presentation/providers/settings_provider.dart';
import 'package:atmos/features/weather/presentation/providers/weather_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

final getIt = GetIt.instance;

/// Setup all dependencies
Future<void> setupServiceLocator() async {
  // Initialize Hive
  await Hive.initFlutter();
  final localDataSource = LocalWeatherDataSourceImpl();
  await localDataSource.init();

  // Register Data Layer
  getIt.registerSingleton<ApiClient>(ApiClient());
  
  getIt.registerSingleton<RemoteWeatherDataSource>(
    RemoteWeatherDataSourceImpl(apiClient: getIt<ApiClient>()),
  );

  getIt.registerSingleton<LocalWeatherDataSource>(localDataSource);

  getIt.registerSingleton<WeatherRepository>(
    WeatherRepositoryImpl(
      remoteDataSource: getIt<RemoteWeatherDataSource>(),
      localDataSource: getIt<LocalWeatherDataSource>(),
    ),
  );

  // Register Use Cases
  getIt.registerSingleton<GetWeatherUseCase>(
    GetWeatherUseCase(getIt<WeatherRepository>()),
  );

  getIt.registerSingleton<SearchCitiesUseCase>(
    SearchCitiesUseCase(getIt<WeatherRepository>()),
  );

  getIt.registerSingleton<GetCachedWeatherUseCase>(
    GetCachedWeatherUseCase(getIt<WeatherRepository>()),
  );

  getIt.registerSingleton<GetRecentSearchesUseCase>(
    GetRecentSearchesUseCase(getIt<WeatherRepository>()),
  );

  getIt.registerSingleton<AddToFavoritesUseCase>(
    AddToFavoritesUseCase(getIt<WeatherRepository>()),
  );

  getIt.registerSingleton<RemoveFromFavoritesUseCase>(
    RemoveFromFavoritesUseCase(getIt<WeatherRepository>()),
  );

  getIt.registerSingleton<GetFavoritesUseCase>(
    GetFavoritesUseCase(getIt<WeatherRepository>()),
  );

  getIt.registerSingleton<ClearCacheUseCase>(
    ClearCacheUseCase(getIt<WeatherRepository>()),
  );

  // Register Providers
  getIt.registerSingleton<WeatherProvider>(
    WeatherProvider(
      getWeatherUseCase: getIt<GetWeatherUseCase>(),
      getCachedWeatherUseCase: getIt<GetCachedWeatherUseCase>(),
    ),
  );

  getIt.registerSingleton<SearchProvider>(
    SearchProvider(
      searchCitiesUseCase: getIt<SearchCitiesUseCase>(),
      getRecentSearchesUseCase: getIt<GetRecentSearchesUseCase>(),
    ),
  );

  getIt.registerSingleton<FavoritesProvider>(
    FavoritesProvider(
      addToFavoritesUseCase: getIt<AddToFavoritesUseCase>(),
      removeFromFavoritesUseCase: getIt<RemoveFromFavoritesUseCase>(),
      getFavoritesUseCase: getIt<GetFavoritesUseCase>(),
    ),
  );

  getIt.registerSingleton<SettingsProvider>(SettingsProvider());
}
