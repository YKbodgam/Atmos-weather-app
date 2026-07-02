import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:atmos/core/constants/constants.dart';
import 'package:atmos/core/error/failure_handler.dart';
import '../dto/weather_dto.dart';

/// Abstract local data source interface
abstract class LocalWeatherDataSource {
  /// Cache weather data
  Future<void> cacheWeather(WeatherResponseDto weather);

  /// Get cached weather
  Future<WeatherResponseDto?> getCachedWeather();

  /// Cache recent search
  Future<void> cacheRecentSearch({
    required String name,
    required String country,
    required double latitude,
    required double longitude,
  });

  /// Get recent searches
  Future<List<Map<String, dynamic>>> getRecentSearches();

  /// Clear recent searches
  Future<void> clearRecentSearches();

  /// Add to favorites
  Future<void> addToFavorites({
    required String key,
    required String name,
    required String country,
    required double latitude,
    required double longitude,
  });

  /// Remove from favorites
  Future<void> removeFromFavorites(String key);

  /// Get favorites
  Future<List<Map<String, dynamic>>> getFavorites();

  /// Clear all cache
  Future<void> clearCache();
}

/// Implementation of local weather data source using Hive
class LocalWeatherDataSourceImpl implements LocalWeatherDataSource {
  late Box<dynamic> _weatherBox;
  late Box<dynamic> _searchBox;
  late Box<dynamic> _favoritesBox;

  LocalWeatherDataSourceImpl();

  /// Initialize Hive boxes
  Future<void> init() async {
    _weatherBox = await Hive.openBox('weather_cache');
    _searchBox = await Hive.openBox('search_cache');
    _favoritesBox = await Hive.openBox('favorites_cache');
  }

  @override
  Future<void> cacheWeather(WeatherResponseDto weather) async {
    try {
      final jsonString = jsonEncode({
        'latitude': weather.latitude,
        'longitude': weather.longitude,
        'timezone': weather.timezone,
        'current': {
          'temperature': weather.current.temperature,
          'apparent_temperature': weather.current.apparentTemperature,
          'relative_humidity': weather.current.relativeHumidity,
          'weather_code': weather.current.weatherCode,
          'wind_speed_10m': weather.current.windSpeed10m,
          'surface_pressure': weather.current.surfacePressure,
          'visibility': weather.current.visibility,
          'uv_index': weather.current.uvIndex,
          'time': weather.current.time.toIso8601String(),
          'is_day': weather.current.isDay ? 1 : 0,
        },
        'hourly': {
          'time': weather.hourly.times.map((t) => t.toIso8601String()).toList(),
          'temperature_2m': weather.hourly.temperatures,
          'weather_code': weather.hourly.weatherCodes,
          'wind_speed_10m': weather.hourly.windSpeeds,
        },
        'daily': {
          'time': weather.daily.dates.map((d) => d.toIso8601String()).toList(),
          'temperature_2m_max': weather.daily.maxTemperatures,
          'temperature_2m_min': weather.daily.minTemperatures,
          'weather_code': weather.daily.weatherCodes,
          'precipitation_sum': weather.daily.rainfall,
          'wind_speed_10m_max': weather.daily.windSpeeds,
          'sunrise': weather.daily.sunrises.map((s) => s.toIso8601String()).toList(),
          'sunset': weather.daily.sunsets.map((s) => s.toIso8601String()).toList(),
        },
        'timestamp': DateTime.now().toIso8601String(),
      });

      await _weatherBox.put(CacheConstants.weatherCacheKey, jsonString);
    } catch (e) {
      throw CacheFailure(message: 'Failed to cache weather data');
    }
  }

  @override
  Future<WeatherResponseDto?> getCachedWeather() async {
    try {
      final jsonString = _weatherBox.get(CacheConstants.weatherCacheKey);
      if (jsonString == null) return null;

      final json = jsonDecode(jsonString as String) as Map<String, dynamic>;
      return WeatherResponseDto.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> cacheRecentSearch({
    required String name,
    required String country,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final key = '$name-$country';
      final searches = await getRecentSearches();

      // Remove if already exists
      searches.removeWhere((s) => s['key'] == key);

      // Add new search at beginning
      searches.insert(0, {
        'key': key,
        'name': name,
        'country': country,
        'latitude': latitude,
        'longitude': longitude,
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Keep only last 10 searches
      if (searches.length > 10) {
        searches.removeRange(10, searches.length);
      }

      await _searchBox.put(CacheConstants.cityCacheKey, jsonEncode(searches));
    } catch (e) {
      throw CacheFailure(message: 'Failed to cache search');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getRecentSearches() async {
    try {
      final jsonString = _searchBox.get(CacheConstants.cityCacheKey);
      if (jsonString == null) return [];

      final list = jsonDecode(jsonString as String) as List<dynamic>;
      return list.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> clearRecentSearches() async {
    try {
      await _searchBox.delete(CacheConstants.cityCacheKey);
    } catch (e) {
      throw CacheFailure(message: 'Failed to clear recent searches');
    }
  }

  @override
  Future<void> addToFavorites({
    required String key,
    required String name,
    required String country,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final favorites = await getFavorites();
      favorites.add({
        'key': key,
        'name': name,
        'country': country,
        'latitude': latitude,
        'longitude': longitude,
        'timestamp': DateTime.now().toIso8601String(),
      });
      await _favoritesBox.put(CacheConstants.favoritesCacheKey, jsonEncode(favorites));
    } catch (e) {
      throw CacheFailure(message: 'Failed to add to favorites');
    }
  }

  @override
  Future<void> removeFromFavorites(String key) async {
    try {
      final favorites = await getFavorites();
      favorites.removeWhere((f) => f['key'] == key);
      await _favoritesBox.put(CacheConstants.favoritesCacheKey, jsonEncode(favorites));
    } catch (e) {
      throw CacheFailure(message: 'Failed to remove from favorites');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getFavorites() async {
    try {
      final jsonString = _favoritesBox.get(CacheConstants.favoritesCacheKey);
      if (jsonString == null) return [];

      final list = jsonDecode(jsonString as String) as List<dynamic>;
      return list.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await _weatherBox.clear();
      await _searchBox.clear();
      await _favoritesBox.clear();
    } catch (e) {
      throw CacheFailure(message: 'Failed to clear cache');
    }
  }
}
