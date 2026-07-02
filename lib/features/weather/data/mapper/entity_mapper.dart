import '../dto/weather_dto.dart';
import '../../domain/entities/weather_entity.dart';

/// Mapper to convert DTOs to Entities
class WeatherMapper {
  /// Convert CurrentWeatherDto to CurrentWeatherEntity
  static CurrentWeatherEntity toCurrentWeatherEntity(CurrentWeatherDto dto) {
    return CurrentWeatherEntity(
      temperature: dto.temperature,
      feelsLike: dto.apparentTemperature,
      humidity: dto.relativeHumidity,
      weatherCode: dto.weatherCode,
      windSpeed: dto.windSpeed10m,
      pressure: dto.surfacePressure,
      visibility: dto.visibility / 1000, // Convert to km
      uvIndex: dto.uvIndex,
      time: dto.time,
      sunrise: DateTime.now(), // Placeholder
      sunset: DateTime.now(), // Placeholder
      isDay: dto.isDay,
    );
  }

  /// Convert HourlyWeatherDto to HourlyWeatherEntity
  static HourlyWeatherEntity toHourlyWeatherEntity(HourlyWeatherDto dto) {
    return HourlyWeatherEntity(
      times: dto.times,
      temperatures: dto.temperatures,
      weatherCodes: dto.weatherCodes,
      windSpeeds: dto.windSpeeds,
    );
  }

  /// Convert DailyWeatherDto to DailyWeatherEntity
  static DailyWeatherEntity toDailyWeatherEntity(DailyWeatherDto dto) {
    return DailyWeatherEntity(
      dates: dto.dates,
      maxTemperatures: dto.maxTemperatures,
      minTemperatures: dto.minTemperatures,
      weatherCodes: dto.weatherCodes,
      rainfall: dto.rainfall,
      windSpeeds: dto.windSpeeds.map((e) => e.toDouble()).toList(),
      sunrises: dto.sunrises,
      sunsets: dto.sunsets,
    );
  }

  /// Convert WeatherResponseDto to WeatherEntity
  static WeatherEntity toWeatherEntity(WeatherResponseDto dto) {
    return WeatherEntity(
      latitude: dto.latitude,
      longitude: dto.longitude,
      timezone: dto.timezone,
      current: toCurrentWeatherEntity(dto.current),
      hourly: toHourlyWeatherEntity(dto.hourly),
      daily: toDailyWeatherEntity(dto.daily),
      lastUpdated: DateTime.now(),
    );
  }

  /// Convert GeocodingResultDto to CityEntity
  static CityEntity toCityEntity(GeocodingResultDto dto) {
    return CityEntity(
      name: dto.name,
      country: dto.country,
      latitude: dto.latitude,
      longitude: dto.longitude,
      admin1: dto.admin1,
      population: dto.population,
    );
  }

  /// Convert list of GeocodingResultDto to list of CityEntity
  static List<CityEntity> toCityEntityList(List<GeocodingResultDto> dtos) {
    return dtos.map((dto) => toCityEntity(dto)).toList();
  }
}
