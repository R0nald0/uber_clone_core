

abstract class DatabaseOffLine {
   
  Future<int> save(String query,List<Object?>? arguments);
   Future<int> update(String tableName , List<Object?>? arguments);
   Future<List<Map<String, Object?>>> findAllData(String tableName);
   Future<int> delete( String tableName,String idData);
   Future<int> clearTable(String tableName) ;
 
}