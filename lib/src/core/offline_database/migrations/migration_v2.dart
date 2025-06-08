

import 'package:sqflite/sqflite.dart';
import 'package:uber_clone_core/src/constants/uber_clone_constants.dart';
import 'package:uber_clone_core/src/core/offline_database/migrations/migrations.dart';

class MigrationV2 extends Migrations {
  @override
  void create(Batch batch) {
    const adress = UberCloneConstants.databasOfflineTableAdress;
    batch.execute('''
             CREATE TABLE IF NOT EXISTS $adress(
                id Integer PRIMARY KEY AUTOINCREMENT UNIQUE,
                nomeDestino text NOT NULL ,
                cep text UNIQUE,
                favorite bool,
                cidade text not null,
                rua text ,
                numero text ,
                bairro text ,
                latitude text NOT null,
                longitude text NOT null
             )
                   
           ''');
  }

  @override
  void upgrade(Batch batch) {
     const adress = UberCloneConstants.databasOfflineTableAdress;
      batch.execute('''
               CREATE TABLE IF NOT EXISTS $adress(
                id Integer PRIMARY KEY AUTOINCREMENT UNIQUE,
                nomeDestino text NOT NULL ,
                cep text UNIQUE,
                favorite bool,
                cidade text not null,
                rua text ,
                numero text ,
                bairro text ,
                latitude text NOT null,
                longitude text NOT null
             )
                   
           ''');

  }
}
