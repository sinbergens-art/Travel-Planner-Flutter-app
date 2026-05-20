class AppConstants {
  AppConstants._();

  // API
  static const String nominatimBaseUrl = 'https://nominatim.openstreetmap.org';
  static const String nominatimUserAgent = 'TravelPlannerApp/1.0';
  static const int apiTimeoutSeconds = 15;
  static const int searchResultLimit = 10;

  // SharedPreferences keys
  static const String keyIsDarkMode = 'is_dark_mode';
  static const String keyUserName = 'user_name';
  static const String keyUserId = 'user_id';

  // Firestore collections
  static const String collectionSharedTrips = 'shared_trips';
  static const String collectionParticipants = 'participants';

  // UI
  static const double cardBorderRadius = 16.0;
  static const double pagePadding = 16.0;
  static const double gridSpacing = 12.0;
  static const int gridCrossAxisCount = 2;
}
