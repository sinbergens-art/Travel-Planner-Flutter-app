import 'package:drift/drift.dart';

class EventsTable extends Table {
  @override
  String get tableName => 'events';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get tripId => integer()();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  TextColumn get location => text().nullable()();
  DateTimeColumn get scheduledAt => dateTime()();
  TextColumn get notes => text().nullable()();
  BoolColumn get isCompleted =>
      boolean().withDefault(const Constant(false))();
}
