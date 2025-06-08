

import 'package:uber_clone_core/src/core/offline_database/migrations/migration_V1.dart';
import 'package:uber_clone_core/src/core/offline_database/migrations/migration_V3.dart';
import 'package:uber_clone_core/src/core/offline_database/migrations/migration_v2.dart';
import 'package:uber_clone_core/src/core/offline_database/migrations/migrations.dart';


class MigrationsFactory {
   List<Migrations> getCreateMigration() =>[
    MigrationV1(),
    MigrationV2(),
    MigrationV3(),
   ];
   List<Migrations> getUpdateMigration(int versionOld){
     if (versionOld == 2) {
         return [ 
          MigrationV2(),
          MigrationV3()
          ];
      }
     if(versionOld == 3){
       return [
        MigrationV3()
       ] ;
     }
     return [];
   }
}