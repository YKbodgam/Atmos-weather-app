import 'package:dartz/dartz.dart';

import '../../../../core/error/failure_handler.dart';
import '../entities/weather_entity.dart';

/// Abstract repository for weather operations
abstract class WeatherRepository {
  /// Get current weather for given coordinates
  /// Returns [WeatherEntity] or [Failure]
  Future<Either<Failure, WeatherEntity>> getWeatherByCoordinates({
    required double latitude,
    required double longitude,
  });

  /// Search cities by query
  /// Returns list of [CityEntity] or [Failure]
  Future<Either<Failure, List<CityEntity>>> searchCities({
    required String query,
  });

  /// Get cached weather
  /// Returns [WeatherEntity] or null
  Future<WeatherEntity?> getCachedWeather();

  /// Get cached cities from recent searches
  /// Returns list of [CityEntity]
  Future<List<CityEntity>> getCachedRecentSearches();

  /// Save city to favorites
  Future<void> addToFavorites(CityEntity city);

  /// Remove city from favorites
  Future<void> removeFromFavorites(String cityKey);

  /// Get all favorite cities
  Future<List<CityEntity>> getFavorites();

  /// Clear all cache
  Future<void> clearCache();
}
