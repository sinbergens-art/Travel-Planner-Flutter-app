import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../domain/entities/event.dart';
import '../../../domain/entities/trip.dart';
import '../../providers/trip_provider.dart';
import '../../providers/database_provider.dart';
import '../../widgets/loading_widget.dart';

class TripDetailScreen extends ConsumerWidget {
  final int tripId;
  const TripDetailScreen({super.key, required this.tripId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(eventsStreamProvider(tripId));
    final tripRepo = ref.read(tripRepositoryProvider);

    return FutureBuilder<Trip?>(
      future: tripRepo.getTripById(tripId),
      builder: (context, snapshot) {
        final trip = snapshot.data;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // ── SliverAppBar ──────────────────────────────────────────
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    trip?.title ?? 'Trip Details',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.tertiary,
                        ],
                      ),
                    ),
                    child: const Center(
                      child: Icon(Icons.travel_explore,
                          size: 80, color: Colors.white24),
                    ),
                  ),
                ),
                actions: [
                  if (trip != null)
                    IconButton(
                      icon: Icon(
                        trip.isShared
                            ? Icons.cloud_done
                            : Icons.cloud_upload_outlined,
                        color: Colors.white,
                      ),
                      tooltip: trip.isShared ? 'Shared to cloud' : 'Share to cloud',
                      onPressed: trip.isShared
                          ? null
                          : () => _shareTrip(context, ref, trip),
                    ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: () => context.pushNamed('edit-trip',
                        pathParameters: {'id': tripId.toString()}),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.white),
                    onPressed: () => _confirmDelete(context, ref),
                  ),
                ],
              ),

              // ── Trip Info ─────────────────────────────────────────────
              if (trip != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _InfoRow(
                            icon: Icons.location_on,
                            text: trip.destination),
                        const SizedBox(height: 8),
                        _InfoRow(
                          icon: Icons.date_range,
                          text: DateFormatter.formatRange(
                              trip.startDate, trip.endDate),
                        ),
                        const SizedBox(height: 8),
                        _InfoRow(
                          icon: Icons.timelapse,
                          text:
                              '${DateFormatter.daysBetween(trip.startDate, trip.endDate)} days',
                        ),
                        if (trip.description != null &&
                            trip.description!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          _InfoRow(
                              icon: Icons.notes, text: trip.description!),
                        ],
                      ],
                    ),
                  ),
                ),

              // ── Events Section Title ──────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Events',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      TextButton.icon(
                        onPressed: () =>
                            _showAddEventDialog(context, ref, tripId),
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Add'),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Events List ───────────────────────────────────────────
              eventsAsync.when(
                data: (events) {
                  if (events.isEmpty) {
                    return const SliverFillRemaining(
                      child: EmptyStateWidget(
                        icon: Icons.event_note,
                        title: 'No events yet',
                        subtitle: 'Add activities to your itinerary',
                      ),
                    );
                  }
                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) =>
                            _EventTile(event: events[index], ref: ref),
                        childCount: events.length,
                      ),
                    ),
                  );
                },
                loading: () =>
                    const SliverFillRemaining(child: LoadingWidget()),
                error: (e, _) => SliverFillRemaining(
                  child: ErrorWidget2(message: e.toString()),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showAddEventDialog(context, ref, tripId),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Future<void> _shareTrip(
      BuildContext context, WidgetRef ref, Trip trip) async {
    try {
      final prefs = await ref.read(preferencesServiceProvider.future);
      final userId = prefs.userId;
      final userName = prefs.userName;
      await ref.read(shareTripUseCaseProvider).call(trip, userId, userName);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Trip shared to cloud!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
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
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Trip?'),
        content: const Text('This will permanently delete the trip and all its events.'),
        actions: [
          TextButton(onPressed: () => ctx.pop(false), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => ctx.pop(true),
            style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(tripNotifierProvider.notifier).deleteTrip(tripId);
      if (context.mounted) context.go('/home');
    }
  }

  Future<void> _showAddEventDialog(
      BuildContext context, WidgetRef ref, int tripId) async {
    final titleCtrl = TextEditingController();
    final locationCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    DateTime selectedDate = DateTime.now();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add Event',
                  style: Theme.of(ctx)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(
                    labelText: 'Event Title *',
                    prefixIcon: Icon(Icons.event)),
                autofocus: true,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: locationCtrl,
                decoration: const InputDecoration(
                    labelText: 'Location',
                    prefixIcon: Icon(Icons.location_on)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: notesCtrl,
                decoration: const InputDecoration(
                    labelText: 'Notes',
                    prefixIcon: Icon(Icons.notes)),
              ),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today),
                title: Text(DateFormatter.formatDateTime(selectedDate)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  final d = await showDatePicker(
                    context: ctx,
                    initialDate: selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (d != null) setModalState(() => selectedDate = d);
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (titleCtrl.text.trim().isEmpty) return;
                    final event = TripEvent(
                      tripId: tripId,
                      title: titleCtrl.text.trim(),
                      location: locationCtrl.text.trim().isEmpty
                          ? null
                          : locationCtrl.text.trim(),
                      dateTime: selectedDate,
                      notes: notesCtrl.text.trim().isEmpty
                          ? null
                          : notesCtrl.text.trim(),
                    );
                    await ref
                        .read(tripNotifierProvider.notifier)
                        .addEvent(event);
                    if (ctx.mounted) ctx.pop();
                  },
                  child: const Text('Add Event'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyMedium)),
      ],
    );
  }
}

class _EventTile extends ConsumerWidget {
  final TripEvent event;
  final WidgetRef ref;
  const _EventTile({required this.event, required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Checkbox(
          value: event.isCompleted,
          onChanged: (v) {
            final repo = ref.read(tripRepositoryProvider);
            repo.updateEvent(event.copyWith(isCompleted: v ?? false));
          },
        ),
        title: Text(
          event.title,
          style: TextStyle(
            decoration:
                event.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (event.location != null)
              Row(children: [
                const Icon(Icons.location_on, size: 12),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(event.location!,
                      style: const TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis),
                ),
              ]),
            Text(DateFormatter.formatDateTime(event.dateTime),
                style: const TextStyle(fontSize: 11)),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, size: 20),
          onPressed: () async {
            final repo = ref.read(tripRepositoryProvider);
            await repo.deleteEvent(event.id!);
          },
        ),
      ),
    );
  }
}
