import 'package:flutter/material.dart';

import '../../domain/entities/weather_entity.dart';
import '../../domain/usecases/weather_usecases.dart';

/// Provider to manage favorite cities
class FavoritesProvider extends ChangeNotifier {
  final AddToFavoritesUseCase addToFavoritesUseCase;
  final RemoveFromFavoritesUseCase removeFromFavoritesUseCase;
  final GetFavoritesUseCase getFavoritesUseCase;

  // State variables
  List<CityEntity> _favorites = [];
  bool _isLoading = false;

  // Getters
  List<CityEntity> get favorites => _favorites;
  bool get isLoading => _isLoading;
  bool get isEmpty => _favorites.isEmpty;

  FavoritesProvider({
    required this.addToFavoritesUseCase,
    required this.removeFromFavoritesUseCase,
    required this.getFavoritesUseCase,
  });

  /// Load favorites
  Future<void> loadFavorites() async {
    _isLoading = true;
    notifyListeners();

    _favorites = await getFavoritesUseCase();

    _isLoading = false;
    notifyListeners();
  }

  /// Add city to favorites
  Future<void> addFavorite(CityEntity city) async {
    try {
      await addToFavoritesUseCase(city);
      _favorites.add(city);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  /// Remove city from favorites
  Future<void> removeFavorite(String cityKey) async {
    try {
      await removeFromFavoritesUseCase(cityKey);
      _favorites.removeWhere(
        (city) => '${city.name}-${city.country}' == cityKey,
      );
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  /// Check if city is favorite
  bool isFavorite(CityEntity city) {
    return _favorites.any(
      (fav) => fav.name == city.name && fav.country == city.country,
    );
  }

  /// Toggle favorite
  Future<void> toggleFavorite(CityEntity city) async {
    if (isFavorite(city)) {
      await removeFavorite('${city.name}-${city.country}');
    } else {
      await addFavorite(city);
    }
  }

  /// Clear favorites
  Future<void> clearFavorites() async {
    _favorites = [];
    notifyListeners();
  }
}
