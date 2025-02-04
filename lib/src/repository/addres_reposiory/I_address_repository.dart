import 'package:uber_clone_core/uber_clone_core.dart';

abstract interface class IAddressRepository {
  Future<List<Address>> getAddrss();
  Future<int> saveAddres(Address address);
}