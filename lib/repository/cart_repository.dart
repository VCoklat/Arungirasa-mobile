import 'package:arungi_rasa/common/config.dart';
import 'package:arungi_rasa/model/cart.dart';
import 'package:arungi_rasa/model/food_drink_menu.dart';
import 'package:arungi_rasa/service/session_service.dart';
import 'package:get/get.dart';
import 'package:get_connect_repo_mixin/get_connect_repo_mixin.dart';

import 'mixin_repository_config.dart';

class CartRepository extends GetConnect
    with
        RepositoryConfigMixin,
        RepositorySslHandlerMixin,
        RepositoryAuthHandlerMixin,
        RepositoryErrorHandlerMixin {
  static CartRepository get instance => Get.find<CartRepository>();

  Future<List<Cart>> findAll() async {
    final response = await get("$kRestUrl/cart");
    if (response.isOk) {
      return (response.body as List)
          .map((e) => Cart.fromJson(e as Map<String, dynamic>))
          .toList(growable: false);
    } else {
      throw getException(response);
    }
  }

  Future<Cart> create(final FoodDrinkMenuRef menuRef, final int qty) async {
    final response = await post("$kRestUrl/cart", {
      "menuId": menuRef.id,
      "qty": qty,
    });
    if (response.isOk) {
      return Cart.fromJson(response.body as Map<String, dynamic>);
    } else {
      throw getException(response);
    }
  }

  Future<Cart> updateQty(final Cart cart) async {
    final response = await patch("$kRestUrl/cart", {
      "uuid": cart.uuid,
      "qty": cart.qty,
    });
    if (response.isOk) {
      return Cart.fromJson(response.body as Map<String, dynamic>);
    } else {
      throw getException(response);
    }
  }

  Future<void> remove(final Cart cart) async {
    final response = await delete("$kRestUrl/cart/${cart.uuid}");
    if (!response.isOk) {
      throw getException(response);
    }
  }

  @override
  Future<String> get accessToken async =>
      "Bearer ${await SessionService.instance.accessToken}";

  @override
  List<int> get certificate => const [];
}
