import 'package:arungi_rasa/common/error_reporter.dart';
import 'package:arungi_rasa/model/address.dart';
import 'package:arungi_rasa/repository/address_repository.dart';
import 'package:get/get.dart';

class AddressService extends GetxService {
  static AddressService get instance => Get.find<AddressService>();

  final itemList = new RxList<Address>();

  Future<void> load() async {
    try {
      itemList.assignAll(await AddressRepository.instance.find());
    } catch (error, st) {
      ErrorReporter.instance.captureException(error, st);
    }
  }

  Future<void> add(final CreateUpdateAddress address) async {
    final item = await AddressRepository.instance.create(address);
    itemList.add(item);
  }

  Future<void> update(
      final Address oldAddress, final CreateUpdateAddress address) async {
    final index = itemList.indexWhere((e) => e.id == oldAddress.id);
    if (index == -1) return;
    final item =
        await AddressRepository.instance.update(oldAddress.id, address);
    itemList[index] = item;
  }

  Future<void> remove(final Address address) async {
    final index = itemList.indexWhere((e) => e.id == address.id);
    if (index == -1) return;
    await AddressRepository.instance.remove(address.id);
    itemList.removeAt(index);
  }

  void clear() {
    itemList.clear();
  }
}
