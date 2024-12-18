abstract class LocalStorage {
  Future<bool> containsKey(String key);
  Future<V?> read<V>(String key);
  Future<bool?> remove(String key);
  Future<bool?> write<V>(String key, V value);
  Future<bool?> clear();
}
