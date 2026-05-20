import '../../repositories/trip_repository.dart';

class DeleteTripUseCase {
  final TripRepository _repository;
  DeleteTripUseCase(this._repository);

  Future<void> call(int id) => _repository.deleteTrip(id);
}
