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

  void clear() {
    itemList.clear();
  }
}
