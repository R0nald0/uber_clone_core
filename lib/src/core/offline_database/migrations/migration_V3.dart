
import 'package:sqflite_common/sqlite_api.dart';
import 'package:uber_clone_core/src/constants/uber_clone_constants.dart';
import 'package:uber_clone_core/src/core/offline_database/migrations/migrations.dart';

class MigrationV3 implements Migrations{
  @override
  void create(Batch batch) {
    batch.execute(
      ''' CREATE TABLE ${UberCloneConstants.databasOfflineTableRequest}(
          id varchar(22) PRIMARY key,
          bairro varchar(50) not null,
          valorCorrida decimal(10,2) not null,
          status varchar(30),
          passageiroNome varchar(200),
          motoristaNome varchar(200),
          request_date datetime,
          payment_type varchar(50)
        )
'''
    );
  }

  @override
  void upgrade(Batch batch) {
    batch.execute(
      ''' CREATE TABLE request(
          id varchar(22) PRIMARY key,
          bairro varchar(50) not null,
          valorCorrida decimal(10,2) not null,
          status varchar(30),
          passageiroNome varchar(200),
          motoristaNome varchar(200),
          request_date datetime,
          payment_type varchar(50)
        )
      '''
    );
  }
  
}