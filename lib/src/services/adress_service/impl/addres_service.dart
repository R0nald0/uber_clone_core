
import 'package:uber_clone_core/src/model/addres.dart';
import 'package:uber_clone_core/src/repository/addres_reposiory/I_address_repository.dart';
import 'package:uber_clone_core/src/services/adress_service/i_addres_service.dart';

class AddresService implements IAddresService{
   final IAddressRepository _repository;
   AddresService({required IAddressRepository addressRepository})
    : _repository = addressRepository,
    super();
  
  @override
  Future<List<Address>> getAddrss() => _repository.getAddrss(); 

  @override
  Future<int> saveAddres(Address address) => _repository.saveAddres(address);
  
}