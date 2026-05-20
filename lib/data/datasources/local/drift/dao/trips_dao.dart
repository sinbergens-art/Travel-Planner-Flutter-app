import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/trips_table.dart';

part 'trips_dao.g.dart';

@DriftAccessor(tables: [TripsTable])
class TripsDao extends DatabaseAccessor<AppDatabase> with _$TripsDaoMixin {
  TripsDao(super.db);

  Stream<List<TripsTableData>> watchAllTrips() =>
      (select(tripsTable)..orderBy([(t) => OrderingTerm.desc(t.startDate)]))
          .watch();

  Future<List<TripsTableData>> getAllTrips() =>
      (select(tripsTable)..orderBy([(t) => OrderingTerm.desc(t.startDate)]))
          .get();

  Future<TripsTableData?> getTripById(int id) =>
      (select(tripsTable)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> insertTrip(TripsTableCompanion entry) =>
      into(tripsTable).insert(entry);

  Future<bool> updateTrip(TripsTableCompanion entry) =>
      update(tripsTable).replace(entry);

  Future<int> deleteTrip(int id) =>
      (delete(tripsTable)..where((t) => t.id.equals(id))).go();
}
