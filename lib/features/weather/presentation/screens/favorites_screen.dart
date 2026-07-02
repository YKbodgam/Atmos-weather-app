import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:atmos/app/app_theme.dart';
import 'package:atmos/core/constants/constants.dart';
import 'package:atmos/features/weather/presentation/providers/favorites_provider.dart';
import 'package:atmos/features/weather/presentation/widgets/common_widgets.dart';

/// Favorites screen showing saved cities
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavoritesProvider>().loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(UiStrings.favorites),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Implement edit mode
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: Consumer<FavoritesProvider>(
        builder: (context, favoritesProvider, _) {
          if (favoritesProvider.isLoading) {
            return const LoadingWidget(message: UiStrings.loading);
          }

          if (favoritesProvider.isEmpty) {
            return EmptyStateWidget(
              title: UiStrings.noFavorites,
              message: 'Add cities to your favorites for quick access',
              icon: Icons.star_outline,
              action: ElevatedButton(
                onPressed: () {
                  // TODO: Navigate to search
                },
                child: const Text('Add Favorite'),
              ),
            );
          }

          return ListView.builder(
            itemCount: favoritesProvider.favorites.length,
            itemBuilder: (context, index) {
              final city = favoritesProvider.favorites[index];
              return FavoriteCityTile(
                city: city,
                onRemove: () {
                  favoritesProvider
                      .removeFavorite('${city.name}-${city.country}');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${city.name} removed from favorites'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                onTap: () {
                  // TODO: Navigate to weather details
                  Navigator.pop(context, city);
                },
              );
            },
          );
        },
      ),
    );
  }
}

/// Favorite city tile widget
class FavoriteCityTile extends StatelessWidget {
  final dynamic city;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  const FavoriteCityTile({
    Key? key,
    required this.city,
    required this.onRemove,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppTheme.spacing16.w,
        vertical: AppTheme.spacing8.h,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          child: Padding(
            padding: EdgeInsets.all(AppTheme.spacing16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      city.name,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: AppTheme.spacing4.h),
                    Text(
                      city.country,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.star, color: AppTheme.secondaryColor),
                      onPressed: onRemove,
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
