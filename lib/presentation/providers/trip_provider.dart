import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/event.dart';
import '../../domain/entities/trip.dart';
import '../../domain/usecases/trip/add_event_usecase.dart';
import '../../domain/usecases/trip/add_trip_usecase.dart';
import '../../domain/usecases/trip/delete_trip_usecase.dart';
import '../../domain/usecases/trip/get_events_usecase.dart';
import '../../domain/usecases/trip/get_trips_usecase.dart';
import '../../domain/usecases/trip/share_trip_usecase.dart';
import '../../domain/usecases/trip/update_trip_usecase.dart';
import 'database_provider.dart';

final getTripsUseCaseProvider =
    Provider((ref) => GetTripsUseCase(ref.watch(tripRepositoryProvider)));
final addTripUseCaseProvider =
    Provider((ref) => AddTripUseCase(ref.watch(tripRepositoryProvider)));
final updateTripUseCaseProvider =
    Provider((ref) => UpdateTripUseCase(ref.watch(tripRepositoryProvider)));
final deleteTripUseCaseProvider =
    Provider((ref) => DeleteTripUseCase(ref.watch(tripRepositoryProvider)));
final getEventsUseCaseProvider =
    Provider((ref) => GetEventsUseCase(ref.watch(tripRepositoryProvider)));
final addEventUseCaseProvider =
    Provider((ref) => AddEventUseCase(ref.watch(tripRepositoryProvider)));
final shareTripUseCaseProvider =
    Provider((ref) => ShareTripUseCase(ref.watch(tripRepositoryProvider)));

final tripsStreamProvider = StreamProvider<List<Trip>>((ref) {
  return ref.watch(getTripsUseCaseProvider).call();
});

final eventsStreamProvider =
    StreamProvider.family<List<TripEvent>, int>((ref, tripId) {
  return ref.watch(getEventsUseCaseProvider).call(tripId);
});

class TripNotifier extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> addTrip(Trip trip) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => ref.read(addTripUseCaseProvider).call(trip));
  }

  Future<void> updateTrip(Trip trip) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => ref.read(updateTripUseCaseProvider).call(trip));
  }

  Future<void> deleteTrip(int id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => ref.read(deleteTripUseCaseProvider).call(id));
  }

  Future<void> addEvent(TripEvent event) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => ref.read(addEventUseCaseProvider).call(event));
  }
}

final tripNotifierProvider =
    NotifierProvider<TripNotifier, AsyncValue<void>>(TripNotifier.new);
