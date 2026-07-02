import 'package:flutter/material.dart';
import 'package:atmos/core/error/failure_handler.dart';
import 'package:atmos/features/weather/domain/entities/weather_entity.dart';
import 'package:atmos/features/weather/domain/usecases/weather_usecases.dart';

/// State enum for UI
enum WeatherState { idle, loading, success, error, offline }

/// Provider to manage weather data
class WeatherProvider extends ChangeNotifier {
  final GetWeatherUseCase getWeatherUseCase;
  final GetCachedWeatherUseCase getCachedWeatherUseCase;

  // State variables
  WeatherState _state = WeatherState.idle;
  WeatherEntity? _weather;
  Failure? _failure;
  bool _isOffline = false;
  double? _currentLatitude;
  double? _currentLongitude;

  // Getters
  WeatherState get state => _state;
  WeatherEntity? get weather => _weather;
  Failure? get failure => _failure;
  bool get isOffline => _isOffline;
  bool get isLoading => _state == WeatherState.loading;
  bool get hasError => _state == WeatherState.error;
  bool get isSuccess => _state == WeatherState.success;

  WeatherProvider({
    required this.getWeatherUseCase,
    required this.getCachedWeatherUseCase,
  });

  /// Fetch weather for given coordinates
  Future<void> fetchWeather({
    required double latitude,
    required double longitude,
  }) async {
    _currentLatitude = latitude;
    _currentLongitude = longitude;
    _state = WeatherState.loading;
    _isOffline = false;
    notifyListeners();

    final result = await getWeatherUseCase(
      latitude: latitude,
      longitude: longitude,
    );

    result.fold(
      (failure) {
        if (failure is NetworkFailure) {
          _isOffline = true;
          _state = WeatherState.offline;
        } else {
          _state = WeatherState.error;
        }
        _failure = failure;
        notifyListeners();
      },
      (weather) {
        _weather = weather;
        _state = WeatherState.success;
        _isOffline = false;
        _failure = null;
        notifyListeners();
      },
    );
  }

  /// Retry fetching weather
  Future<void> retryFetch() async {
    if (_currentLatitude != null && _currentLongitude != null) {
      await fetchWeather(
        latitude: _currentLatitude!,
        longitude: _currentLongitude!,
      );
    }
  }

  /// Load cached weather
  Future<void> loadCachedWeather() async {
    _state = WeatherState.loading;
    notifyListeners();

    final cached = await getCachedWeatherUseCase();
    if (cached != null) {
      _weather = cached;
      _state = WeatherState.success;
      _isOffline = true;
    } else {
      _state = WeatherState.idle;
    }
    notifyListeners();
  }

  /// Reset state
  void reset() {
    _state = WeatherState.idle;
    _weather = null;
    _failure = null;
    _isOffline = false;
    _currentLatitude = null;
    _currentLongitude = null;
    notifyListeners();
  }
}
