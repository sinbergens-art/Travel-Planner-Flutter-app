import '../entities/location.dart';

abstract class LocationRepository {
  Future<List<Location>> searchLocations(String query);
}
