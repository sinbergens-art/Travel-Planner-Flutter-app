// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_model.dart';

// JsonSerializableGenerator

LocationModel _$LocationModelFromJson(Map<String, dynamic> json) =>
    LocationModel(
      placeId: json['place_id'].toString(),
      displayName: json['display_name'] as String,
      name: json['name'] as String?,
      lat: json['lat'] as String,
      lon: json['lon'] as String,
      type: json['type'] as String?,
      address: json['address'] == null
          ? null
          : AddressModel.fromJson(json['address'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LocationModelToJson(LocationModel instance) =>
    <String, dynamic>{
      'place_id': instance.placeId,
      'display_name': instance.displayName,
      'name': instance.name,
      'lat': instance.lat,
      'lon': instance.lon,
      'type': instance.type,
      'address': instance.address,
    };

AddressModel _$AddressModelFromJson(Map<String, dynamic> json) => AddressModel(
  country: json['country'] as String?,
  city: json['city'] as String?,
  state: json['state'] as String?,
);

Map<String, dynamic> _$AddressModelToJson(AddressModel instance) =>
    <String, dynamic>{
      'country': instance.country,
      'city': instance.city,
      'state': instance.state,
    };
