

import 'package:uber_clone_core/src/core/offline_database/migrations/migration_V1.dart';
import 'package:uber_clone_core/src/core/offline_database/migrations/migration_v2.dart';
import 'package:uber_clone_core/src/core/offline_database/migrations/migrations.dart';


class MigrationsFactory {
   List<Migrations> getCreateMigration() =>[
    MigrationV1(),
    MigrationV2()
   ];


   List<Migrations> getUpdateMigration(int versioOld){
     if (versioOld == 2) {
         return [ 
          MigrationV1(),
          MigrationV2()
          ];
     }
     return [];
   }
}