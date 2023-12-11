import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_app/features/address/data/address.dart';
import 'package:grocery_app/features/address/repository/address_repository.dart';

final addressProvider = AsyncNotifierProvider<AddressNotifier, List<Address>>(
  () => AddressNotifier(),
);

class AddressNotifier extends AsyncNotifier<List<Address>> {
  AddressRepository get _addressRepository =>
      ref.read(addressRepositoryProvider);

  @override
  Future<List<Address>> build() => getAddresses();

  Future<List<Address>> getAddresses() async {
    return await _addressRepository.getAddresses();
  }

  Future<bool> addAddress(Address address) async {
    bool success = false;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      success = await _addressRepository.addAddress(address);
      if (success) {
        return await getAddresses();
      }
      return await getAddresses();
    });
    if (success) {
      return true;
    }
    return false;
  }

  Future<void> deleteAddress(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _addressRepository.deleteAddress(id);
      return await getAddresses();
    });
  }
}
