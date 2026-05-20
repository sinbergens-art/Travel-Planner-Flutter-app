import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/trips_table.dart';
import 'tables/events_table.dart';
import 'dao/trips_dao.dart';
import 'dao/events_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [TripsTable, EventsTable], daos: [TripsDao, EventsDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {},
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'travel_planner.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
