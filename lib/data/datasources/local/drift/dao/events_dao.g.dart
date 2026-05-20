// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events_dao.dart';

// ignore_for_file: type=lint
mixin _$EventsDaoMixin on DatabaseAccessor<AppDatabase> {
  $EventsTableTable get eventsTable => attachedDatabase.eventsTable;
  EventsDaoManager get managers => EventsDaoManager(this);
}

class EventsDaoManager {
  final _$EventsDaoMixin _db;
  EventsDaoManager(this._db);
  $$EventsTableTableTableManager get eventsTable =>
      $$EventsTableTableTableManager(_db.attachedDatabase, _db.eventsTable);
}
