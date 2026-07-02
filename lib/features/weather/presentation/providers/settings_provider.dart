import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

/// Temperature units
enum TemperatureUnit { celsius, fahrenheit }

/// Wind speed units
enum WindSpeedUnit { kmh, ms, mph }

/// Pressure units
enum PressureUnit { hpa, mb }

/// Time format
enum TimeFormat { twentyFourHour, twelveHour }

/// Constants for Hive storage
class _SettingsKeys {
  static const String boxName = 'settings';
  static const String tempUnit = 'temp_unit';
  static const String windUnit = 'wind_unit';
  static const String pressureUnit = 'pressure_unit';
  static const String timeFormat = 'time_format';
  static const String useCellular = 'use_cellular';
  static const String refreshInterval = 'refresh_interval';
  static const String enableNotifications = 'enable_notifications';
  static const String darkMode = 'dark_mode';
}

/// Provider to manage app settings
class SettingsProvider extends ChangeNotifier {
  late Box<dynamic> _settingsBox;
  TemperatureUnit _temperatureUnit = TemperatureUnit.celsius;
  WindSpeedUnit _windSpeedUnit = WindSpeedUnit.kmh;
  PressureUnit _pressureUnit = PressureUnit.hpa;
  TimeFormat _timeFormat = TimeFormat.twentyFourHour;
  bool _useCellularData = false;
  int _refreshInterval = 30; // minutes
  bool _enableNotifications = true;
  bool _darkMode = false;

  SettingsProvider() {
    _initializeBox();
  }

  /// Initialize Hive box
  Future<void> _initializeBox() async {
    try {
      if (!Hive.isBoxOpen(_SettingsKeys.boxName)) {
        _settingsBox = await Hive.openBox<dynamic>(_SettingsKeys.boxName);
      } else {
        _settingsBox = Hive.box<dynamic>(_SettingsKeys.boxName);
      }
      await loadSettings();
    } catch (e) {
      debugPrint('Error initializing settings box: $e');
    }
  }

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
  Future<void> setTemperatureUnit(TemperatureUnit unit) async {
    if (_temperatureUnit != unit) {
      _temperatureUnit = unit;
      await _saveSettings();
      notifyListeners();
    }
  }

  Future<void> setWindSpeedUnit(WindSpeedUnit unit) async {
    if (_windSpeedUnit != unit) {
      _windSpeedUnit = unit;
      await _saveSettings();
      notifyListeners();
    }
  }

  Future<void> setPressureUnit(PressureUnit unit) async {
    if (_pressureUnit != unit) {
      _pressureUnit = unit;
      await _saveSettings();
      notifyListeners();
    }
  }

  Future<void> setTimeFormat(TimeFormat format) async {
    if (_timeFormat != format) {
      _timeFormat = format;
      await _saveSettings();
      notifyListeners();
    }
  }

  Future<void> setUseCellularData(bool value) async {
    if (_useCellularData != value) {
      _useCellularData = value;
      await _saveSettings();
      notifyListeners();
    }
  }

  Future<void> setRefreshInterval(int minutes) async {
    if (_refreshInterval != minutes) {
      _refreshInterval = minutes;
      await _saveSettings();
      notifyListeners();
    }
  }

  Future<void> setEnableNotifications(bool value) async {
    if (_enableNotifications != value) {
      _enableNotifications = value;
      await _saveSettings();
      notifyListeners();
    }
  }

  Future<void> setDarkMode(bool value) async {
    if (_darkMode != value) {
      _darkMode = value;
      await _saveSettings();
      notifyListeners();
    }
  }

  /// Save settings to local storage
  Future<void> _saveSettings() async {
    try {
      if (!_settingsBox.isOpen) return;

      await _settingsBox.put(_SettingsKeys.tempUnit, _temperatureUnit.index);
      await _settingsBox.put(_SettingsKeys.windUnit, _windSpeedUnit.index);
      await _settingsBox.put(_SettingsKeys.pressureUnit, _pressureUnit.index);
      await _settingsBox.put(_SettingsKeys.timeFormat, _timeFormat.index);
      await _settingsBox.put(_SettingsKeys.useCellular, _useCellularData);
      await _settingsBox.put(_SettingsKeys.refreshInterval, _refreshInterval);
      await _settingsBox.put(
        _SettingsKeys.enableNotifications,
        _enableNotifications,
      );
      await _settingsBox.put(_SettingsKeys.darkMode, _darkMode);
    } catch (e) {
      debugPrint('Error saving settings: $e');
    }
  }

  /// Load settings from local storage
  Future<void> loadSettings() async {
    try {
      if (!_settingsBox.isOpen) return;

      final tempUnitIndex = _settingsBox.get(
        _SettingsKeys.tempUnit,
        defaultValue: 0,
      );
      final windUnitIndex = _settingsBox.get(
        _SettingsKeys.windUnit,
        defaultValue: 0,
      );
      final pressureUnitIndex = _settingsBox.get(
        _SettingsKeys.pressureUnit,
        defaultValue: 0,
      );
      final timeFormatIndex = _settingsBox.get(
        _SettingsKeys.timeFormat,
        defaultValue: 0,
      );

      _temperatureUnit = TemperatureUnit.values[tempUnitIndex ?? 0];
      _windSpeedUnit = WindSpeedUnit.values[windUnitIndex ?? 0];
      _pressureUnit = PressureUnit.values[pressureUnitIndex ?? 0];
      _timeFormat = TimeFormat.values[timeFormatIndex ?? 0];
      _useCellularData =
          _settingsBox.get(_SettingsKeys.useCellular, defaultValue: false) ??
          false;
      _refreshInterval =
          _settingsBox.get(_SettingsKeys.refreshInterval, defaultValue: 30) ??
          30;
      _enableNotifications =
          _settingsBox.get(
            _SettingsKeys.enableNotifications,
            defaultValue: true,
          ) ??
          true;
      _darkMode =
          _settingsBox.get(_SettingsKeys.darkMode, defaultValue: false) ??
          false;

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading settings: $e');
    }
  }

  /// Reset to defaults
  Future<void> resetToDefaults() async {
    _temperatureUnit = TemperatureUnit.celsius;
    _windSpeedUnit = WindSpeedUnit.kmh;
    _pressureUnit = PressureUnit.hpa;
    _timeFormat = TimeFormat.twentyFourHour;
    _useCellularData = false;
    _refreshInterval = 30;
    _enableNotifications = true;
    _darkMode = false;
    await _saveSettings();
    notifyListeners();
  }

  @override
  void dispose() {
    try {
      if (_settingsBox.isOpen) {
        _settingsBox.close();
      }
    } catch (e) {
      debugPrint('Error closing settings box: $e');
    }
    super.dispose();
  }
}
