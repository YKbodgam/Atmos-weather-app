import 'package:flutter/material.dart';
import 'package:atmos/core/error/failure_handler.dart';
import 'package:atmos/features/weather/domain/entities/weather_entity.dart';
import 'package:atmos/features/weather/domain/usecases/weather_usecases.dart';

/// State enum for search
enum SearchState { idle, loading, success, error, empty }

/// Provider to manage city search
class SearchProvider extends ChangeNotifier {
  final SearchCitiesUseCase searchCitiesUseCase;
  final GetRecentSearchesUseCase getRecentSearchesUseCase;

  // State variables
  SearchState _state = SearchState.idle;
  List<CityEntity> _searchResults = [];
  List<CityEntity> _recentSearches = [];
  Failure? _failure;
  String _lastQuery = '';

  // Getters
  SearchState get state => _state;
  List<CityEntity> get searchResults => _searchResults;
  List<CityEntity> get recentSearches => _recentSearches;
  Failure? get failure => _failure;
  bool get isLoading => _state == SearchState.loading;
  bool get hasError => _state == SearchState.error;
  bool get isEmpty => _state == SearchState.empty;

  SearchProvider({
    required this.searchCitiesUseCase,
    required this.getRecentSearchesUseCase,
  });

  /// Search for cities
  Future<void> searchCities(String query) async {
    if (query.isEmpty) {
      _state = SearchState.empty;
      _searchResults = [];
      _failure = null;
      notifyListeners();
      return;
    }

    _lastQuery = query;
    _state = SearchState.loading;
    _failure = null;
    notifyListeners();

    final result = await searchCitiesUseCase(query: query);

    result.fold(
      (failure) {
        _state = SearchState.error;
        _failure = failure;
        _searchResults = [];
        notifyListeners();
      },
      (cities) {
        _searchResults = cities;
        _state = cities.isEmpty ? SearchState.empty : SearchState.success;
        _failure = null;
        notifyListeners();
      },
    );
  }

  /// Load recent searches
  Future<void> loadRecentSearches() async {
    _recentSearches = await getRecentSearchesUseCase();
    notifyListeners();
  }

  /// Clear search results
  void clearSearchResults() {
    _searchResults = [];
    _state = SearchState.idle;
    _lastQuery = '';
    notifyListeners();
  }

  /// Clear all
  void clearAll() {
    _searchResults = [];
    _recentSearches = [];
    _state = SearchState.idle;
    _lastQuery = '';
    _failure = null;
    notifyListeners();
  }

  /// Retry search
  Future<void> retrySearch() async {
    if (_lastQuery.isNotEmpty) {
      await searchCities(_lastQuery);
    }
  }
}
