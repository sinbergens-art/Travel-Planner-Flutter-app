import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database_provider.dart';

class ThemeNotifier extends Notifier<bool> {
  @override
  bool build() {
    final prefsAsync = ref.watch(preferencesServiceProvider);
    return prefsAsync.whenOrNull(data: (p) => p.isDarkMode) ?? false;
  }
  void setDark(bool value) => state = value;
}

final themeProvider =
    NotifierProvider<ThemeNotifier, bool>(ThemeNotifier.new);
