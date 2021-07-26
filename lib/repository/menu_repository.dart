import 'package:arungi_rasa/common/config.dart';
import 'package:arungi_rasa/model/food_drink_menu.dart';
import 'package:arungi_rasa/model/restaurant.dart';
import 'package:get/get.dart';
import 'package:get_connect_repo_mixin/get_connect_repo_mixin.dart';

class FoodDrinkMenuRepository extends GetConnect
    with RepositorySslHandlerMixin, RepositoryErrorHandlerMixin {
  static FoodDrinkMenuRepository get instance =>
      Get.find<FoodDrinkMenuRepository>();

  Future<List<FoodDrinkMenu>> find({
    final RestaurantRef? restaurantRef,
    String? query,
  }) async {
    final queryMap = Map<String, String>();
    if (restaurantRef != null)
      queryMap["restaurant"] = restaurantRef.id.toString();
    if (query != null) {
      queryMap["query"] = query;
    }
    final response = await get(
      "$kRestUrl/menu",
      query: queryMap,
    );
    if (response.isOk)
      return (response.body as List)
          .map((e) => FoodDrinkMenu.fromJson(e as Map<String, dynamic>))
          .toList(growable: false);
    else
      throw getException(response);
  }

  Future<FoodDrinkMenu> findOne(final FoodDrinkMenuRef ref) async {
    final response = await get("$kRestUrl/menu/${ref.id}");
    if (response.isOk)
      return FoodDrinkMenu.fromJson(response.body as Map<String, dynamic>);
    else
      throw getException(response);
  }

  @override
  List<int> get certificate => [];
}
