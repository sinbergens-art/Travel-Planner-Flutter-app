import '../entities/trip.dart';
import '../entities/event.dart';

abstract class TripRepository {
  // Local (Drift)
  Future<List<Trip>> getAllTrips();
  Future<Trip?> getTripById(int id);
  Future<int> insertTrip(Trip trip);
  Future<void> updateTrip(Trip trip);
  Future<void> deleteTrip(int id);
  Stream<List<Trip>> watchAllTrips();

  // Events
  Future<List<TripEvent>> getEventsByTrip(int tripId);
  Future<int> insertEvent(TripEvent event);
  Future<void> updateEvent(TripEvent event);
  Future<void> deleteEvent(int id);
  Stream<List<TripEvent>> watchEventsByTrip(int tripId);

  // Firestore (Collaborative)
  Future<void> shareTrip(Trip trip, String userId, String userName);
  Future<List<Trip>> getSharedTrips(String userId);
  Stream<List<Trip>> watchSharedTrips(String userId);
  Future<void> updateSharedTrip(Trip trip);
  Future<void> deleteSharedTrip(String firestoreId);
}
