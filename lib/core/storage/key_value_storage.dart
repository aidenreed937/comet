import 'package:shared_preferences/shared_preferences.dart';

abstract class KeyValueStorage {
  Future<String?> getString(String key);
  Future<bool> setString(String key, String value);
  Future<int?> getInt(String key);
  Future<bool> setInt(String key, int value);
  Future<double?> getDouble(String key);
  Future<bool> setDouble(String key, double value);
  Future<bool?> getBool(String key);
  Future<bool> setBool(String key, {required bool value});
  Future<List<String>?> getStringList(String key);
  Future<bool> setStringList(String key, List<String> value);
  Future<bool> remove(String key);
  Future<bool> clear();
  Future<bool> containsKey(String key);
}

class SharedPreferencesStorage implements KeyValueStorage {
  SharedPreferencesStorage(this._prefs);

  final SharedPreferences _prefs;

  static Future<SharedPreferencesStorage> create() async {
    final prefs = await SharedPreferences.getInstance();
    return SharedPreferencesStorage(prefs);
  }

  @override
  Future<String?> getString(String key) async => _prefs.getString(key);

  @override
  Future<bool> setString(String key, String value) async =>
      _prefs.setString(key, value);

  @override
  Future<int?> getInt(String key) async => _prefs.getInt(key);

  @override
  Future<bool> setInt(String key, int value) async => _prefs.setInt(key, value);

  @override
  Future<double?> getDouble(String key) async => _prefs.getDouble(key);

  @override
  Future<bool> setDouble(String key, double value) async =>
      _prefs.setDouble(key, value);

  @override
  Future<bool?> getBool(String key) async => _prefs.getBool(key);

  @override
  Future<bool> setBool(String key, {required bool value}) async =>
      _prefs.setBool(key, value);

  @override
  Future<List<String>?> getStringList(String key) async =>
      _prefs.getStringList(key);

  @override
  Future<bool> setStringList(String key, List<String> value) async =>
      _prefs.setStringList(key, value);

  @override
  Future<bool> remove(String key) async => _prefs.remove(key);

  @override
  Future<bool> clear() async => _prefs.clear();

  @override
  Future<bool> containsKey(String key) async => _prefs.containsKey(key);
}
