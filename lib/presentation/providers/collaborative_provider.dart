import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/trip.dart';
import 'database_provider.dart';

final sharedTripsProvider =
    StreamProvider.autoDispose<List<Trip>>((ref) async* {
  final prefs = await ref.read(preferencesServiceProvider.future);
  final userId = prefs.userId;
  final repo = ref.read(tripRepositoryProvider);
  yield* repo.watchSharedTrips(userId);
});
