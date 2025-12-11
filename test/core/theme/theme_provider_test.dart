import 'package:comet/app/di.dart';
import 'package:comet/core/storage/key_value_storage.dart';
import 'package:comet/core/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockKeyValueStorage extends Mock implements KeyValueStorage {}

void main() {
  late MockKeyValueStorage mockStorage;
  late ProviderContainer container;

  setUp(() {
    mockStorage = MockKeyValueStorage();
  });

  tearDown(() {
    container.dispose();
  });

  ProviderContainer createContainer() {
    return ProviderContainer(
      overrides: [keyValueStorageProvider.overrideWithValue(mockStorage)],
    );
  }

  group('ThemeModeNotifier', () {
    test('initial state is ThemeMode.system', () {
      when(() => mockStorage.getString(any())).thenAnswer((_) async => null);

      container = createContainer();
      final themeMode = container.read(themeModeProvider);

      expect(themeMode, equals(ThemeMode.system));
    });

    test('setThemeMode updates state and persists', () async {
      when(() => mockStorage.getString(any())).thenAnswer((_) async => null);
      when(
        () => mockStorage.setString(any(), any()),
      ).thenAnswer((_) async => true);

      container = createContainer();
      final notifier = container.read(themeModeProvider.notifier);

      await notifier.setThemeMode(ThemeMode.dark);

      expect(container.read(themeModeProvider), equals(ThemeMode.dark));
      verify(() => mockStorage.setString('theme_mode', 'dark')).called(1);
    });

    test('toggleThemeMode cycles through modes', () async {
      when(() => mockStorage.getString(any())).thenAnswer((_) async => null);
      when(
        () => mockStorage.setString(any(), any()),
      ).thenAnswer((_) async => true);

      container = createContainer();
      final notifier = container.read(themeModeProvider.notifier);

      // system -> light
      await notifier.toggleThemeMode();
      expect(container.read(themeModeProvider), equals(ThemeMode.light));

      // light -> dark
      await notifier.toggleThemeMode();
      expect(container.read(themeModeProvider), equals(ThemeMode.dark));

      // dark -> light
      await notifier.toggleThemeMode();
      expect(container.read(themeModeProvider), equals(ThemeMode.light));
    });

    test('setLightMode sets theme to light', () async {
      when(() => mockStorage.getString(any())).thenAnswer((_) async => null);
      when(
        () => mockStorage.setString(any(), any()),
      ).thenAnswer((_) async => true);

      container = createContainer();
      final notifier = container.read(themeModeProvider.notifier);

      await notifier.setLightMode();

      expect(container.read(themeModeProvider), equals(ThemeMode.light));
      verify(() => mockStorage.setString('theme_mode', 'light')).called(1);
    });

    test('setDarkMode sets theme to dark', () async {
      when(() => mockStorage.getString(any())).thenAnswer((_) async => null);
      when(
        () => mockStorage.setString(any(), any()),
      ).thenAnswer((_) async => true);

      container = createContainer();
      final notifier = container.read(themeModeProvider.notifier);

      await notifier.setDarkMode();

      expect(container.read(themeModeProvider), equals(ThemeMode.dark));
      verify(() => mockStorage.setString('theme_mode', 'dark')).called(1);
    });

    test('setSystemMode sets theme to system', () async {
      when(() => mockStorage.getString(any())).thenAnswer((_) async => null);
      when(
        () => mockStorage.setString(any(), any()),
      ).thenAnswer((_) async => true);

      container = createContainer();
      final notifier = container.read(themeModeProvider.notifier);

      // First set to dark
      await notifier.setDarkMode();
      expect(container.read(themeModeProvider), equals(ThemeMode.dark));

      // Then set to system
      await notifier.setSystemMode();
      expect(container.read(themeModeProvider), equals(ThemeMode.system));
      verify(() => mockStorage.setString('theme_mode', 'system')).called(1);
    });

    group('helper getters', () {
      test('isDarkMode returns correct value', () async {
        when(() => mockStorage.getString(any())).thenAnswer((_) async => null);
        when(
          () => mockStorage.setString(any(), any()),
        ).thenAnswer((_) async => true);

        container = createContainer();
        final notifier = container.read(themeModeProvider.notifier);

        expect(notifier.isDarkMode, isFalse);

        await notifier.setDarkMode();
        expect(notifier.isDarkMode, isTrue);
      });

      test('isLightMode returns correct value', () async {
        when(() => mockStorage.getString(any())).thenAnswer((_) async => null);
        when(
          () => mockStorage.setString(any(), any()),
        ).thenAnswer((_) async => true);

        container = createContainer();
        final notifier = container.read(themeModeProvider.notifier);

        expect(notifier.isLightMode, isFalse);

        await notifier.setLightMode();
        expect(notifier.isLightMode, isTrue);
      });

      test('isSystemMode returns correct value', () async {
        when(() => mockStorage.getString(any())).thenAnswer((_) async => null);

        container = createContainer();
        final notifier = container.read(themeModeProvider.notifier);

        expect(notifier.isSystemMode, isTrue);
      });
    });
  });
}
