import '../../entities/event.dart';
import '../../repositories/trip_repository.dart';

class GetEventsUseCase {
  final TripRepository _repository;
  GetEventsUseCase(this._repository);

  Stream<List<TripEvent>> call(int tripId) =>
      _repository.watchEventsByTrip(tripId);
}
