import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class SecureStorage {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
  Future<void> deleteAll();
  Future<bool> containsKey(String key);
  Future<Map<String, String>> readAll();
}

class FlutterSecureStorageImpl implements SecureStorage {
  FlutterSecureStorageImpl({FlutterSecureStorage? storage})
    : _storage =
          storage ??
          const FlutterSecureStorage(
            iOptions: IOSOptions(
              accessibility: KeychainAccessibility.first_unlock,
            ),
          );

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) async => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) async =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) async => _storage.delete(key: key);

  @override
  Future<void> deleteAll() async => _storage.deleteAll();

  @override
  Future<bool> containsKey(String key) async => _storage.containsKey(key: key);

  @override
  Future<Map<String, String>> readAll() async => _storage.readAll();
}

class SecureStorageKeys {
  SecureStorageKeys._();

  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
}
