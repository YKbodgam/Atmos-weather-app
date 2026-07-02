import 'package:dartz/dartz.dart';

import '../mapper/entity_mapper.dart';
import '../local/local_datasource.dart';
import '../remote/remote_datasource.dart';

import '../../domain/entities/weather_entity.dart';
import '../../domain/repositories/weather_repository.dart';

import '../../../../core/error/failure_handler.dart';

/// Implementation of WeatherRepository
class WeatherRepositoryImpl implements WeatherRepository {
  final RemoteWeatherDataSource remoteDataSource;
  final LocalWeatherDataSource localDataSource;

  WeatherRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, WeatherEntity>> getWeatherByCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final remoteWeather = await remoteDataSource.getWeatherByCoordinates(
        latitude: latitude,
        longitude: longitude,
      );

      // Cache the weather data
      await localDataSource.cacheWeather(remoteWeather);

      final entity = WeatherMapper.toWeatherEntity(remoteWeather);
      return Right<Failure, WeatherEntity>(entity);
    } catch (e) {
      // Try to get cached data on failure
      try {
        final cachedWeather = await localDataSource.getCachedWeather();
        if (cachedWeather != null) {
          final entity = WeatherMapper.toWeatherEntity(cachedWeather);
          return Right<Failure, WeatherEntity>(entity);
        }
      } catch (_) {}

      if (e is Failure) {
        return Left<Failure, WeatherEntity>(e);
      }
      return Left<Failure, WeatherEntity>(
        UnknownFailure(message: e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, List<CityEntity>>> searchCities({
    required String query,
  }) async {
    try {
      final response = await remoteDataSource.searchCities(query: query);

      if (response.results.isEmpty) {
        return Left<Failure, List<CityEntity>>(
          NotFoundFailure(message: 'No cities found'),
        );
      }

      // Cache the search
      if (response.results.isNotEmpty) {
        await localDataSource.cacheRecentSearch(
          name: response.results[0].name,
          country: response.results[0].country,
          latitude: response.results[0].latitude,
          longitude: response.results[0].longitude,
        );
      }

      final cities = WeatherMapper.toCityEntityList(response.results);
      return Right<Failure, List<CityEntity>>(cities);
    } catch (e) {
      if (e is Failure) {
        return Left<Failure, List<CityEntity>>(e);
      }
      return Left<Failure, List<CityEntity>>(
        UnknownFailure(message: e.toString()),
      );
    }
  }

  @override
  Future<WeatherEntity?> getCachedWeather() async {
    try {
      final cached = await localDataSource.getCachedWeather();
      if (cached != null) {
        return WeatherMapper.toWeatherEntity(cached);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<CityEntity>> getCachedRecentSearches() async {
    try {
      final searches = await localDataSource.getRecentSearches();
      return searches
          .map(
            (json) => CityEntity(
              name: json['name'] as String? ?? 'Unknown',
              country: json['country'] as String? ?? 'Unknown',
              latitude: json['latitude'] as double? ?? 0.0,
              longitude: json['longitude'] as double? ?? 0.0,
            ),
          )
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> addToFavorites(CityEntity city) async {
    try {
      final key = '${city.name}-${city.country}';
      await localDataSource.addToFavorites(
        key: key,
        name: city.name,
        country: city.country,
        latitude: city.latitude,
        longitude: city.longitude,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> removeFromFavorites(String cityKey) async {
    try {
      await localDataSource.removeFromFavorites(cityKey);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<CityEntity>> getFavorites() async {
    try {
      final favorites = await localDataSource.getFavorites();
      return favorites
          .map(
            (json) => CityEntity(
              name: json['name'] as String? ?? 'Unknown',
              country: json['country'] as String? ?? 'Unknown',
              latitude: json['latitude'] as double? ?? 0.0,
              longitude: json['longitude'] as double? ?? 0.0,
            ),
          )
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await localDataSource.clearCache();
    } catch (e) {
      rethrow;
    }
  }
}
