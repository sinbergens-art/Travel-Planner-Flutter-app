import 'package:equatable/equatable.dart';

class Trip extends Equatable {
  final int? id;
  final String title;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final String? description;
  final bool isShared;
  final String? firestoreId;

  const Trip({
    this.id,
    required this.title,
    required this.destination,
    required this.startDate,
    required this.endDate,
    this.description,
    this.isShared = false,
    this.firestoreId,
  });

  Trip copyWith({
    int? id,
    String? title,
    String? destination,
    DateTime? startDate,
    DateTime? endDate,
    String? description,
    bool? isShared,
    String? firestoreId,
  }) {
    return Trip(
      id: id ?? this.id,
      title: title ?? this.title,
      destination: destination ?? this.destination,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      description: description ?? this.description,
      isShared: isShared ?? this.isShared,
      firestoreId: firestoreId ?? this.firestoreId,
    );
  }

  @override
  List<Object?> get props => [
        id, title, destination, startDate, endDate,
        description, isShared, firestoreId,
      ];
}
