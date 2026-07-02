import 'package:intl/intl.dart';

import '../../features/weather/presentation/providers/settings_provider.dart';

/// DateTime Extensions
extension DateTimeExtensions on DateTime {
  /// Format datetime to HH:mm or hh:mm a pattern based on TimeFormat
  String formatTime(TimeFormat timeFormat) {
    if (timeFormat == TimeFormat.twentyFourHour) {
      return DateFormat('HH:mm').format(this);
    } else {
      return DateFormat('hh:mm a').format(this);
    }
  }

  /// Format datetime to HH:mm pattern
  String toTimeString() {
    return DateFormat('HH:mm').format(this);
  }

  /// Format datetime to dd MMM pattern
  String toDateString() {
    return DateFormat('dd MMM').format(this);
  }

  /// Format datetime to EEEE pattern (Monday, Tuesday, etc.)
  String toDayName() {
    return DateFormat('EEEE').format(this);
  }

  /// Format datetime to full format
  String toFullString() {
    return DateFormat('dd MMM, yyyy HH:mm').format(this);
  }

  /// Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if date is tomorrow
  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }
}

/// String Extensions
extension StringExtensions on String {
  /// Capitalize first letter
  String get capitalize {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  /// Check if string is valid email
  bool get isValidEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  /// Truncate string to given length
  String truncate(int length, {String suffix = '...'}) {
    if (this.length <= length) return this;
    return substring(0, length - suffix.length) + suffix;
  }
}

/// Double Extensions
extension DoubleExtensions on double {
  /// Round to n decimal places
  double roundToDecimal(int decimals) {
    final factor = pow(10.0, decimals).toInt();
    return (this * factor).round() / factor;
  }

  /// Convert celsius to fahrenheit
  double get celsiusToFahrenheit {
    return (this * 9 / 5) + 32;
  }

  /// Convert fahrenheit to celsius
  double get fahrenheitToCelsius {
    return (this - 32) * 5 / 9;
  }

  /// Format as temperature string
  String toTemperatureString({bool celsius = true}) {
    final temp = roundToDecimal(1);
    final unit = celsius ? '°C' : '°F';
    return '$temp$unit';
  }
}

double pow(double base, int exponent) {
  double result = 1;
  for (int i = 0; i < exponent; i++) {
    result *= base;
  }
  return result;
}

/// Int Extensions
extension IntExtensions on int {
  /// Format as wind speed
  String toWindSpeedString({bool kmh = true}) {
    final unit = kmh ? 'km/h' : 'm/s';
    return '$this $unit';
  }

  /// Format as percentage
  String get toPercentage => '$this%';

  /// Format as pressure
  String toPressureString({bool hpa = true}) {
    final unit = hpa ? 'hPa' : 'mb';
    return '$this $unit';
  }
}

/// List Extensions
extension ListExtensions<T> on List<T> {
  /// Check if list is empty or null
  bool get isEmptyOrNull => isEmpty;

  /// Get first or null
  T? get firstOrNull => isEmpty ? null : first;

  /// Get last or null
  T? get lastOrNull => isEmpty ? null : last;
}
