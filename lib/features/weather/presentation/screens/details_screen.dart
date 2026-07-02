import 'package:intl/intl.dart';
import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/app_theme.dart';
import '../../../../core/constants/constants.dart';
import '../../domain/entities/weather_entity.dart';
import '../providers/settings_provider.dart';
import '../providers/weather_provider.dart';
import '../widgets/common_widgets.dart';

/// Weather details screen showing comprehensive metrics
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

          return Column(
            children: [
              if (weatherProvider.isOffline) const OfflineBanner(),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(AppTheme.spacing16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Current Temperature
                      _buildCurrentSection(context, current, settingsProvider),
                      SizedBox(height: AppTheme.spacing24.h),

                      // Key Metrics Grid
                      _buildMetricsGrid(context, current, settingsProvider),
                      SizedBox(height: AppTheme.spacing24.h),

                      // Sun Times
                      _buildSunTimes(context, current),
                      SizedBox(height: AppTheme.spacing24.h),

                      // Hourly Forecast
                      _buildHourlyForecast(context, hourly, settingsProvider),
                      SizedBox(height: AppTheme.spacing32.h),
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
    CurrentWeatherEntity current,
    SettingsProvider settings,
  ) {
    final tempUnit = settings.temperatureUnit == TemperatureUnit.celsius
        ? '°C'
        : '°F';
    final temp = settings.temperatureUnit == TemperatureUnit.celsius
        ? current.temperature.toStringAsFixed(1)
        : ((current.temperature * 9 / 5) + 32).toStringAsFixed(1);
    final feelsLike = settings.temperatureUnit == TemperatureUnit.celsius
        ? current.feelsLike.toStringAsFixed(1)
        : ((current.feelsLike * 9 / 5) + 32).toStringAsFixed(1);

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
                        '$temp$tempUnit',
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: AppTheme.spacing4.h),
                      Text(
                        'Feels like $feelsLike$tempUnit',
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
            ],
          ),
        ),
      ],
    );
  }

  /// Metrics grid
  Widget _buildMetricsGrid(
    BuildContext context,
    CurrentWeatherEntity current,
    SettingsProvider settings,
  ) {
    final windSpeedStr = _formatWindSpeed(
      current.windSpeed,
      settings.windSpeedUnit,
    );
    final pressureStr = settings.pressureUnit == PressureUnit.hpa
        ? '${current.pressure.toStringAsFixed(1)} hPa'
        : '${current.pressure.toStringAsFixed(1)} mb';

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
              '${current.humidity}%',
              Icons.opacity,
            ),
            _buildMetricCard(context, 'Wind Speed', windSpeedStr, Icons.air),
            _buildMetricCard(context, 'Pressure', pressureStr, Icons.compress),
            _buildMetricCard(
              context,
              'Visibility',
              '${(current.visibility / 1000).toStringAsFixed(1)} km',
              Icons.visibility,
            ),
          ],
        ),
      ],
    );
  }

  /// Sun times section
  Widget _buildSunTimes(BuildContext context, CurrentWeatherEntity current) {
    final timeFormat24h = DateFormat('HH:mm');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Sun Times', style: Theme.of(context).textTheme.headlineSmall),
        SizedBox(height: AppTheme.spacing12.h),
        Row(
          children: [
            Expanded(
              child: _buildSunInfoCard(
                context,
                'Sunrise',
                timeFormat24h.format(current.sunrise),
                Icons.sunny,
              ),
            ),
            SizedBox(width: AppTheme.spacing12.w),
            Expanded(
              child: _buildSunInfoCard(
                context,
                'Sunset',
                timeFormat24h.format(current.sunset),
                Icons.dark_mode,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Hourly forecast preview
  Widget _buildHourlyForecast(
    BuildContext context,
    HourlyWeatherEntity hourly,
    SettingsProvider settings,
  ) {
    final count = hourly.times.length < 12 ? hourly.times.length : 12;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hourly Forecast (Next $count Hours)',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        SizedBox(height: AppTheme.spacing12.h),
        SizedBox(
          height: 100.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: count,
            itemBuilder: (context, index) {
              final temp = settings.temperatureUnit == TemperatureUnit.celsius
                  ? hourly.temperatures[index].toStringAsFixed(0)
                  : ((hourly.temperatures[index] * 9 / 5) + 32).toStringAsFixed(
                      0,
                    );

              return Padding(
                padding: EdgeInsets.only(right: AppTheme.spacing12.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${hourly.times[index].hour.toString().padLeft(2, '0')}:00',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    SizedBox(height: AppTheme.spacing8.h),
                    Icon(
                      _getWeatherIcon(hourly.weatherCodes[index]),
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
    return Container(
      padding: EdgeInsets.all(AppTheme.spacing16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 28.sp, color: Theme.of(context).primaryColor),
          SizedBox(height: AppTheme.spacing8.h),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppTheme.spacing4.h),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
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
        border: Border.all(color: Theme.of(context).dividerColor),
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

  /// Format wind speed based on unit
  String _formatWindSpeed(double kmh, WindSpeedUnit unit) {
    switch (unit) {
      case WindSpeedUnit.kmh:
        return '${kmh.toStringAsFixed(1)} km/h';
      case WindSpeedUnit.ms:
        return '${(kmh / 3.6).toStringAsFixed(1)} m/s';
      case WindSpeedUnit.mph:
        return '${(kmh / 1.60934).toStringAsFixed(1)} mph';
    }
  }

  /// Get weather icon based on code
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
    } else if ((weatherCode >= 80 && weatherCode <= 82) ||
        (weatherCode >= 85 && weatherCode <= 86)) {
      return Icons.grain;
    } else if (weatherCode >= 90 && weatherCode <= 99) {
      return Icons.thunderstorm;
    }
    return Icons.cloud;
  }
}
