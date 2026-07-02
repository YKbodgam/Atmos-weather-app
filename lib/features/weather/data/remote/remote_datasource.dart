import '../../../../core/constants/constants.dart';
import '../../../../core/error/failure_handler.dart';

import 'api_client.dart';
import '../dto/weather_dto.dart';

/// Abstract remote data source interface
abstract class RemoteWeatherDataSource {
  /// Fetch weather data for given coordinates
  Future<WeatherResponseDto> getWeatherByCoordinates({
    required double latitude,
    required double longitude,
  });

  /// Search cities by query
  Future<GeocodingResponseDto> searchCities({required String query});
}

/// Implementation of remote weather data source
class RemoteWeatherDataSourceImpl implements RemoteWeatherDataSource {
  final ApiClient apiClient;

  RemoteWeatherDataSourceImpl({required this.apiClient});

  @override
  Future<WeatherResponseDto> getWeatherByCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await apiClient.get(
        ApiConstants.weatherEndpoint,
        queryParameters: {
          'latitude': latitude,
          'longitude': longitude,
          'current':
              'temperature,apparent_temperature,is_day,weather_code,wind_speed_10m,relative_humidity,surface_pressure,visibility,uv_index',
          'hourly': 'temperature_2m,weather_code,wind_speed_10m',
          'daily':
              'weather_code,temperature_2m_max,temperature_2m_min,sunrise,sunset,precipitation_sum,wind_speed_10m_max',
          'timezone': 'auto',
        },
      );

      return WeatherResponseDto.fromJson(response as Map<String, dynamic>);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ParsingFailure(message: 'Failed to parse weather data');
    }
  }

  @override
  Future<GeocodingResponseDto> searchCities({required String query}) async {
    try {
      final response = await apiClient.get(
        ApiConstants.geocodingEndpoint,
        queryParameters: {
          'name': query,
          'count': 10,
          'language': 'en',
          'format': 'json',
        },
      );

      return GeocodingResponseDto.fromJson(response as Map<String, dynamic>);
    } on Failure {
      rethrow;
    } catch (e) {
      throw ParsingFailure(message: 'Failed to parse search results');
    }
  }
}
