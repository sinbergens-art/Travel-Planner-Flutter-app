import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/events_table.dart';

part 'events_dao.g.dart';

@DriftAccessor(tables: [EventsTable])
class EventsDao extends DatabaseAccessor<AppDatabase> with _$EventsDaoMixin {
  EventsDao(super.db);

  Stream<List<EventsTableData>> watchEventsByTrip(int tripId) =>
      (select(eventsTable)
            ..where((e) => e.tripId.equals(tripId))
            ..orderBy([(e) => OrderingTerm.asc(e.scheduledAt)]))
          .watch();

  Future<List<EventsTableData>> getEventsByTrip(int tripId) =>
      (select(eventsTable)
            ..where((e) => e.tripId.equals(tripId))
            ..orderBy([(e) => OrderingTerm.asc(e.scheduledAt)]))
          .get();

  Future<int> insertEvent(EventsTableCompanion entry) =>
      into(eventsTable).insert(entry);

  Future<bool> updateEvent(EventsTableCompanion entry) =>
      update(eventsTable).replace(entry);

  Future<int> deleteEvent(int id) =>
      (delete(eventsTable)..where((e) => e.id.equals(id))).go();
}
