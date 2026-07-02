/// DTO for current weather from API
class CurrentWeatherDto {
  final double temperature;
  final double apparentTemperature;
  final int relativeHumidity;
  final int weatherCode;
  final double windSpeed10m;
  final double surfacePressure;
  final double visibility;
  final int uvIndex;
  final DateTime time;
  final bool isDay;

  CurrentWeatherDto({
    required this.temperature,
    required this.apparentTemperature,
    required this.relativeHumidity,
    required this.weatherCode,
    required this.windSpeed10m,
    required this.surfacePressure,
    required this.visibility,
    required this.uvIndex,
    required this.time,
    required this.isDay,
  });

  factory CurrentWeatherDto.fromJson(Map<String, dynamic> json) {
    return CurrentWeatherDto(
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0.0,
      apparentTemperature: (json['apparent_temperature'] as num?)?.toDouble() ?? 0.0,
      relativeHumidity: (json['relative_humidity'] as num?)?.toInt() ?? 0,
      weatherCode: (json['weather_code'] as num?)?.toInt() ?? 0,
      windSpeed10m: (json['wind_speed_10m'] as num?)?.toDouble() ?? 0.0,
      surfacePressure: (json['surface_pressure'] as num?)?.toDouble() ?? 0.0,
      visibility: (json['visibility'] as num?)?.toDouble() ?? 10000,
      uvIndex: (json['uv_index'] as num?)?.toInt() ?? 0,
      time: DateTime.parse(json['time'] as String? ?? DateTime.now().toString()),
      isDay: (json['is_day'] as num?)?.toInt() == 1,
    );
  }
}

/// DTO for hourly weather data
class HourlyWeatherDto {
  final List<DateTime> times;
  final List<double> temperatures;
  final List<int> weatherCodes;
  final List<double> windSpeeds;

  HourlyWeatherDto({
    required this.times,
    required this.temperatures,
    required this.weatherCodes,
    required this.windSpeeds,
  });

  factory HourlyWeatherDto.fromJson(Map<String, dynamic> json) {
    final timeStrings = (json['time'] as List<dynamic>?)?.cast<String>() ?? [];
    final temps = (json['temperature_2m'] as List<dynamic>?)?.map((e) => (e as num).toDouble()).toList() ?? [];
    final codes = (json['weather_code'] as List<dynamic>?)?.map((e) => (e as num).toInt()).toList() ?? [];
    final winds = (json['wind_speed_10m'] as List<dynamic>?)?.map((e) => (e as num).toDouble()).toList() ?? [];

    return HourlyWeatherDto(
      times: timeStrings.map((t) => DateTime.parse(t)).toList(),
      temperatures: temps,
      weatherCodes: codes,
      windSpeeds: winds,
    );
  }
}

/// DTO for daily weather data
class DailyWeatherDto {
  final List<DateTime> dates;
  final List<double> maxTemperatures;
  final List<double> minTemperatures;
  final List<int> weatherCodes;
  final List<double> rainfall;
  final List<int> windSpeeds;
  final List<DateTime> sunrises;
  final List<DateTime> sunsets;

  DailyWeatherDto({
    required this.dates,
    required this.maxTemperatures,
    required this.minTemperatures,
    required this.weatherCodes,
    required this.rainfall,
    required this.windSpeeds,
    required this.sunrises,
    required this.sunsets,
  });

  factory DailyWeatherDto.fromJson(Map<String, dynamic> json) {
    final dateStrings = (json['time'] as List<dynamic>?)?.cast<String>() ?? [];
    final maxTemps = (json['temperature_2m_max'] as List<dynamic>?)?.map((e) => (e as num).toDouble()).toList() ?? [];
    final minTemps = (json['temperature_2m_min'] as List<dynamic>?)?.map((e) => (e as num).toDouble()).toList() ?? [];
    final codes = (json['weather_code'] as List<dynamic>?)?.map((e) => (e as num).toInt()).toList() ?? [];
    final rains = (json['precipitation_sum'] as List<dynamic>?)?.map((e) => (e as num).toDouble()).toList() ?? [];
    final winds = (json['wind_speed_10m_max'] as List<dynamic>?)?.map((e) => (e as num).toInt()).toList() ?? [];
    final sunriseStrings = (json['sunrise'] as List<dynamic>?)?.cast<String>() ?? [];
    final sunsetStrings = (json['sunset'] as List<dynamic>?)?.cast<String>() ?? [];

    return DailyWeatherDto(
      dates: dateStrings.map((d) => DateTime.parse(d)).toList(),
      maxTemperatures: maxTemps,
      minTemperatures: minTemps,
      weatherCodes: codes,
      rainfall: rains,
      windSpeeds: winds,
      sunrises: sunriseStrings.map((s) => DateTime.parse(s)).toList(),
      sunsets: sunsetStrings.map((s) => DateTime.parse(s)).toList(),
    );
  }
}

/// DTO for complete weather response
class WeatherResponseDto {
  final double latitude;
  final double longitude;
  final String timezone;
  final CurrentWeatherDto current;
  final HourlyWeatherDto hourly;
  final DailyWeatherDto daily;

  WeatherResponseDto({
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.current,
    required this.hourly,
    required this.daily,
  });

  factory WeatherResponseDto.fromJson(Map<String, dynamic> json) {
    return WeatherResponseDto(
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      timezone: json['timezone'] as String? ?? 'UTC',
      current: CurrentWeatherDto.fromJson(json['current'] as Map<String, dynamic>? ?? {}),
      hourly: HourlyWeatherDto.fromJson(json['hourly'] as Map<String, dynamic>? ?? {}),
      daily: DailyWeatherDto.fromJson(json['daily'] as Map<String, dynamic>? ?? {}),
    );
  }
}

/// DTO for geocoding search results
class GeocodingResultDto {
  final String name;
  final String country;
  final double latitude;
  final double longitude;
  final String? admin1;
  final int? population;

  GeocodingResultDto({
    required this.name,
    required this.country,
    required this.latitude,
    required this.longitude,
    this.admin1,
    this.population,
  });

  factory GeocodingResultDto.fromJson(Map<String, dynamic> json) {
    return GeocodingResultDto(
      name: json['name'] as String? ?? 'Unknown',
      country: json['country'] as String? ?? 'Unknown',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      admin1: json['admin1'] as String?,
      population: json['population'] as int?,
    );
  }
}

/// DTO for geocoding response
class GeocodingResponseDto {
  final List<GeocodingResultDto> results;

  GeocodingResponseDto({required this.results});

  factory GeocodingResponseDto.fromJson(Map<String, dynamic> json) {
    final resultsList = (json['results'] as List<dynamic>?)
        ?.map((e) => GeocodingResultDto.fromJson(e as Map<String, dynamic>))
        .toList() ?? [];

    return GeocodingResponseDto(results: resultsList);
  }
}
