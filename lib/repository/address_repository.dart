import 'package:arungi_rasa/common/config.dart';
import 'package:arungi_rasa/model/address.dart';
import 'package:arungi_rasa/repository/mixin_repository_config.dart';
import 'package:arungi_rasa/service/session_service.dart';
import 'package:get/get.dart';
import 'package:get_connect_repo_mixin/get_connect_repo_mixin.dart';

class AddressRepository extends GetConnect
    with
        RepositoryConfigMixin,
        RepositorySslHandlerMixin,
        RepositoryAuthHandlerMixin,
        RepositoryErrorHandlerMixin {
  static AddressRepository get instance => Get.find<AddressRepository>();
  Future<Address> create(final CreateUpdateAddress address) async {
    final response = await post("$kRestUrl/address", address.toJson());
    if (response.isOk) {
      return Address.fromJson(response.body as Map<String, dynamic>);
    } else {
      throw getException(response);
    }
  }

  Future<Address> update(
      final String addressId, final CreateUpdateAddress address) async {
    final response =
        await put("$kRestUrl/address/$addressId", address.toJson());
    if (response.isOk) {
      return Address.fromJson(response.body as Map<String, dynamic>);
    } else {
      throw getException(response);
    }
  }

  Future<void> remove(final String addressId) async {
    final response = await delete("$kRestUrl/address/$addressId");
    if (!response.isOk) {
      throw getException(response);
    }
  }

  Future<List<Address>> find() async {
    final response = await get("$kRestUrl/address");
    if (response.isOk) {
      return (response.body as List)
          .map((e) => Address.fromJson(e as Map<String, dynamic>))
          .toList(growable: false);
    } else {
      throw getException(response);
    }
  }

  @override
  Future<String> get accessToken async =>
      "Bearer ${await SessionService.instance.accessToken}";

  @override
  List<int> get certificate => const [];
}
