import 'package:chopper/chopper.dart';
import '../../../../core/constants/app_constants.dart';
import 'location_api_service.dart';

class TravelChopperClient {
  static ChopperClient create() {
    return ChopperClient(
      baseUrl: Uri.parse(AppConstants.nominatimBaseUrl),
      services: [LocationApiService.create()],
      interceptors: [
        HeadersInterceptor(const {
          'User-Agent': AppConstants.nominatimUserAgent,
          'Accept': 'application/json',
        }),
        HttpLoggingInterceptor(),
      ],
      converter: const JsonConverter(),
    );
  }
}
