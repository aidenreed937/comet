import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/di.dart';
import '../storage/key_value_storage.dart';

/// Storage key for theme mode persistence
const String _themeModeKey = 'theme_mode';

/// Theme mode notifier for managing app theme state
class ThemeModeNotifier extends Notifier<ThemeMode> {
  late KeyValueStorage _storage;

  @override
  ThemeMode build() {
    _storage = ref.watch(keyValueStorageProvider);
    _loadThemeMode();
    return ThemeMode.system;
  }

  Future<void> _loadThemeMode() async {
    final savedMode = await _storage.getString(_themeModeKey);
    if (savedMode != null) {
      state = ThemeMode.values.firstWhere(
        (mode) => mode.name == savedMode,
        orElse: () => ThemeMode.system,
      );
    }
  }

  /// Set theme mode and persist to storage
  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _storage.setString(_themeModeKey, mode.name);
  }

  /// Toggle between light and dark mode
  /// If current is system, will switch to light
  Future<void> toggleThemeMode() async {
    final newMode = switch (state) {
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.light,
      ThemeMode.system => ThemeMode.light,
    };
    await setThemeMode(newMode);
  }

  /// Set to light mode
  Future<void> setLightMode() => setThemeMode(ThemeMode.light);

  /// Set to dark mode
  Future<void> setDarkMode() => setThemeMode(ThemeMode.dark);

  /// Set to system mode (follow device settings)
  Future<void> setSystemMode() => setThemeMode(ThemeMode.system);

  /// Check if current theme is dark
  bool get isDarkMode => state == ThemeMode.dark;

  /// Check if current theme is light
  bool get isLightMode => state == ThemeMode.light;

  /// Check if using system theme
  bool get isSystemMode => state == ThemeMode.system;
}

/// Provider for theme mode state management
final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(() {
  return ThemeModeNotifier();
});

/// Extension for easy theme access from WidgetRef
extension ThemeRefExtension on WidgetRef {
  /// Get current theme mode
  ThemeMode get themeMode => watch(themeModeProvider);

  /// Get theme mode notifier for mutations
  ThemeModeNotifier get themeModeNotifier => read(themeModeProvider.notifier);

  /// Toggle theme mode
  Future<void> toggleTheme() => themeModeNotifier.toggleThemeMode();
}
