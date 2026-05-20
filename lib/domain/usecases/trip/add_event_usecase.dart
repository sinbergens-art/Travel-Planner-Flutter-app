import '../../entities/event.dart';
import '../../repositories/trip_repository.dart';

class AddEventUseCase {
  final TripRepository _repository;
  AddEventUseCase(this._repository);

  Future<int> call(TripEvent event) => _repository.insertEvent(event);
}
