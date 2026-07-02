/// API Constants
class ApiConstants {
  static const String baseUrl = 'https://api.open-meteo.com/v1';
  static const String weatherEndpoint = '/forecast';
  static const String geocodingEndpoint = '/search';
  static const int connectTimeout = 15000; // ms
  static const int receiveTimeout = 15000; // ms
}

/// Cache Constants
class CacheConstants {
  static const String weatherCacheKey = 'weather_cache';
  static const String forecastCacheKey = 'forecast_cache';
  static const String cityCacheKey = 'city_cache';
  static const String favoritesCacheKey = 'favorites_cache';
  static const String settingsCacheKey = 'settings_cache';
  static const int cacheDurationMinutes = 30;
}

/// App Constants
class AppConstants {
  static const String appName = 'Atmos';
  static const String appVersion = '1.0.0';
  static const double defaultLatitude = 23.0225;
  static const double defaultLongitude = 72.5714;
  static const String defaultCity = 'Ahmedabad';
  static const String defaultCountry = 'India';
}

/// Duration Constants
class DurationConstants {
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration shortDelay = Duration(milliseconds: 500);
  static const Duration mediumDelay = Duration(milliseconds: 1000);
  static const Duration refreshInterval = Duration(minutes: 30);
}

/// String Constants for UI
class UiStrings {
  // Common
  static const String loading = 'Loading...';
  static const String error = 'Something went wrong';
  static const String retry = 'Try Again';
  static const String cancel = 'Cancel';
  static const String ok = 'OK';
  static const String add = 'Add';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String save = 'Save';
  
  // Weather related
  static const String currentWeather = 'Current Weather';
  static const String forecast = 'Forecast';
  static const String feelsLike = 'Feels Like';
  static const String humidity = 'Humidity';
  static const String windSpeed = 'Wind Speed';
  static const String pressure = 'Pressure';
  static const String visibility = 'Visibility';
  static const String uvIndex = 'UV Index';
  static const String sunrise = 'Sunrise';
  static const String sunset = 'Sunset';
  static const String airQuality = 'Air Quality';
  static const String today = 'Today';
  static const String tomorrow = 'Tomorrow';
  
  // Search
  static const String searchCity = 'Search City';
  static const String searchHint = 'Search for any city';
  static const String recentSearches = 'Recent Searches';
  static const String noResults = 'No results found';
  
  // Offline
  static const String offline = 'You are offline';
  static const String showingCachedData = 'Showing cached data';
  static const String checkConnection = 'Check Connection';
  
  // Settings
  static const String settings = 'Settings';
  static const String preferences = 'Preferences';
  static const String temperature = 'Temperature Unit';
  static const String windSpeedUnit = 'Wind Speed Unit';
  static const String pressureUnit = 'Pressure Unit';
  static const String timeFormat = 'Time Format';
  static const String about = 'About';
  static const String version = 'Version';
  
  // Favorites
  static const String favorites = 'Favorites';
  static const String addToFavorites = 'Add to Favorites';
  static const String removeFromFavorites = 'Remove from Favorites';
  static const String noFavorites = 'No favorites yet';
}
