import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_getit/flutter_getit.dart';
import 'package:uber_clone_core/src/core/local_storage/impl/local_storage_impl.dart';
import 'package:uber_clone_core/src/core/logger/impl/app_uber_log_impl.dart';
import 'package:uber_clone_core/src/core/offline_database/database_off_line.dart';
import 'package:uber_clone_core/src/core/offline_database/impl/database_impl.dart';
import 'package:uber_clone_core/src/repository/auth_repository/I_auth_repository.dart';
import 'package:uber_clone_core/src/repository/auth_repository/repository_impl/auth_repository_impl.dart';
import 'package:uber_clone_core/src/repository/location_repository/i_location_repository.dart';
import 'package:uber_clone_core/src/repository/location_repository/location_repository_impl.dart';
import 'package:uber_clone_core/src/repository/requisition_repository/i_requisition_repository.dart';
import 'package:uber_clone_core/src/repository/requisition_repository/impl/requisition_repository.dart';
import 'package:uber_clone_core/src/repository/user_repository/impl/user_repository_impl.dart';
import 'package:uber_clone_core/src/services/authservice/auth_service_impl.dart';
import 'package:uber_clone_core/src/services/location_service/location_service_impl.dart';
import 'package:uber_clone_core/src/services/requisitionService/impl/requisiton_service_impl.dart';
import 'package:uber_clone_core/src/services/trip_service/trip_service.dart';
import 'package:uber_clone_core/src/services/user_service/impl/user_service_impl.dart';
import 'package:uber_clone_core/uber_clone_core.dart';

class AplicationBinding extends ApplicationBindings {
  @override
  List<Bind<Object>> bindings() => [
        Bind.lazySingleton<DatabaseOffLine>((i) => DatabaseImpl()),
        Bind.lazySingleton<IAppUberLog>((i) => AppUberLogImpl()),
        Bind.lazySingleton<LocalStorage>((i) => LocalStorageImpl()),
        Bind.lazySingleton((i) => FirebaseFirestore.instance),
      
        Bind.lazySingleton<IRequestRepository>(
            (i) => RequisitionRepository(logger: i(), localStorage: i(), firestore: i())),
        Bind.lazySingleton<IAuthRepository>(
            (i) => AuthRepositoryImpl(database: i(), logger: i())),
        Bind.lazySingleton<IUserRepository>(
            (i) => UserRepositoryImpl( database: i(), localStoreage: i(), log: i())),
        Bind.lazySingleton<ILocationRepository>(
            (i) => LocationRepositoryImpl(log: i())),


        Bind.lazySingleton<ITripSerivce>(
            (i) => TripService(locationRepositoryImpl: i())),
        Bind.lazySingleton<IRequistionService>((i) => RequisitonServiceImpl(
            requisitonRepository: i(),
            authRepository: i(),
            log: i(),
            userRepository: i())),
        Bind.lazySingleton<ILocationService>(
            (i) => LocationServiceImpl(locationRepositoryImpl: i(), log: i())),
        Bind.lazySingleton<UserService>(
            (i) => UserServiceImpl(userRepository: i())),
        Bind.lazySingleton<IAuthService>((i) => AuthServiceImpl(
            localStorage: i(),
            log: i(),
            authrepository: i(),
            userRepository: i()))
      ];
}
