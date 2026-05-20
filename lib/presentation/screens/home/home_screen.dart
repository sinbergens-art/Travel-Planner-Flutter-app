import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../providers/trip_provider.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/trip_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsAsync = ref.watch(tripsStreamProvider);
    final notifier = ref.read(tripNotifierProvider.notifier);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 160,
            floating: false,
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.primary,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'My Trips',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -20,
                      top: -20,
                      child: Icon(
                        Icons.travel_explore,
                        size: 180,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                tooltip: 'New Trip',
                onPressed: () => context.pushNamed('add-trip'),
              ),
            ],
          ),

          tripsAsync.when(
            data: (trips) => SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(AppConstants.pagePadding),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius:
                      BorderRadius.circular(AppConstants.cardBorderRadius),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatItem(
                      label: 'Total',
                      value: trips.length.toString(),
                      icon: Icons.luggage,
                    ),
                    _StatItem(
                      label: 'Upcoming',
                      value: trips
                          .where((t) =>
                              t.startDate.isAfter(DateTime.now()))
                          .length
                          .toString(),
                      icon: Icons.upcoming,
                    ),
                    _StatItem(
                      label: 'Shared',
                      value:
                          trips.where((t) => t.isShared).length.toString(),
                      icon: Icons.people,
                    ),
                  ],
                ),
              ),
            ),
            loading: () => const SliverToBoxAdapter(child: SizedBox()),
            error: (_, __) => const SliverToBoxAdapter(child: SizedBox()),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.pagePadding),
            sliver: SliverToBoxAdapter(
              child: Text(
                'All Trips',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          tripsAsync.when(
            data: (trips) {
              if (trips.isEmpty) {
                return SliverFillRemaining(
                  child: EmptyStateWidget(
                    icon: Icons.flight_takeoff,
                    title: 'No trips yet',
                    subtitle: 'Tap + to plan your first adventure!',
                    action: ElevatedButton.icon(
                      onPressed: () => context.pushNamed('add-trip'),
                      icon: const Icon(Icons.add),
                      label: const Text('New Trip'),
                    ),
                  ),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.pagePadding),
                sliver: SliverGrid(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: AppConstants.gridCrossAxisCount,
                    crossAxisSpacing: AppConstants.gridSpacing,
                    mainAxisSpacing: AppConstants.gridSpacing,
                    childAspectRatio: 0.75,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final trip = trips[index];
                      return TripCard(
                        trip: trip,
                        onDelete: () => notifier.deleteTrip(trip.id!),
                      );
                    },
                    childCount: trips.length,
                  ),
                ),
              );
            },
            loading: () => const SliverFillRemaining(
              child: LoadingWidget(message: 'Loading trips...'),
            ),
            error: (e, _) => SliverFillRemaining(
              child: ErrorWidget2(message: e.toString()),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed('add-trip'),
        icon: const Icon(Icons.add),
        label: const Text('New Trip'),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatItem(
      {required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon,
            color: Theme.of(context).colorScheme.primary, size: 20),
        const SizedBox(height: 4),
        Text(value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                )),
        Text(label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withOpacity(0.6),
                )),
      ],
    );
  }
}
