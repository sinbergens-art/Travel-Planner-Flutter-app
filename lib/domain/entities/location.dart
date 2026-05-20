import 'package:equatable/equatable.dart';

class Location extends Equatable {
  final String placeId;
  final String displayName;
  final String shortName;
  final double latitude;
  final double longitude;
  final String? country;
  final String? type;

  const Location({
    required this.placeId,
    required this.displayName,
    required this.shortName,
    required this.latitude,
    required this.longitude,
    this.country,
    this.type,
  });

  @override
  List<Object?> get props =>
      [placeId, displayName, shortName, latitude, longitude, country, type];
}
