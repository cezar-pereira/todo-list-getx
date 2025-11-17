import 'package:shared_preferences/shared_preferences.dart';

import 'storage_service.dart';

class StorageServiceImpl implements StorageService {
  SharedPreferences? _prefs;
  Future<SharedPreferences> get prefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  @override
  Future<String?> getString(String key) async {
    final prefsInstance = await prefs;
    return prefsInstance.getString(key);
  }

  @override
  Future<void> setString(String key, String value) async {
    final prefsInstance = await prefs;
    await prefsInstance.setString(key, value);
  }

  @override
  Future<bool?> getBool(String key) async {
    final prefsInstance = await prefs;
    return prefsInstance.getBool(key);
  }

  @override
  Future<void> setBool(String key, bool value) async {
    final prefsInstance = await prefs;
    await prefsInstance.setBool(key, value);
  }

  @override
  Future<int?> getInt(String key) async {
    final prefsInstance = await prefs;
    return prefsInstance.getInt(key);
  }

  @override
  Future<void> setInt(String key, int value) async {
    final prefsInstance = await prefs;
    await prefsInstance.setInt(key, value);
  }

  @override
  Future<double?> getDouble(String key) async {
    final prefsInstance = await prefs;
    return prefsInstance.getDouble(key);
  }

  @override
  Future<void> setDouble(String key, double value) async {
    final prefsInstance = await prefs;
    await prefsInstance.setDouble(key, value);
  }

  @override
  Future<List<String>?> getStringList(String key) async {
    final prefsInstance = await prefs;
    return prefsInstance.getStringList(key);
  }

  @override
  Future<void> setStringList(String key, List<String> value) async {
    final prefsInstance = await prefs;
    await prefsInstance.setStringList(key, value);
  }

  @override
  Future<void> remove(String key) async {
    final prefsInstance = await prefs;
    await prefsInstance.remove(key);
  }

  @override
  Future<void> clear() async {
    final prefsInstance = await prefs;
    await prefsInstance.clear();
  }

  @override
  Future<bool> containsKey(String key) async {
    final prefsInstance = await prefs;
    return prefsInstance.containsKey(key);
  }
}
