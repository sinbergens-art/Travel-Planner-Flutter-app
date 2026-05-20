import '../../entities/trip.dart';
import '../../repositories/trip_repository.dart';

class AddTripUseCase {
  final TripRepository _repository;
  AddTripUseCase(this._repository);

  Future<int> call(Trip trip) => _repository.insertTrip(trip);
}
