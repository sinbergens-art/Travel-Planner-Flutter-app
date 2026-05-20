import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../domain/entities/trip.dart';

class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService(this._firestore);

  static FirestoreService create() =>
      FirestoreService(FirebaseFirestore.instance);

  CollectionReference<Map<String, dynamic>> get _tripsCollection =>
      _firestore.collection(AppConstants.collectionSharedTrips);

  /// Share a trip to Firestore
  Future<String> shareTrip(
      Trip trip, String userId, String userName) async {
    final data = _tripToFirestore(trip, userId, userName);
    final docRef = await _tripsCollection.add(data);
    return docRef.id;
  }

  /// Update existing shared trip
  Future<void> updateSharedTrip(Trip trip) async {
    if (trip.firestoreId == null) return;
    await _tripsCollection
        .doc(trip.firestoreId)
        .update(_tripToFirestoreUpdate(trip));
  }

  /// Delete shared trip
  Future<void> deleteSharedTrip(String firestoreId) async {
    await _tripsCollection.doc(firestoreId).delete();
  }

  /// Get all shared trips (one-time)
  Future<List<Trip>> getSharedTrips(String userId) async {
    final snapshot = await _tripsCollection.get();
    final trips = snapshot.docs
        .map((doc) => _firestoreToTrip(doc))
        .where((t) => true) // all shared trips visible to owner
        .toList();
    trips.sort((a, b) => b.startDate.compareTo(a.startDate));
    return trips;
  }

  /// Watch shared trips in real-time (no composite index needed)
  Stream<List<Trip>> watchSharedTrips(String userId) {
    return _tripsCollection.snapshots().map((snap) {
      final trips = snap.docs.map((doc) => _firestoreToTrip(doc)).toList();
      trips.sort((a, b) => b.startDate.compareTo(a.startDate));
      return trips;
    });
  }

  Map<String, dynamic> _tripToFirestore(
      Trip trip, String userId, String userName) {
    return {
      'title': trip.title,
      'destination': trip.destination,
      'startDate': Timestamp.fromDate(trip.startDate),
      'endDate': Timestamp.fromDate(trip.endDate),
      'description': trip.description ?? '',
      'ownerId': userId,
      'ownerName': userName,
      'participants': [userId],
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  Map<String, dynamic> _tripToFirestoreUpdate(Trip trip) {
    return {
      'title': trip.title,
      'destination': trip.destination,
      'startDate': Timestamp.fromDate(trip.startDate),
      'endDate': Timestamp.fromDate(trip.endDate),
      'description': trip.description ?? '',
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  Trip _firestoreToTrip(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Trip(
      title: data['title'] as String,
      destination: data['destination'] as String,
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      description: data['description'] as String?,
      isShared: true,
      firestoreId: doc.id,
    );
  }
}
