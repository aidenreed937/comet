import 'package:comet/core/storage/key_value_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences mockPrefs;
  late SharedPreferencesStorage storage;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    storage = SharedPreferencesStorage(mockPrefs);
  });

  group('SharedPreferencesStorage', () {
    group('getString', () {
      test('returns value when key exists', () async {
        when(() => mockPrefs.getString('test_key')).thenReturn('test_value');

        final result = await storage.getString('test_key');

        expect(result, equals('test_value'));
        verify(() => mockPrefs.getString('test_key')).called(1);
      });

      test('returns null when key does not exist', () async {
        when(() => mockPrefs.getString('test_key')).thenReturn(null);

        final result = await storage.getString('test_key');

        expect(result, isNull);
      });
    });

    group('setString', () {
      test('stores value and returns true on success', () async {
        when(() => mockPrefs.setString('test_key', 'test_value'))
            .thenAnswer((_) async => true);

        final result = await storage.setString('test_key', 'test_value');

        expect(result, isTrue);
        verify(() => mockPrefs.setString('test_key', 'test_value')).called(1);
      });
    });

    group('getInt', () {
      test('returns value when key exists', () async {
        when(() => mockPrefs.getInt('test_key')).thenReturn(42);

        final result = await storage.getInt('test_key');

        expect(result, equals(42));
      });

      test('returns null when key does not exist', () async {
        when(() => mockPrefs.getInt('test_key')).thenReturn(null);

        final result = await storage.getInt('test_key');

        expect(result, isNull);
      });
    });

    group('setInt', () {
      test('stores value and returns true on success', () async {
        when(() => mockPrefs.setInt('test_key', 42))
            .thenAnswer((_) async => true);

        final result = await storage.setInt('test_key', 42);

        expect(result, isTrue);
      });
    });

    group('getDouble', () {
      test('returns value when key exists', () async {
        when(() => mockPrefs.getDouble('test_key')).thenReturn(3.14);

        final result = await storage.getDouble('test_key');

        expect(result, equals(3.14));
      });
    });

    group('setDouble', () {
      test('stores value and returns true on success', () async {
        when(() => mockPrefs.setDouble('test_key', 3.14))
            .thenAnswer((_) async => true);

        final result = await storage.setDouble('test_key', 3.14);

        expect(result, isTrue);
      });
    });

    group('getBool', () {
      test('returns value when key exists', () async {
        when(() => mockPrefs.getBool('test_key')).thenReturn(true);

        final result = await storage.getBool('test_key');

        expect(result, isTrue);
      });
    });

    group('setBool', () {
      test('stores value and returns true on success', () async {
        when(() => mockPrefs.setBool('test_key', true))
            .thenAnswer((_) async => true);

        final result = await storage.setBool('test_key', value: true);

        expect(result, isTrue);
      });
    });

    group('getStringList', () {
      test('returns value when key exists', () async {
        when(() => mockPrefs.getStringList('test_key'))
            .thenReturn(['a', 'b', 'c']);

        final result = await storage.getStringList('test_key');

        expect(result, equals(['a', 'b', 'c']));
      });
    });

    group('setStringList', () {
      test('stores value and returns true on success', () async {
        when(() => mockPrefs.setStringList('test_key', ['a', 'b']))
            .thenAnswer((_) async => true);

        final result = await storage.setStringList('test_key', ['a', 'b']);

        expect(result, isTrue);
      });
    });

    group('remove', () {
      test('removes key and returns true on success', () async {
        when(() => mockPrefs.remove('test_key')).thenAnswer((_) async => true);

        final result = await storage.remove('test_key');

        expect(result, isTrue);
        verify(() => mockPrefs.remove('test_key')).called(1);
      });
    });

    group('clear', () {
      test('clears all keys and returns true on success', () async {
        when(() => mockPrefs.clear()).thenAnswer((_) async => true);

        final result = await storage.clear();

        expect(result, isTrue);
        verify(() => mockPrefs.clear()).called(1);
      });
    });

    group('containsKey', () {
      test('returns true when key exists', () async {
        when(() => mockPrefs.containsKey('test_key')).thenReturn(true);

        final result = await storage.containsKey('test_key');

        expect(result, isTrue);
      });

      test('returns false when key does not exist', () async {
        when(() => mockPrefs.containsKey('test_key')).thenReturn(false);

        final result = await storage.containsKey('test_key');

        expect(result, isFalse);
      });
    });
  });
}
