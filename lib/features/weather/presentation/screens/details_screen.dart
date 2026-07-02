import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/app_theme.dart';
import '../../../../core/constants/constants.dart';

import '../providers/settings_provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/common_widgets.dart';

/// Weather details screen showing all metrics
class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather Details'), elevation: 0),
      body: Consumer2<WeatherProvider, SettingsProvider>(
        builder: (context, weatherProvider, settingsProvider, _) {
          if (weatherProvider.isLoading) {
            return const LoadingWidget(message: UiStrings.loading);
          }

          if (weatherProvider.hasError && weatherProvider.weather == null) {
            return ErrorWidget(
              message: weatherProvider.failure?.message ?? UiStrings.error,
              onRetry: () => weatherProvider.retryFetch(),
            );
          }

          if (weatherProvider.weather == null) {
            return EmptyStateWidget(
              title: 'No Data',
              message: 'No weather details available',
              icon: Icons.cloud_off,
            );
          }

          final weather = weatherProvider.weather!;
          final current = weather.current;
          final hourly = weather.hourly;
          final daily = weather.daily;

          return Column(
            children: [
              if (weatherProvider.isOffline) const OfflineBanner(),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(AppTheme.spacing16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Current Temperature Section
                      _buildCurrentSection(context, current, settingsProvider),
                      SizedBox(height: AppTheme.spacing24.h),

                      // Primary Metrics Grid
                      _buildMetricsGrid(context, current, settingsProvider),
                      SizedBox(height: AppTheme.spacing24.h),

                      // Advanced Metrics
                      _buildAdvancedMetrics(context, current, settingsProvider),
                      SizedBox(height: AppTheme.spacing24.h),

                      // Sunrise & Sunset
                      if (daily.sunrises.isNotEmpty)
                        _buildSunriseSunset(context, daily, settingsProvider),
                      SizedBox(height: AppTheme.spacing24.h),

                      // Hourly Forecast Preview
                      _buildHourlyPreview(context, hourly, settingsProvider),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Current weather section
  Widget _buildCurrentSection(
    BuildContext context,
    CurrentWeather current,
    SettingsProvider settings,
  ) {
    final temp = _convertTemperature(
      current.temperature,
      settings.temperatureUnit,
    );
    final feelsLike = _convertTemperature(
      current.feelsLike,
      settings.temperatureUnit,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Current Conditions',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        SizedBox(height: AppTheme.spacing12.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(AppTheme.spacing20.w),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
            border: Border.all(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$temp${settings.temperatureUnitString}',
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: AppTheme.spacing4.h),
                      Text(
                        'Feels like $feelsLike${settings.temperatureUnitString}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  Icon(
                    _getWeatherIcon(current.weatherCode),
                    size: 64.sp,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
              SizedBox(height: AppTheme.spacing12.h),
              Text(
                current.weatherDescription,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Metrics grid (humidity, wind, pressure, visibility)
  Widget _buildMetricsGrid(
    BuildContext context,
    CurrentWeather current,
    SettingsProvider settings,
  ) {
    final windSpeed = _convertWindSpeed(
      current.windSpeed10m,
      settings.windSpeedUnit,
    );
    final pressure = _convertPressure(
      current.surfacePressure,
      settings.pressureUnit,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Key Metrics', style: Theme.of(context).textTheme.headlineSmall),
        SizedBox(height: AppTheme.spacing12.h),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: AppTheme.spacing12.w,
          mainAxisSpacing: AppTheme.spacing12.h,
          children: [
            _buildMetricCard(
              context,
              'Humidity',
              '${current.relativeHumidity2m.toStringAsFixed(0)}%',
              Icons.opacity,
            ),
            _buildMetricCard(
              context,
              'Wind Speed',
              '$windSpeed ${settings.windSpeedUnitString}',
              Icons.air,
            ),
            _buildMetricCard(
              context,
              'Pressure',
              '$pressure ${settings.pressureUnitString}',
              Icons.compress,
            ),
            _buildMetricCard(
              context,
              'Visibility',
              '${current.visibility.toStringAsFixed(1)} km',
              Icons.visibility,
            ),
          ],
        ),
      ],
    );
  }

  /// Advanced metrics section
  Widget _buildAdvancedMetrics(
    BuildContext context,
    CurrentWeather current,
    SettingsProvider settings,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Additional Information',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        SizedBox(height: AppTheme.spacing12.h),
        _buildMetricsList(context, [
          (
            'Cloud Coverage',
            '${current.cloudCover.toStringAsFixed(0)}%',
            Icons.cloud,
          ),
          ('UV Index', '${current.uvIndex.toStringAsFixed(1)}', Icons.wb_sunny),
          (
            'Wind Direction',
            '${current.windDirection10m.toStringAsFixed(0)}°',
            Icons.north,
          ),
          (
            'Dew Point',
            '${_convertTemperature(current.dewPoint2m, settings.temperatureUnit).toStringAsFixed(1)}${settings.temperatureUnitString}',
            Icons.water_drop,
          ),
        ]),
      ],
    );
  }

  /// Sunrise and sunset section
  Widget _buildSunriseSunset(
    BuildContext context,
    DailyWeather daily,
    SettingsProvider settings,
  ) {
    final sunrise = daily.sunrise[0];
    final sunset = daily.sunset[0];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sun Information',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        SizedBox(height: AppTheme.spacing12.h),
        Row(
          children: [
            Expanded(
              child: _buildSunInfoCard(
                context,
                'Sunrise',
                sunrise.formatTime(settings.timeFormat),
                Icons.sunny,
              ),
            ),
            SizedBox(width: AppTheme.spacing12.w),
            Expanded(
              child: _buildSunInfoCard(
                context,
                'Sunset',
                sunset.formatTime(settings.timeFormat),
                Icons.dark_mode,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Hourly forecast preview
  Widget _buildHourlyPreview(
    BuildContext context,
    HourlyWeather hourly,
    SettingsProvider settings,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hourly Forecast (Next 12 Hours)',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        SizedBox(height: AppTheme.spacing12.h),
        SizedBox(
          height: 100.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: (hourly.times.length < 12 ? hourly.times.length : 12),
            itemBuilder: (context, index) {
              final temp = _convertTemperature(
                hourly.temperatures[index],
                settings.temperatureUnit,
              );
              return Padding(
                padding: EdgeInsets.only(right: AppTheme.spacing12.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      hourly.times[index].formatTime(settings.timeFormat),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    SizedBox(height: AppTheme.spacing8.h),
                    Icon(
                      _getWeatherIcon(hourly.weatherCode[index]),
                      size: 24.sp,
                    ),
                    SizedBox(height: AppTheme.spacing8.h),
                    Text(
                      '$temp°',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Build metric card
  Widget _buildMetricCard(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return MetricCard(
      label: label,
      value: value,
      icon: icon,
      backgroundColor: Theme.of(context).cardColor,
    );
  }

  /// Build metrics list
  Widget _buildMetricsList(
    BuildContext context,
    List<(String, String, IconData)> metrics,
  ) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: metrics.length,
      separatorBuilder: (_, _) => CustomDivider(height: 1),
      itemBuilder: (context, index) {
        final (label, value, icon) = metrics[index];
        return Padding(
          padding: EdgeInsets.symmetric(vertical: AppTheme.spacing12.h),
          child: Row(
            children: [
              Icon(icon, size: 20.sp, color: Theme.of(context).primaryColor),
              SizedBox(width: AppTheme.spacing12.w),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Text(
                value,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Build sun info card
  Widget _buildSunInfoCard(
    BuildContext context,
    String label,
    String time,
    IconData icon,
  ) {
    return Container(
      padding: EdgeInsets.all(AppTheme.spacing16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 24.sp, color: Theme.of(context).primaryColor),
          SizedBox(height: AppTheme.spacing8.h),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          SizedBox(height: AppTheme.spacing4.h),
          Text(
            time,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  // Helper methods for conversions
  double _convertTemperature(double celsius, TemperatureUnit unit) {
    if (unit == TemperatureUnit.fahrenheit) {
      return (celsius * 9 / 5) + 32;
    }
    return celsius;
  }

  double _convertWindSpeed(double kmh, WindSpeedUnit unit) {
    switch (unit) {
      case WindSpeedUnit.kmh:
        return kmh;
      case WindSpeedUnit.ms:
        return kmh / 3.6;
      case WindSpeedUnit.mph:
        return kmh / 1.60934;
    }
  }

  double _convertPressure(double hpa, PressureUnit unit) {
    if (unit == PressureUnit.mb) {
      return hpa;
    }
    return hpa;
  }

  IconData _getWeatherIcon(int weatherCode) {
    if (weatherCode == 0 || weatherCode == 1) {
      return Icons.wb_sunny;
    } else if (weatherCode == 2 || weatherCode == 3) {
      return Icons.wb_cloudy;
    } else if (weatherCode == 45 || weatherCode == 48) {
      return Icons.cloud;
    } else if (weatherCode >= 51 && weatherCode <= 67) {
      return Icons.cloud_queue;
    } else if (weatherCode >= 71 && weatherCode <= 77) {
      return Icons.ac_unit;
    } else if (weatherCode >= 80 && weatherCode <= 82) {
      return Icons.grain;
    } else if (weatherCode >= 85 && weatherCode <= 86) {
      return Icons.ac_unit;
    } else if (weatherCode == 80 || weatherCode == 81 || weatherCode == 82) {
      return Icons.cloud_queue;
    } else if (weatherCode >= 90 && weatherCode <= 99) {
      return Icons.thunderstorm;
    }
    return Icons.cloud;
  }
}
