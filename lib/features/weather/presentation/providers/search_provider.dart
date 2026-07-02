import 'dart:async';
import 'package:flutter/material.dart';

import '../../../../core/error/failure_handler.dart';
import '../../domain/entities/weather_entity.dart';
import '../../domain/usecases/weather_usecases.dart';

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

  // Debounce timer
  Timer? _debounceTimer;
  static const Duration _debounceDuration = Duration(milliseconds: 500);

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

  /// Search for cities with debounce
  void searchCitiesDebounced(String query) {
    // Cancel previous timer
    _debounceTimer?.cancel();

    if (query.trim().isEmpty) {
      _state = SearchState.idle;
      _searchResults = [];
      _failure = null;
      notifyListeners();
      return;
    }

    // Set loading state immediately
    _state = SearchState.loading;
    _lastQuery = query;
    notifyListeners();

    // Debounce the actual search
    _debounceTimer = Timer(_debounceDuration, () {
      _performSearch(query);
    });
  }

  /// Perform the actual search (called after debounce)
  Future<void> _performSearch(String query) async {
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

  /// Search for cities without debounce (for manual search)
  Future<void> searchCities(String query) async {
    _debounceTimer?.cancel();

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

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
