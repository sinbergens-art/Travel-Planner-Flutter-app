import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';

class PreferencesService {
  final SharedPreferences _prefs;

  PreferencesService(this._prefs);

  static Future<PreferencesService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return PreferencesService(prefs);
  }

  // Dark Mode
  bool get isDarkMode => _prefs.getBool(AppConstants.keyIsDarkMode) ?? false;

  Future<void> setDarkMode(bool value) =>
      _prefs.setBool(AppConstants.keyIsDarkMode, value);

  // User Name
  String get userName =>
      _prefs.getString(AppConstants.keyUserName) ?? 'Traveler';

  Future<void> setUserName(String name) =>
      _prefs.setString(AppConstants.keyUserName, name);

  // User ID
  String get userId => _prefs.getString(AppConstants.keyUserId) ?? _generateId();

  Future<void> setUserId(String id) =>
      _prefs.setString(AppConstants.keyUserId, id);

  String _generateId() {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    _prefs.setString(AppConstants.keyUserId, id);
    return id;
  }
}
