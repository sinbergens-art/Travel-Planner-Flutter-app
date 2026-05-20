import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../domain/entities/trip.dart';
import '../../providers/collaborative_provider.dart';
import '../../providers/database_provider.dart';
import '../../providers/trip_provider.dart';
import '../../widgets/loading_widget.dart';

class CollaborativeScreen extends ConsumerWidget {
  const CollaborativeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sharedAsync = ref.watch(sharedTripsProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Shared Trips',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.secondary,
                      Theme.of(context).colorScheme.primary,
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(AppConstants.pagePadding),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius:
                    BorderRadius.circular(AppConstants.cardBorderRadius),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline,
                      color: Theme.of(context).colorScheme.secondary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Trips shared with you appear here in real-time via Firestore.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ),

          sharedAsync.when(
            data: (trips) {
              if (trips.isEmpty) {
                return SliverFillRemaining(
                  child: EmptyStateWidget(
                    icon: Icons.people_outline,
                    title: 'No shared trips yet',
                    subtitle:
                        'Toggle "Share with friends" when creating a trip to share it here',
                    action: ElevatedButton.icon(
                      onPressed: () => context.pushNamed('add-trip'),
                      icon: const Icon(Icons.add),
                      label: const Text('New Shared Trip'),
                    ),
                  ),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.all(AppConstants.pagePadding),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                        _SharedTripCard(trip: trips[index], ref: ref),
                    childCount: trips.length,
                  ),
                ),
              );
            },
            loading: () => const SliverFillRemaining(
                child: LoadingWidget(message: 'Loading shared trips...')),
            error: (e, _) => SliverFillRemaining(
              child: ErrorWidget2(
                message: 'Could not load shared trips.\n${e.toString()}',
                onRetry: () => ref.invalidate(sharedTripsProvider),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showShareExistingTrip(context, ref),
        icon: const Icon(Icons.share),
        label: const Text('Share a Trip'),
      ),
    );
  }

  Future<void> _showShareExistingTrip(
      BuildContext context, WidgetRef ref) async {
    final repo = ref.read(tripRepositoryProvider);
    final trips = await repo.getAllTrips();
    final unshared = trips.where((t) => !t.isShared).toList();

    if (!context.mounted) return;

    if (unshared.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No unshared trips available')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Choose a trip to share',
                style: Theme.of(ctx)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
          ),
          ...unshared.map(
            (trip) => ListTile(
              leading: const Icon(Icons.flight_takeoff),
              title: Text(trip.title),
              subtitle: Text(trip.destination),
              onTap: () async {
                Navigator.of(ctx).pop();
                try {
                  final prefs =
                      await ref.read(preferencesServiceProvider.future);
                  await ref
                      .read(shareTripUseCaseProvider)
                      .call(trip, prefs.userId, prefs.userName);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('✅ ${trip.title} shared to cloud!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('❌ Share failed: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _SharedTripCard extends StatelessWidget {
  final Trip trip;
  final WidgetRef ref;
  const _SharedTripCard({required this.trip, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor:
              Theme.of(context).colorScheme.secondaryContainer,
          radius: 24,
          child: Icon(Icons.flight_takeoff,
              color: Theme.of(context).colorScheme.secondary),
        ),
        title: Text(trip.title,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(children: [
              const Icon(Icons.location_on, size: 14),
              const SizedBox(width: 4),
              Expanded(
                child: Text(trip.destination,
                    overflow: TextOverflow.ellipsis),
              ),
            ]),
            const SizedBox(height: 2),
            Row(children: [
              const Icon(Icons.date_range, size: 14),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                    DateFormatter.formatRange(trip.startDate, trip.endDate),
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis),
              ),
            ]),
          ],
        ),
        trailing: Chip(
          label: const Text('Shared',
              style: TextStyle(fontSize: 11)),
          backgroundColor:
              Theme.of(context).colorScheme.secondaryContainer,
          avatar: Icon(Icons.cloud_done,
              size: 14, color: Theme.of(context).colorScheme.secondary),
        ),
        onTap: () {
          if (trip.id != null) {
            context.pushNamed('trip-detail',
                pathParameters: {'id': trip.id.toString()});
          }
        },
      ),
    );
  }
}
