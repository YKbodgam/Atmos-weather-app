import 'package:dartz/dartz.dart';

import '../../../../core/error/failure_handler.dart';

import '../entities/weather_entity.dart';
import '../repositories/weather_repository.dart';

/// Use case to get weather by coordinates
class GetWeatherUseCase {
  final WeatherRepository repository;

  GetWeatherUseCase(this.repository);

  Future<Either<Failure, WeatherEntity>> call({
    required double latitude,
    required double longitude,
  }) async {
    return repository.getWeatherByCoordinates(
      latitude: latitude,
      longitude: longitude,
    );
  }
}

/// Use case to search cities
class SearchCitiesUseCase {
  final WeatherRepository repository;

  SearchCitiesUseCase(this.repository);

  Future<Either<Failure, List<CityEntity>>> call({
    required String query,
  }) async {
    if (query.trim().isEmpty) {
      return Left<Failure, List<CityEntity>>(
        NotFoundFailure(message: 'Query cannot be empty'),
      );
    }
    return await repository.searchCities(query: query);
  }
}

/// Use case to get cached weather
class GetCachedWeatherUseCase {
  final WeatherRepository repository;

  GetCachedWeatherUseCase(this.repository);

  Future<WeatherEntity?> call() async {
    return repository.getCachedWeather();
  }
}

/// Use case to get recent searches
class GetRecentSearchesUseCase {
  final WeatherRepository repository;

  GetRecentSearchesUseCase(this.repository);

  Future<List<CityEntity>> call() async {
    return repository.getCachedRecentSearches();
  }
}

/// Use case to add city to favorites
class AddToFavoritesUseCase {
  final WeatherRepository repository;

  AddToFavoritesUseCase(this.repository);

  Future<void> call(CityEntity city) async {
    return repository.addToFavorites(city);
  }
}

/// Use case to remove city from favorites
class RemoveFromFavoritesUseCase {
  final WeatherRepository repository;

  RemoveFromFavoritesUseCase(this.repository);

  Future<void> call(String cityKey) async {
    return repository.removeFromFavorites(cityKey);
  }
}

/// Use case to get all favorites
class GetFavoritesUseCase {
  final WeatherRepository repository;

  GetFavoritesUseCase(this.repository);

  Future<List<CityEntity>> call() async {
    return repository.getFavorites();
  }
}

/// Use case to clear cache
class ClearCacheUseCase {
  final WeatherRepository repository;

  ClearCacheUseCase(this.repository);

  Future<void> call() async {
    return repository.clearCache();
  }
}
