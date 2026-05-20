import 'package:drift/drift.dart';
import '../../domain/entities/event.dart';
import '../../domain/entities/trip.dart';
import '../../domain/repositories/trip_repository.dart';
import '../datasources/local/drift/app_database.dart';
import '../datasources/remote/firestore/firestore_service.dart';

class TripRepositoryImpl implements TripRepository {
  final AppDatabase _db;
  final FirestoreService _firestore;

  TripRepositoryImpl(this._db, this._firestore);

  @override
  Stream<List<Trip>> watchAllTrips() =>
      _db.tripsDao.watchAllTrips().map((rows) => rows.map(_rowToTrip).toList());

  @override
  Future<List<Trip>> getAllTrips() async {
    final rows = await _db.tripsDao.getAllTrips();
    return rows.map(_rowToTrip).toList();
  }

  @override
  Future<Trip?> getTripById(int id) async {
    final row = await _db.tripsDao.getTripById(id);
    return row != null ? _rowToTrip(row) : null;
  }

  @override
  Future<int> insertTrip(Trip trip) =>
      _db.tripsDao.insertTrip(_tripToCompanion(trip));

  @override
  Future<void> updateTrip(Trip trip) =>
      _db.tripsDao.updateTrip(_tripToCompanionWithId(trip));

  @override
  Future<void> deleteTrip(int id) => _db.tripsDao.deleteTrip(id);

  @override
  Stream<List<TripEvent>> watchEventsByTrip(int tripId) => _db.eventsDao
      .watchEventsByTrip(tripId)
      .map((rows) => rows.map(_rowToEvent).toList());

  @override
  Future<List<TripEvent>> getEventsByTrip(int tripId) async {
    final rows = await _db.eventsDao.getEventsByTrip(tripId);
    return rows.map(_rowToEvent).toList();
  }

  @override
  Future<int> insertEvent(TripEvent event) =>
      _db.eventsDao.insertEvent(_eventToCompanion(event));

  @override
  Future<void> updateEvent(TripEvent event) =>
      _db.eventsDao.updateEvent(_eventToCompanionWithId(event));

  @override
  Future<void> deleteEvent(int id) => _db.eventsDao.deleteEvent(id);

  @override
  Future<void> shareTrip(Trip trip, String userId, String userName) async {
    final firestoreId = await _firestore.shareTrip(trip, userId, userName);
    // Mark the local trip as shared and store the Firestore doc ID
    if (trip.id != null) {
      await _db.tripsDao.updateTrip(TripsTableCompanion(
        id: Value(trip.id!),
        title: Value(trip.title),
        destination: Value(trip.destination),
        startDate: Value(trip.startDate),
        endDate: Value(trip.endDate),
        description: Value(trip.description),
        isShared: const Value(true),
        firestoreId: Value(firestoreId),
      ));
    }
  }

  @override
  Future<List<Trip>> getSharedTrips(String userId) =>
      _firestore.getSharedTrips(userId);

  @override
  Stream<List<Trip>> watchSharedTrips(String userId) =>
      _firestore.watchSharedTrips(userId);

  @override
  Future<void> updateSharedTrip(Trip trip) =>
      _firestore.updateSharedTrip(trip);

  @override
  Future<void> deleteSharedTrip(String firestoreId) =>
      _firestore.deleteSharedTrip(firestoreId);

  Trip _rowToTrip(TripsTableData row) => Trip(
        id: row.id,
        title: row.title,
        destination: row.destination,
        startDate: row.startDate,
        endDate: row.endDate,
        description: row.description,
        isShared: row.isShared,
        firestoreId: row.firestoreId,
      );

  TripsTableCompanion _tripToCompanion(Trip trip) => TripsTableCompanion.insert(
        title: trip.title,
        destination: trip.destination,
        startDate: trip.startDate,
        endDate: trip.endDate,
        description: Value(trip.description),
        isShared: Value(trip.isShared),
        firestoreId: Value(trip.firestoreId),
      );

  TripsTableCompanion _tripToCompanionWithId(Trip trip) =>
      TripsTableCompanion(
        id: Value(trip.id!),
        title: Value(trip.title),
        destination: Value(trip.destination),
        startDate: Value(trip.startDate),
        endDate: Value(trip.endDate),
        description: Value(trip.description),
        isShared: Value(trip.isShared),
        firestoreId: Value(trip.firestoreId),
      );

  TripEvent _rowToEvent(EventsTableData row) => TripEvent(
        id: row.id,
        tripId: row.tripId,
        title: row.title,
        location: row.location,
        dateTime: row.scheduledAt,
        notes: row.notes,
        isCompleted: row.isCompleted,
      );

  EventsTableCompanion _eventToCompanion(TripEvent event) =>
      EventsTableCompanion.insert(
        tripId: event.tripId,
        title: event.title,
        location: Value(event.location),
        scheduledAt: event.dateTime,
        notes: Value(event.notes),
        isCompleted: Value(event.isCompleted),
      );

  EventsTableCompanion _eventToCompanionWithId(TripEvent event) =>
      EventsTableCompanion(
        id: Value(event.id!),
        tripId: Value(event.tripId),
        title: Value(event.title),
        location: Value(event.location),
        scheduledAt: Value(event.dateTime),
        notes: Value(event.notes),
        isCompleted: Value(event.isCompleted),
      );
}
