import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/app_theme.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/extensions/extensions.dart';
import '../../domain/entities/weather_entity.dart';
import 'common_widgets.dart';

/// Current weather display section
class CurrentWeatherSection extends StatelessWidget {
  final WeatherEntity weather;

  const CurrentWeatherSection({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(AppTheme.spacing16.w),
      padding: EdgeInsets.all(AppTheme.spacing24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor.withValues(alpha: 0.1),
            Theme.of(context).primaryColor.withValues(alpha: 0.05),
          ],
        ),
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
                    weather.current.temperature.toTemperatureString(),
                    style: Theme.of(
                      context,
                    ).textTheme.displayLarge?.copyWith(fontSize: 56.sp),
                  ),
                  Text(
                    'Partly Cloudy',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(height: AppTheme.spacing8.h),
                  Text(
                    'Feels like ${weather.current.feelsLike.roundToDecimal(1)}°C',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
              Icon(
                weather.current.isDay ? Icons.wb_sunny : Icons.nights_stay,
                size: 80.sp,
                color: AppTheme.secondaryColor,
              ),
            ],
          ),
          SizedBox(height: AppTheme.spacing20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _WeatherInfoChip(
                label: UiStrings.humidity,
                value: weather.current.humidity.toPercentage,
                icon: Icons.opacity,
              ),
              _WeatherInfoChip(
                label: UiStrings.windSpeed,
                value: '${weather.current.windSpeed.toStringAsFixed(1)} km/h',
                icon: Icons.air,
              ),
              _WeatherInfoChip(
                label: UiStrings.uvIndex,
                value: '${weather.current.uvIndex} Moderate',
                icon: Icons.cloud,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Weather info chip
class _WeatherInfoChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _WeatherInfoChip({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20.sp, color: AppTheme.textSecondary),
        SizedBox(height: AppTheme.spacing4.h),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        SizedBox(height: AppTheme.spacing2.h),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

/// Weather details grid
class WeatherDetailsGrid extends StatelessWidget {
  final WeatherEntity weather;

  const WeatherDetailsGrid({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppTheme.spacing16.w),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: AppTheme.spacing12.h,
        crossAxisSpacing: AppTheme.spacing12.w,
        childAspectRatio: 1.1,
        children: [
          WeatherCard(
            label: UiStrings.pressure,
            value: '${weather.current.pressure.toStringAsFixed(0)} hPa',
            icon: Icons.badge,
          ),
          WeatherCard(
            label: UiStrings.visibility,
            value: '${(weather.current.visibility).toStringAsFixed(1)} km',
            icon: Icons.visibility,
          ),
          WeatherCard(
            label: UiStrings.sunrise,
            value: weather.daily.sunrises.first.toTimeString(),
            icon: Icons.light_mode,
          ),
          WeatherCard(
            label: UiStrings.sunset,
            value: weather.daily.sunsets.first.toTimeString(),
            icon: Icons.dark_mode,
          ),
        ],
      ),
    );
  }
}

/// Hourly forecast list
class HourlyForecastList extends StatelessWidget {
  final HourlyWeatherEntity hourlyData;

  const HourlyForecastList({super.key, required this.hourlyData});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: AppTheme.spacing16.w),
        itemCount: (hourlyData.times.length < 8 ? hourlyData.times.length : 8),
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: AppTheme.spacing12.w),
            child: HourlyForecastCard(
              time: hourlyData.times[index],
              temperature: hourlyData.temperatures[index],
              weatherCode: hourlyData.weatherCodes[index],
            ),
          );
        },
      ),
    );
  }
}

/// Hourly forecast card
class HourlyForecastCard extends StatelessWidget {
  final DateTime time;
  final double temperature;
  final int weatherCode;

  const HourlyForecastCard({
    super.key,
    required this.time,
    required this.temperature,
    required this.weatherCode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70.w,
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.spacing8.w,
        vertical: AppTheme.spacing12.h,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            time.toTimeString(),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Icon(Icons.wb_sunny, size: 24.sp, color: AppTheme.secondaryColor),
          Text(
            '${temperature.toStringAsFixed(0)}°',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

/// High/Low temperature card
class HighLowTempCard extends StatelessWidget {
  final WeatherEntity weather;

  const HighLowTempCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppTheme.spacing16.w),
      child: Container(
        padding: EdgeInsets.all(AppTheme.spacing16.w),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Today's High/Low",
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: AppTheme.spacing12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text('High', style: Theme.of(context).textTheme.bodySmall),
                    SizedBox(height: AppTheme.spacing4.h),
                    Text(
                      weather.daily.maxTemperatures.first.toTemperatureString(),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                const VerticalDivider(indent: 10, endIndent: 10),
                Column(
                  children: [
                    Text('Low', style: Theme.of(context).textTheme.bodySmall),
                    SizedBox(height: AppTheme.spacing4.h),
                    Text(
                      weather.daily.minTemperatures.first.toTemperatureString(),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Daily forecast tile
class DailyForecastTile extends StatelessWidget {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final int weatherCode;
  final double rainfall;

  const DailyForecastTile({
    super.key,
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.weatherCode,
    required this.rainfall,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppTheme.spacing16.w,
        vertical: AppTheme.spacing8.h,
      ),
      padding: EdgeInsets.all(AppTheme.spacing12.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date.toDayName(),
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                date.toDateString(),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary),
              ),
            ],
          ),
          Icon(Icons.wb_sunny, color: AppTheme.secondaryColor),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${maxTemp.toStringAsFixed(0)}°',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                '${minTemp.toStringAsFixed(0)}°',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
