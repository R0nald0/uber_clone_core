import 'package:sqflite/sqflite.dart';
import 'package:uber_clone_core/src/core/exceptions/addres_exception.dart';
import 'package:uber_clone_core/src/core/logger/i_app_uber_log.dart';
import 'package:uber_clone_core/src/core/offline_database/database_off_line.dart';
import 'package:uber_clone_core/src/model/addres.dart';
import 'package:uber_clone_core/src/repository/addres_reposiory/I_address_repository.dart';

class AddressRepositoryImpl  implements IAddressRepository {
  final DatabaseOffLine _database;
  final IAppUberLog _log;


  AddressRepositoryImpl(
      {required DatabaseOffLine database, required IAppUberLog log})
      : _database = database,
        _log = log;

  @override
  Future<List<Address>> getAddrss()async{
      try {
        final result  = await _database.findAllData('address');
        final addres =result.map((element) => Address.fromMap(element)).toList(); 
        return  addres;
      }on DatabaseException catch (e,s) {
        const message =' erro ao buscar dados no banco';
          
        _log.erro(message,e,s);
        throw AddresException(message: message);
      }
  }
  
  @override
  Future<int> saveAddres(Address address) async {
    try {
      const query = 'INSERT INTO Address VALUES(?,?,?,?,?,?,?,?,?,?)';
      final arguments = <Object?>[
          address.id,
          address.nomeDestino,
          address.cep,
          address.favorite,
          address.cidade,
          address.rua,
          address.numero,
          address.bairro,
          address.latitude,
          address.longitude,
      ];
      return await _database.save(query, arguments);
    } on DatabaseException catch (e, s) {
       const message = 'erro ao salvar dados do Endereço';
      _log.erro(message, e, s);
       throw AddresException(message: message);
    }
  }
}
