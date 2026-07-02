import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/app_theme.dart';
import '../../../../core/constants/constants.dart';

import '../providers/weather_provider.dart';
import '../widgets/common_widgets.dart';
import '../widgets/weather_widgets.dart';

/// Home screen showing current weather
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final weatherProvider = Provider.of<WeatherProvider>(
        context,
        listen: false,
      );
      weatherProvider.fetchWeather(
        latitude: AppConstants.defaultLatitude,
        longitude: AppConstants.defaultLongitude,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppConstants.defaultCity,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              AppConstants.defaultCountry,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed('/search'),
            icon: const Icon(Icons.search),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'settings') {
                Navigator.of(context).pushNamed('/settings');
              } else if (value == 'favorites') {
                Navigator.of(context).pushNamed('/favorites');
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(value: 'favorites', child: Text('Favorites')),
              const PopupMenuItem(value: 'settings', child: Text('Settings')),
            ],
          ),
        ],
      ),
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
              message: 'Please try again later',
              icon: Icons.cloud_off,
            );
          }

          return Column(
            children: [
              if (weatherProvider.isOffline) const OfflineBanner(),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => weatherProvider.refreshWeather(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        // Current weather display
                        CurrentWeatherSection(
                          weather: weatherProvider.weather!,
                        ),
                        SizedBox(height: AppTheme.spacing20.h),

                        // Weather details grid
                        WeatherDetailsGrid(weather: weatherProvider.weather!),
                        SizedBox(height: AppTheme.spacing20.h),

                        // Hourly forecast
                        SectionHeader(title: UiStrings.today),
                        HourlyForecastList(
                          hourlyData: weatherProvider.weather!.hourly,
                        ),
                        SizedBox(height: AppTheme.spacing20.h),

                        // High/Low temperatures
                        HighLowTempCard(weather: weatherProvider.weather!),
                        SizedBox(height: AppTheme.spacing32.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
