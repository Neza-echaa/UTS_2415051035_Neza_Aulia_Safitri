import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsProvider extends ChangeNotifier {
  static const String _themeKey = 'app_theme';
  static const String _languageKey = 'app_language';
  static const String _notificationKey = 'app_notifications';

  ThemeMode _themeMode = ThemeMode.light;
  Locale _locale = const Locale('id');
  bool _notificationsEnabled = true;

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;
  bool get notificationsEnabled => _notificationsEnabled;

  // Mengambil pengaturan yang sudah tersimpan.
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final savedTheme = prefs.getString(_themeKey);
    final savedLanguage = prefs.getString(_languageKey);

    if (savedTheme == 'dark') {
      _themeMode = ThemeMode.dark;
    } else if (savedTheme == 'system') {
      _themeMode = ThemeMode.system;
    } else {
      _themeMode = ThemeMode.light;
    }

    _locale = Locale(savedLanguage ?? 'id');

    _notificationsEnabled = prefs.getBool(_notificationKey) ?? true;

    notifyListeners();
  }

  // Menyimpan pilihan tema.
  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();

    _themeMode = mode;

    String themeValue;

    if (mode == ThemeMode.dark) {
      themeValue = 'dark';
    } else if (mode == ThemeMode.system) {
      themeValue = 'system';
    } else {
      themeValue = 'light';
    }

    await prefs.setString(_themeKey, themeValue);

    notifyListeners();
  }

  // Menyimpan pilihan bahasa.
  Future<void> setLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();

    _locale = Locale(languageCode);

    await prefs.setString(_languageKey, languageCode);

    notifyListeners();
  }

  // Menyimpan pengaturan notifikasi.
  Future<void> setNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    _notificationsEnabled = value;

    await prefs.setBool(_notificationKey, value);

    notifyListeners();
  }
}
