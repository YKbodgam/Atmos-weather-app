import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:provider/provider.dart';

import 'package:atmos/core/constants/constants.dart';
import 'package:atmos/features/weather/presentation/providers/weather_provider.dart';
import 'package:atmos/features/weather/presentation/widgets/common_widgets.dart';
import 'package:atmos/features/weather/presentation/widgets/weather_widgets.dart';

/// Forecast screen showing 7-day forecast
class ForecastScreen extends StatelessWidget {
  const ForecastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('7-Day Forecast'), elevation: 0),
      body: Consumer<WeatherProvider>(
        builder: (context, weatherProvider, _) {
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
              message: 'No forecast data available',
              icon: Icons.cloud_off,
            );
          }

          final daily = weatherProvider.weather!.daily;

          return Column(
            children: [
              if (weatherProvider.isOffline) const OfflineBanner(),
              Expanded(
                child: ListView.builder(
                  itemCount: (daily.dates.length < 7 ? daily.dates.length : 7),
                  itemBuilder: (context, index) {
                    return DailyForecastTile(
                      date: daily.dates[index],
                      maxTemp: daily.maxTemperatures[index],
                      minTemp: daily.minTemperatures[index],
                      weatherCode: daily.weatherCodes[index],
                      rainfall: daily.rainfall[index],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
