import 'dart:convert';
import 'package:chopper/chopper.dart';
import '../../domain/entities/location.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/remote/chopper/location_api_service.dart';
import '../models/location_model.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationApiService _apiService;

  LocationRepositoryImpl(this._apiService);

  @override
  Future<List<Location>> searchLocations(String query) async {
    if (query.trim().isEmpty) return [];

    final Response<dynamic> response =
        await _apiService.searchLocations(query);

    if (!response.isSuccessful || response.body == null) {
      throw Exception(
          'Failed to search locations: ${response.statusCode}');
    }

    // Chopper with JsonConverter returns the decoded body as dynamic.
    // It may be already a List, or still a raw String — handle both.
    List<dynamic> results;
    final body = response.body;
    if (body is List) {
      results = body;
    } else if (body is String) {
      results = json.decode(body) as List<dynamic>;
    } else if (body is Map) {
      // Unexpected shape — return empty
      return [];
    } else {
      results = json.decode(body.toString()) as List<dynamic>;
    }

    return results
        .map((j) =>
            LocationModel.fromJson(j as Map<String, dynamic>).toEntity())
        .toList();
  }
}
