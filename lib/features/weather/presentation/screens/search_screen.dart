import 'package:flutter/material.dart' hide ErrorWidget;
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:atmos/app/app_theme.dart';
import 'package:atmos/core/constants/constants.dart';
import 'package:atmos/features/weather/presentation/providers/search_provider.dart';
import 'package:atmos/features/weather/presentation/widgets/common_widgets.dart';

enum SearchState { idle, loading, success, error, empty }

/// Search screen for finding cities
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final searchProvider = Provider.of<SearchProvider>(
        context,
        listen: false,
      );
      searchProvider.loadRecentSearches();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(UiStrings.searchCity), elevation: 0),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(AppTheme.spacing16.w),
            child: SearchField(
              controller: _searchController,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  context.read<SearchProvider>().searchCities(value);
                } else {
                  context.read<SearchProvider>().clearSearchResults();
                }
              },
            ),
          ),
          Expanded(
            child: Consumer<SearchProvider>(
              builder: (context, searchProvider, _) {
                if (searchProvider.state == SearchState.idle) {
                  // Show recent searches
                  if (searchProvider.recentSearches.isEmpty) {
                    return EmptyStateWidget(
                      title: 'No Recent Searches',
                      message: 'Search for any city to get started',
                      icon: Icons.location_on,
                    );
                  }

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionHeader(
                          title: UiStrings.recentSearches,
                          onSeeAll: () {
                            searchProvider.clearSearchResults();
                          },
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: searchProvider.recentSearches.length,
                          itemBuilder: (context, index) {
                            final city = searchProvider.recentSearches[index];
                            return SearchResultTile(
                              city: city,
                              onTap: () {
                                Navigator.pop(context, city);
                              },
                              showRecent: true,
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }

                if (searchProvider.isLoading) {
                  return const LoadingWidget(message: UiStrings.loading);
                }

                if (searchProvider.hasError) {
                  return ErrorWidget(
                    message: searchProvider.failure?.message ?? UiStrings.error,
                    onRetry: () => searchProvider.retrySearch(),
                  );
                }

                if (searchProvider.isEmpty) {
                  return EmptyStateWidget(
                    title: UiStrings.noResults,
                    message: 'Try a different search term',
                    icon: Icons.search_off,
                  );
                }

                return ListView.builder(
                  itemCount: searchProvider.searchResults.length,
                  itemBuilder: (context, index) {
                    final city = searchProvider.searchResults[index];
                    return SearchResultTile(
                      city: city,
                      onTap: () {
                        Navigator.pop(context, city);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Search field widget
class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const SearchField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: UiStrings.searchHint,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  controller.clear();
                  onChanged('');
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          borderSide: const BorderSide(color: AppTheme.borderColor),
        ),
      ),
    );
  }
}

/// Search result tile
class SearchResultTile extends StatelessWidget {
  final dynamic city;
  final VoidCallback onTap;
  final bool showRecent;

  const SearchResultTile({
    super.key,
    required this.city,
    required this.onTap,
    this.showRecent = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        showRecent ? Icons.history : Icons.location_on,
        color: Theme.of(context).primaryColor,
      ),
      title: Text(city.name),
      subtitle: Text(city.country),
      trailing: showRecent
          ? IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                // Handle remove from recent
              },
            )
          : const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
