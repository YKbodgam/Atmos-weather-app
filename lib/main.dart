import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app/app.dart';
import 'di/service_locator.dart';

import 'features/weather/presentation/providers/favorites_provider.dart';
import 'features/weather/presentation/providers/search_provider.dart';
import 'features/weather/presentation/providers/settings_provider.dart';
import 'features/weather/presentation/providers/weather_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupServiceLocator();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<WeatherProvider>(
          create: (_) => getIt<WeatherProvider>(),
        ),
        ChangeNotifierProvider<SearchProvider>(
          create: (_) => getIt<SearchProvider>(),
        ),
        ChangeNotifierProvider<FavoritesProvider>(
          create: (_) => getIt<FavoritesProvider>(),
        ),
        ChangeNotifierProvider<SettingsProvider>(
          create: (_) => getIt<SettingsProvider>(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(393, 852),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return const AtmosApp();
        },
      ),
    ),
  );
}
