// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$LocationApiService extends LocationApiService {
  _$LocationApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = LocationApiService;

  @override
  Future<Response<dynamic>> searchLocations(
    String query, {
    String format = 'json',
    int limit = 10,
    int addressdetails = 1,
  }) async {
    final Uri $url = Uri.parse('/search');
    final Map<String, dynamic> $params = <String, dynamic>{
      'q': query,
      'format': format,
      'limit': limit,
      'addressdetails': addressdetails,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
