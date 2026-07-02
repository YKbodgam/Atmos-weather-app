import 'package:equatable/equatable.dart';

/// Current weather information
class CurrentWeatherEntity extends Equatable {
  final double temperature;
  final double feelsLike;
  final int humidity;
  final int weatherCode;
  final double windSpeed;
  final double pressure;
  final double visibility;
  final int uvIndex;
  final DateTime time;
  final DateTime sunrise;
  final DateTime sunset;
  final bool isDay;

  const CurrentWeatherEntity({
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.weatherCode,
    required this.windSpeed,
    required this.pressure,
    required this.visibility,
    required this.uvIndex,
    required this.time,
    required this.sunrise,
    required this.sunset,
    required this.isDay,
  });

  @override
  List<Object?> get props => [
    temperature,
    feelsLike,
    humidity,
    weatherCode,
    windSpeed,
    pressure,
    visibility,
    uvIndex,
    time,
    sunrise,
    sunset,
    isDay,
  ];
}

/// Hourly weather data
class HourlyWeatherEntity extends Equatable {
  final List<DateTime> times;
  final List<double> temperatures;
  final List<int> weatherCodes;
  final List<double> windSpeeds;

  const HourlyWeatherEntity({
    required this.times,
    required this.temperatures,
    required this.weatherCodes,
    required this.windSpeeds,
  });

  @override
  List<Object?> get props => [times, temperatures, weatherCodes, windSpeeds];
}

/// Daily forecast data
class DailyWeatherEntity extends Equatable {
  final List<DateTime> dates;
  final List<double> maxTemperatures;
  final List<double> minTemperatures;
  final List<int> weatherCodes;
  final List<double> rainfall;
  final List<double> windSpeeds;
  final List<DateTime> sunrises;
  final List<DateTime> sunsets;

  const DailyWeatherEntity({
    required this.dates,
    required this.maxTemperatures,
    required this.minTemperatures,
    required this.weatherCodes,
    required this.rainfall,
    required this.windSpeeds,
    required this.sunrises,
    required this.sunsets,
  });

  @override
  List<Object?> get props => [
    dates,
    maxTemperatures,
    minTemperatures,
    weatherCodes,
    rainfall,
    windSpeeds,
    sunrises,
    sunsets,
  ];
}

/// Complete weather data for a location
class WeatherEntity extends Equatable {
  final double latitude;
  final double longitude;
  final String timezone;
  final CurrentWeatherEntity current;
  final HourlyWeatherEntity hourly;
  final DailyWeatherEntity daily;
  final DateTime lastUpdated;

  const WeatherEntity({
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.current,
    required this.hourly,
    required this.daily,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [
    latitude,
    longitude,
    timezone,
    current,
    hourly,
    daily,
    lastUpdated,
  ];
}

/// City information
class CityEntity extends Equatable {
  final String name;
  final String country;
  final double latitude;
  final double longitude;
  final String? admin1;
  final int? population;

  const CityEntity({
    required this.name,
    required this.country,
    required this.latitude,
    required this.longitude,
    this.admin1,
    this.population,
  });

  @override
  List<Object?> get props => [
    name,
    country,
    latitude,
    longitude,
    admin1,
    population,
  ];
}
