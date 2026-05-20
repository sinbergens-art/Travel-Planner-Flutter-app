import '../../entities/trip.dart';
import '../../repositories/trip_repository.dart';

class UpdateTripUseCase {
  final TripRepository _repository;
  UpdateTripUseCase(this._repository);

  Future<void> call(Trip trip) => _repository.updateTrip(trip);
}
