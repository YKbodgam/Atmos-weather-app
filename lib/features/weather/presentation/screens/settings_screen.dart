import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/app_theme.dart';
import '../../../../core/constants/constants.dart';

import '../providers/settings_provider.dart';

/// Settings screen for app preferences
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(UiStrings.settings), elevation: 0),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Preferences section
                Padding(
                  padding: EdgeInsets.all(AppTheme.spacing16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        UiStrings.preferences,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      SizedBox(height: AppTheme.spacing16.h),
                      _SettingsTile(
                        title: UiStrings.temperature,
                        value: settings.temperatureUnitString,
                        onTap: () => _showUnitDialog(context, 'Temperature'),
                      ),
                      const Divider(),
                      _SettingsTile(
                        title: UiStrings.windSpeedUnit,
                        value: settings.windSpeedUnitString,
                        onTap: () => _showUnitDialog(context, 'Wind'),
                      ),
                      const Divider(),
                      _SettingsTile(
                        title: UiStrings.pressureUnit,
                        value: settings.pressureUnitString,
                        onTap: () => _showUnitDialog(context, 'Pressure'),
                      ),
                      const Divider(),
                      _SettingsTile(
                        title: UiStrings.timeFormat,
                        value: settings.timeFormat == TimeFormat.twentyFourHour
                            ? '24 Hour'
                            : '12 Hour',
                        onTap: () async {
                          await settings.setTimeFormat(
                            settings.timeFormat == TimeFormat.twentyFourHour
                                ? TimeFormat.twelveHour
                                : TimeFormat.twentyFourHour,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppTheme.spacing8.h),

                // App section
                Padding(
                  padding: EdgeInsets.all(AppTheme.spacing16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'App',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      SizedBox(height: AppTheme.spacing16.h),
                      _SettingsTile(
                        title: 'Refresh Interval',
                        value: '${settings.refreshInterval} min',
                        onTap: () => _showRefreshDialog(context),
                      ),
                      const Divider(),
                      _SettingsToggle(
                        title: 'Use Cellular Data',
                        value: settings.useCellularData,
                        onChanged: (value) async {
                          await settings.setUseCellularData(value);
                        },
                      ),
                      const Divider(),
                      _SettingsToggle(
                        title: UiStrings.enableNotifications,
                        value: settings.enableNotifications,
                        onChanged: (value) async {
                          await settings.setEnableNotifications(value);
                        },
                      ),
                      const Divider(),
                      _SettingsToggle(
                        title: 'Dark Mode',
                        value: settings.darkMode,
                        onChanged: (value) async {
                          await settings.setDarkMode(value);
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppTheme.spacing8.h),

                // About section
                Padding(
                  padding: EdgeInsets.all(AppTheme.spacing16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      SizedBox(height: AppTheme.spacing16.h),
                      _SettingsTile(
                        title: UiStrings.about,
                        value: 'Atmos Weather App',
                      ),
                      const Divider(),
                      _SettingsTile(
                        title: UiStrings.version,
                        value: AppConstants.appVersion,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppTheme.spacing32.h),

                // Reset button
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppTheme.spacing16.w,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Reset Settings'),
                          content: const Text(
                            'Are you sure you want to reset all settings to defaults?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                await settings.resetToDefaults();
                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                              },
                              child: const Text('Reset'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text('Reset to Defaults'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showUnitDialog(BuildContext context, String type) {
    final settings = context.read<SettingsProvider>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$type Unit'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (type == 'Temperature') ...[
              _DialogOption(
                title: 'Celsius',
                onTap: () async {
                  await settings.setTemperatureUnit(TemperatureUnit.celsius);
                  if (context.mounted) Navigator.pop(context);
                },
              ),
              _DialogOption(
                title: 'Fahrenheit',
                onTap: () async {
                  await settings.setTemperatureUnit(TemperatureUnit.fahrenheit);
                  if (context.mounted) Navigator.pop(context);
                },
              ),
            ] else if (type == 'Wind') ...[
              _DialogOption(
                title: 'km/h',
                onTap: () async {
                  await settings.setWindSpeedUnit(WindSpeedUnit.kmh);
                  if (context.mounted) Navigator.pop(context);
                },
              ),
              _DialogOption(
                title: 'm/s',
                onTap: () async {
                  await settings.setWindSpeedUnit(WindSpeedUnit.ms);
                  if (context.mounted) Navigator.pop(context);
                },
              ),
              _DialogOption(
                title: 'mph',
                onTap: () async {
                  await settings.setWindSpeedUnit(WindSpeedUnit.mph);
                  if (context.mounted) Navigator.pop(context);
                },
              ),
            ] else if (type == 'Pressure') ...[
              _DialogOption(
                title: 'hPa',
                onTap: () async {
                  await settings.setPressureUnit(PressureUnit.hpa);
                  if (context.mounted) Navigator.pop(context);
                },
              ),
              _DialogOption(
                title: 'mb',
                onTap: () async {
                  await settings.setPressureUnit(PressureUnit.mb);
                  if (context.mounted) Navigator.pop(context);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showRefreshDialog(BuildContext context) {
    final settings = context.read<SettingsProvider>();
    final intervals = [15, 30, 60, 120];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Refresh Interval'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: intervals
              .map(
                (interval) => _DialogOption(
                  title: '$interval minutes',
                  onTap: () async {
                    await settings.setRefreshInterval(interval);
                    if (context.mounted) Navigator.pop(context);
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

/// Settings tile widget
class _SettingsTile extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback? onTap;

  const _SettingsTile({required this.title, required this.value, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary),
          ),
          SizedBox(width: AppTheme.spacing8.w),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: onTap,
    );
  }
}

/// Settings toggle widget
class _SettingsToggle extends StatelessWidget {
  final String title;
  final bool value;
  final Function(bool) onChanged;

  const _SettingsToggle({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: Switch(value: value, onChanged: onChanged),
    );
  }
}

/// Dialog option widget
class _DialogOption extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _DialogOption({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppTheme.spacing8.h),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: AppTheme.spacing12.w,
            vertical: AppTheme.spacing12.h,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.borderColor),
            borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
          ),
          child: Text(title, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ),
    );
  }
}
