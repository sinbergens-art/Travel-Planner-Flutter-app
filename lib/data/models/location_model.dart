import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/location.dart';

part 'location_model.g.dart';

@JsonSerializable()
class LocationModel {
  @JsonKey(name: 'place_id')
  final String placeId;

  @JsonKey(name: 'display_name')
  final String displayName;

  final String? name;
  final String lat;
  final String lon;
  final String? type;

  @JsonKey(name: 'address')
  final AddressModel? address;

  const LocationModel({
    required this.placeId,
    required this.displayName,
    this.name,
    required this.lat,
    required this.lon,
    this.type,
    this.address,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) =>
      _$LocationModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocationModelToJson(this);

  Location toEntity() => Location(
        placeId: placeId,
        displayName: displayName,
        shortName: name ?? displayName.split(',').first.trim(),
        latitude: double.tryParse(lat) ?? 0.0,
        longitude: double.tryParse(lon) ?? 0.0,
        country: address?.country,
        type: type,
      );
}

@JsonSerializable()
class AddressModel {
  final String? country;
  final String? city;
  final String? state;

  const AddressModel({this.country, this.city, this.state});

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddressModelToJson(this);
}
