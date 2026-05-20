import '../../entities/trip.dart';
import '../../repositories/trip_repository.dart';

class GetTripsUseCase {
  final TripRepository _repository;
  GetTripsUseCase(this._repository);

  Stream<List<Trip>> call() => _repository.watchAllTrips();
}
