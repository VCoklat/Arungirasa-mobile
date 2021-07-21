import 'package:arungi_rasa/common/error_reporter.dart';
import 'package:arungi_rasa/common/helper.dart';
import 'package:arungi_rasa/model/cart.dart';
import 'package:arungi_rasa/model/food_drink_menu.dart';
import 'package:arungi_rasa/repository/cart_repository.dart';
import 'package:get/get.dart';

class CartService extends GetxService {
  static CartService get instance => Get.find<CartService>();

  final itemList = new RxList<Cart>();

  int get count => itemList.length;

  int getQty(final FoodDrinkMenuRef menu) {
    return itemList
            .cast<Cart?>()
            .firstWhere((e) => e?.menuRef == menu, orElse: () => null)
            ?.qty ??
        0;
  }

  Future<void> load() async {
    try {
      itemList.assignAll(await CartRepository.instance.findAll());
    } catch (error, st) {
      ErrorReporter.instance.captureException(error, st);
    }
  }

  void clear() {
    itemList.clear();
  }

  Future<void> addCart(final FoodDrinkMenu menu, final int qty) async {
    Helper.showLoading();
    try {
      final index = itemList.indexWhere((e) => e.menuRef == menu.ref);
      if (index == -1) {
        final cart = await CartRepository.instance.create(menu.ref, qty);
        itemList.add(cart);
      } else {
        final newCart = itemList[index].updateQty(qty);
        final cart = await CartRepository.instance.updateQty(newCart);
        itemList.add(cart);
      }
      Helper.hideLoadingWithSuccess();
    } catch (error, st) {
      ErrorReporter.instance.captureException(error, st);
      Helper.hideLoadingWithError();
    }
  }

  Future<void> removeCart(final FoodDrinkMenu menu, final int qty) async {
    final index = itemList.indexWhere((e) => e.menuRef == menu.ref);
    if (index == -1) return;
    Helper.showLoading();
    try {
      await CartRepository.instance.remove(itemList[index]);
      Helper.hideLoadingWithSuccess();
    } catch (error, st) {
      ErrorReporter.instance.captureException(error, st);
      Helper.hideLoadingWithError();
    }
  }
}
