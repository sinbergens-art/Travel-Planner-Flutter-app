import 'package:drift/drift.dart';

class TripsTable extends Table {
  @override
  String get tableName => 'trips';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  TextColumn get destination => text()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  TextColumn get description => text().nullable()();
  BoolColumn get isShared =>
      boolean().withDefault(const Constant(false))();
  TextColumn get firestoreId => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}
