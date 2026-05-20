import '../../entities/location.dart';
import '../../repositories/location_repository.dart';

class SearchLocationsUseCase {
  final LocationRepository _repository;
  SearchLocationsUseCase(this._repository);

  Future<List<Location>> call(String query) =>
      _repository.searchLocations(query);
}
