import '../../entities/trip.dart';
import '../../repositories/trip_repository.dart';

class ShareTripUseCase {
  final TripRepository _repository;
  ShareTripUseCase(this._repository);

  Future<void> call(Trip trip, String userId, String userName) =>
      _repository.shareTrip(trip, userId, userName);
}
