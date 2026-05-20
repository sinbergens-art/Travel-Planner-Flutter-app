import 'package:chopper/chopper.dart';

part 'location_api_service.chopper.dart';

@ChopperApi(baseUrl: '/search')
abstract class LocationApiService extends ChopperService {
  static LocationApiService create([ChopperClient? client]) =>
      _$LocationApiService(client);

  /// GET /search?q={query}&format=json&limit=10&addressdetails=1
  @Get()
  Future<Response<dynamic>> searchLocations(
    @Query('q') String query, {
    @Query('format') String format = 'json',
    @Query('limit') int limit = 10,
    @Query('addressdetails') int addressdetails = 1,
  });
}
