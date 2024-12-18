

import 'package:sqflite/sqflite.dart';

import 'migrations.dart';

class MigrationV1 implements Migrations {
  @override
  void create(Batch batch) {
      batch.execute(
        '''CREATE TABLE usuario(
           id text not null,
           email text not null,
           name text not null,
           lat text,
           long text
         )
        '''
      );
  }

  @override
  void upgrade(Batch batch) {
      
  }

}