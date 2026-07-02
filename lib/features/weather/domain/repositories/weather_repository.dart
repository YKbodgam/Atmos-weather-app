import 'package:atmos/core/error/failure_handler.dart';
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

/// Helper type alias for Either pattern
typedef Either<L, R> = Future<Result<L, R>>;

/// Result type for Either pattern
abstract class Result<L, R> {
  T fold<T>(
    T Function(L failure) onFailure,
    T Function(R success) onSuccess,
  );
}

/// Left result (failure)
class Left<L, R> extends Result<L, R> {
  final L value;
  Left(this.value);

  @override
  T fold<T>(
    T Function(L failure) onFailure,
    T Function(R success) onSuccess,
  ) {
    return onFailure(value);
  }
}

/// Right result (success)
class Right<L, R> extends Result<L, R> {
  final R value;
  Right(this.value);

  @override
  T fold<T>(
    T Function(L failure) onFailure,
    T Function(R success) onSuccess,
  ) {
    return onSuccess(value);
  }
}

/// Extension methods for Either pattern
extension EitherExtension<L, R> on Either<L, R> {
  Future<T> fold<T>(
    T Function(L failure) onFailure,
    T Function(R success) onSuccess,
  ) async {
    final result = await this;
    return result.fold(onFailure, onSuccess);
  }
}
