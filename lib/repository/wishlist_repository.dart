import 'package:arungi_rasa/common/config.dart';
import 'package:arungi_rasa/model/food_drink_menu.dart';
import 'package:arungi_rasa/service/session_service.dart';
import 'package:get/get.dart';
import 'package:get_connect_repo_mixin/get_connect_repo_mixin.dart';

class WishListRepository extends GetConnect
    with
        RepositorySslHandlerMixin,
        RepositoryAuthHandlerMixin,
        RepositoryErrorHandlerMixin {
  static WishListRepository get instance => Get.find<WishListRepository>();

  Future<List<FoodDrinkMenu>> find() async {
    final response = await get("$kRestUrl/wishlist");
    if (response.isOk) {
      return (response.body as List)
          .map((e) => FoodDrinkMenu.fromJson(e as Map<String, dynamic>))
          .toList(growable: false);
    } else {
      throw getException(response);
    }
  }

  Future<FoodDrinkMenu> create(final FoodDrinkMenu menu) async {
    final response = await post("$kRestUrl/wishlist/${menu.id}", {});
    if (response.isOk) {
      return FoodDrinkMenu.fromJson(response.body as Map<String, dynamic>);
    } else {
      throw getException(response);
    }
  }

  Future<void> remove(final FoodDrinkMenu menu) async {
    final response = await delete("$kRestUrl/wishlist/${menu.id}");
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
