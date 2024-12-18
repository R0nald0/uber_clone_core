

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uber_clone_core/src/core/local_storage/local_storage.dart';


class LocalStorageImpl implements LocalStorage {
  Future<SharedPreferences> get _instance => SharedPreferences.getInstance();

  @override
  Future<V?> read<V>(String key) async {
    final preferences = await _instance;
    return preferences.get(key) as V?;
  }

  

  @override
  Future<bool?> remove(String key) async {
  
    final preference = await _instance;
    return  await preference.remove(key);
    
  }

  @override
  Future<bool> containsKey(String key) async {
    final preferences = await _instance;
    return preferences.containsKey(key);
  }

  @override
  Future<bool?> write<V>(String key, V value) async {
    final preference = await _instance;
     var isSuccefull = false;
    switch (V) {
      case String:
         isSuccefull = await preference.setString(key, value as String);
      case int:
        isSuccefull = await  preference.setInt(key, value as int);
      case bool:
         isSuccefull = await preference.setBool(key, value as bool);
      case double:
         isSuccefull =  await preference.setDouble(key, value as double);
      case <String>[]:
       isSuccefull = await preference.setStringList(key, value as List<String>);
    }
    return isSuccefull;
  }

  @override
  Future<bool> clear() async {
    final preference = await _instance;
    return preference.clear();
  }
}
