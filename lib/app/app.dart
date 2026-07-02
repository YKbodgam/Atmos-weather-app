import 'package:flutter/material.dart';

import '../features/weather/presentation/screens/bottom_nav_wrapper.dart';
import '../features/weather/presentation/screens/favorites_screen.dart';

import 'app_theme.dart';

class AtmosApp extends StatelessWidget {
  const AtmosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Atmos',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const BottomNavWrapper(),
      routes: {'/favorites': (context) => const FavoritesScreen()},
    );
  }
}
