import 'package:arungi_rasa/model/food_drink_menu.dart';
import 'package:arungi_rasa/repository/menu_repository.dart';

class ReferenceLoader {
  static Future<FoodDrinkMenu?> loadFoodDrinkMenu(
      final FoodDrinkMenuRef ref) async {
    ref.value ??= await FoodDrinkMenuRepository.instance.findOne(ref);
    return ref.value;
  }
}
