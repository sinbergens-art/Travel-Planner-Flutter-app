import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/local/drift/app_database.dart';
import '../../data/datasources/local/shared_prefs/preferences_service.dart';
import '../../data/datasources/remote/chopper/chopper_client.dart';
import '../../data/datasources/remote/chopper/location_api_service.dart';
import '../../data/datasources/remote/firestore/firestore_service.dart';
import '../../data/repositories/location_repository_impl.dart';
import '../../data/repositories/trip_repository_impl.dart';
import '../../domain/repositories/location_repository.dart';
import '../../domain/repositories/trip_repository.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService.create();
});

final chopperClientProvider = Provider((ref) {
  final client = TravelChopperClient.create();
  ref.onDispose(client.dispose);
  return client;
});

final locationApiServiceProvider = Provider<LocationApiService>((ref) {
  final client = ref.watch(chopperClientProvider);
  return client.getService<LocationApiService>();
});

final preferencesServiceProvider =
    FutureProvider<PreferencesService>((ref) async {
  return PreferencesService.create();
});

final tripRepositoryProvider = Provider<TripRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final firestore = ref.watch(firestoreServiceProvider);
  return TripRepositoryImpl(db, firestore);
});

final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  final api = ref.watch(locationApiServiceProvider);
  return LocationRepositoryImpl(api);
});
