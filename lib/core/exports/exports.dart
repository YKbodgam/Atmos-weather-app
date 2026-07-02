// Barrel file for core exports

// Constants
export 'package:atmos/core/constants/constants.dart';

// Error handling
export 'package:atmos/core/error/failure_handler.dart';

// Extensions
export 'package:atmos/core/extensions/extensions.dart';

// App theme
export 'package:atmos/app/app_theme.dart';

// Domain entities
export 'package:atmos/features/weather/domain/entities/weather_entity.dart';

// Providers
export 'package:atmos/features/weather/presentation/providers/weather_provider.dart';
export 'package:atmos/features/weather/presentation/providers/search_provider.dart';
export 'package:atmos/features/weather/presentation/providers/favorites_provider.dart';
export 'package:atmos/features/weather/presentation/providers/settings_provider.dart';

// Widgets
export 'package:atmos/features/weather/presentation/widgets/common_widgets.dart';
export 'package:atmos/features/weather/presentation/widgets/weather_widgets.dart';
