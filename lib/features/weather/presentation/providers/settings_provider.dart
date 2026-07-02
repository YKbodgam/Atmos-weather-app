import 'package:flutter/material.dart';

/// Temperature units
enum TemperatureUnit { celsius, fahrenheit }

/// Wind speed units
enum WindSpeedUnit { kmh, ms, mph }

/// Pressure units
enum PressureUnit { hpa, mb }

/// Time format
enum TimeFormat { twentyFourHour, twelveHour }

/// Provider to manage app settings
class SettingsProvider extends ChangeNotifier {
  TemperatureUnit _temperatureUnit = TemperatureUnit.celsius;
  WindSpeedUnit _windSpeedUnit = WindSpeedUnit.kmh;
  PressureUnit _pressureUnit = PressureUnit.hpa;
  TimeFormat _timeFormat = TimeFormat.twentyFourHour;
  bool _useCellularData = false;
  int _refreshInterval = 30; // minutes
  bool _enableNotifications = true;
  bool _darkMode = false;

  // Getters
  TemperatureUnit get temperatureUnit => _temperatureUnit;
  WindSpeedUnit get windSpeedUnit => _windSpeedUnit;
  PressureUnit get pressureUnit => _pressureUnit;
  TimeFormat get timeFormat => _timeFormat;
  bool get useCellularData => _useCellularData;
  int get refreshInterval => _refreshInterval;
  bool get enableNotifications => _enableNotifications;
  bool get darkMode => _darkMode;

  // String getters for display
  String get temperatureUnitString {
    switch (_temperatureUnit) {
      case TemperatureUnit.celsius:
        return '°C';
      case TemperatureUnit.fahrenheit:
        return '°F';
    }
  }

  String get windSpeedUnitString {
    switch (_windSpeedUnit) {
      case WindSpeedUnit.kmh:
        return 'km/h';
      case WindSpeedUnit.ms:
        return 'm/s';
      case WindSpeedUnit.mph:
        return 'mph';
    }
  }

  String get pressureUnitString {
    switch (_pressureUnit) {
      case PressureUnit.hpa:
        return 'hPa';
      case PressureUnit.mb:
        return 'mb';
    }
  }

  // Setters
  void setTemperatureUnit(TemperatureUnit unit) {
    if (_temperatureUnit != unit) {
      _temperatureUnit = unit;
      _saveSettings();
      notifyListeners();
    }
  }

  void setWindSpeedUnit(WindSpeedUnit unit) {
    if (_windSpeedUnit != unit) {
      _windSpeedUnit = unit;
      _saveSettings();
      notifyListeners();
    }
  }

  void setPressureUnit(PressureUnit unit) {
    if (_pressureUnit != unit) {
      _pressureUnit = unit;
      _saveSettings();
      notifyListeners();
    }
  }

  void setTimeFormat(TimeFormat format) {
    if (_timeFormat != format) {
      _timeFormat = format;
      _saveSettings();
      notifyListeners();
    }
  }

  void setUseCellularData(bool value) {
    if (_useCellularData != value) {
      _useCellularData = value;
      _saveSettings();
      notifyListeners();
    }
  }

  void setRefreshInterval(int minutes) {
    if (_refreshInterval != minutes) {
      _refreshInterval = minutes;
      _saveSettings();
      notifyListeners();
    }
  }

  void setEnableNotifications(bool value) {
    if (_enableNotifications != value) {
      _enableNotifications = value;
      _saveSettings();
      notifyListeners();
    }
  }

  void setDarkMode(bool value) {
    if (_darkMode != value) {
      _darkMode = value;
      _saveSettings();
      notifyListeners();
    }
  }

  /// Save settings to local storage (implementation in future)
  void _saveSettings() {
    // TODO: Persist settings to local storage
  }

  /// Load settings from local storage (implementation in future)
  Future<void> loadSettings() async {
    // TODO: Load settings from local storage
  }

  /// Reset to defaults
  void resetToDefaults() {
    _temperatureUnit = TemperatureUnit.celsius;
    _windSpeedUnit = WindSpeedUnit.kmh;
    _pressureUnit = PressureUnit.hpa;
    _timeFormat = TimeFormat.twentyFourHour;
    _useCellularData = false;
    _refreshInterval = 30;
    _enableNotifications = true;
    _darkMode = false;
    _saveSettings();
    notifyListeners();
  }
}
