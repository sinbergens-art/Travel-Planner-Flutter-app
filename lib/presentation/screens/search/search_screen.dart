import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../domain/entities/location.dart';
import '../../providers/location_provider.dart';
import '../../widgets/loading_widget.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locationsAsync = ref.watch(locationSearchProvider);
    final query = ref.watch(locationSearchQueryProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: const Text('Search Places'),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(64),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: TextField(
                  controller: _searchController,
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText: 'Search cities or places...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: query.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              ref
                                  .read(locationSearchQueryProvider.notifier)
                                  .setQuery('');
                            },
                          )
                        : null,
                    filled: true,
                  ),
                  onChanged: (v) => ref
                      .read(locationSearchQueryProvider.notifier)
                      .setQuery(v),
                ),
              ),
            ),
          ),

          // ── Results ───────────────────────────────────────────────────
          if (query.trim().length < 2)
            SliverFillRemaining(
              child: EmptyStateWidget(
                icon: Icons.travel_explore,
                title: 'Discover Places',
                subtitle:
                    'Search for cities, countries or destinations\nfor your next adventure',
              ),
            )
          else
            locationsAsync.when(
              data: (locations) {
                if (locations.isEmpty) {
                  return SliverFillRemaining(
                    child: EmptyStateWidget(
                      icon: Icons.search_off,
                      title: 'No results found',
                      subtitle: 'Try a different search term',
                    ),
                  );
                }
                return SliverPadding(
                  padding: const EdgeInsets.all(AppConstants.pagePadding),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) =>
                          _LocationCard(location: locations[index]),
                      childCount: locations.length,
                    ),
                  ),
                );
              },
              loading: () =>
                  const SliverFillRemaining(child: LoadingWidget(message: 'Searching...')),
              error: (e, _) => SliverFillRemaining(
                child: ErrorWidget2(
                  message: 'Could not load results.\nCheck your connection.',
                  onRetry: () => ref.invalidate(locationSearchProvider),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

void _showLocationSheet(BuildContext context, Location location) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (ctx) => Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor:
                    Theme.of(ctx).colorScheme.primaryContainer,
                radius: 24,
                child: Icon(Icons.location_on,
                    color: Theme.of(ctx).colorScheme.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(location.shortName,
                        style: Theme.of(ctx)
                            .textTheme
                            .titleLarge
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    if (location.country != null)
                      Text(location.country!,
                          style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(ctx)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.6),
                              )),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            location.displayName,
            style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                  color: Theme.of(ctx).colorScheme.onSurface.withOpacity(0.5),
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.my_location,
                  size: 14,
                  color: Theme.of(ctx).colorScheme.onSurface.withOpacity(0.4)),
              const SizedBox(width: 4),
              Text(
                '${location.latitude.toStringAsFixed(4)}, ${location.longitude.toStringAsFixed(4)}',
                style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                      color: Theme.of(ctx)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.4),
                    ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              icon: const Icon(Icons.add_location_alt),
              label: const Text('Plan a trip here'),
              onPressed: () {
                ctx.pop();
                context.pushNamed(
                  'add-trip',
                  queryParameters: {'destination': location.shortName},
                );
              },
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}

class _LocationCard extends StatelessWidget {
  final Location location;
  const _LocationCard({required this.location});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            Icons.location_city,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(
          location.shortName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              location.displayName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
            if (location.country != null)
              Row(
                children: [
                  const Icon(Icons.flag, size: 11),
                  const SizedBox(width: 4),
                  Text(location.country!,
                      style: const TextStyle(fontSize: 11)),
                ],
              ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${location.latitude.toStringAsFixed(2)}°',
              style: const TextStyle(fontSize: 10),
            ),
            Text(
              '${location.longitude.toStringAsFixed(2)}°',
              style: const TextStyle(fontSize: 10),
            ),
          ],
        ),
        onTap: () => _showLocationSheet(context, location),
      ),
    );
  }
}
