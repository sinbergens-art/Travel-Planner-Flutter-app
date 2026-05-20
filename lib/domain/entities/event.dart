import 'package:equatable/equatable.dart';

class TripEvent extends Equatable {
  final int? id;
  final int tripId;
  final String title;
  final String? location;
  final DateTime dateTime;
  final String? notes;
  final bool isCompleted;

  const TripEvent({
    this.id,
    required this.tripId,
    required this.title,
    this.location,
    required this.dateTime,
    this.notes,
    this.isCompleted = false,
  });

  TripEvent copyWith({
    int? id,
    int? tripId,
    String? title,
    String? location,
    DateTime? dateTime,
    String? notes,
    bool? isCompleted,
  }) {
    return TripEvent(
      id: id ?? this.id,
      tripId: tripId ?? this.tripId,
      title: title ?? this.title,
      location: location ?? this.location,
      dateTime: dateTime ?? this.dateTime,
      notes: notes ?? this.notes,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props =>
      [id, tripId, title, location, dateTime, notes, isCompleted];
}
