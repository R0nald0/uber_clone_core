import 'package:uber_clone_core/uber_clone_core.dart';

abstract interface class IAddresService {

  Future<List<Address>> getAddrss();
  Future<int> saveAddres(Address address);
}