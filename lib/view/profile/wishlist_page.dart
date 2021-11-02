import 'package:arungi_rasa/model/food_drink_menu.dart';
import 'package:arungi_rasa/service/wistlist_service.dart';
import 'package:arungi_rasa/widget/add_to_cart_dialog.dart';
import 'package:arungi_rasa/widget/menu_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class _WishListPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<_WishListPageController>(() => _WishListPageController());
  }
}

class WishListPage extends GetView<_WishListPageController> {
  const WishListPage({Key? key}) : super(key: key);
  static _WishListPageBinding binding() => _WishListPageBinding();
  @override
  Widget build(BuildContext context) => Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (_, __) => <Widget>[
            const SliverAppBar(title: Text("Wish List")),
          ],
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: AnimatedList(
              key: controller.listState,
              initialItemCount: controller.itemList.length,
              itemBuilder: (_, final int index, final animation) =>
                  AnimatedMenuCard(
                menu: controller.itemList[index],
                animation: animation,
                onAddPressed: (menu) async =>
                    await Get.bottomSheet(AddToCartDialog(menu: menu)),
              ),
            ),
          ),
        ),
      );
}

class _WishListPageController extends GetxController {
  final listState = GlobalKey<AnimatedListState>();
  final itemList = <FoodDrinkMenu>[];

  @override
  void onInit() {
    itemList.assignAll(WishListService.instance.itemList);
    WishListService.instance.addOnAddIndexCallback(_onAdd);
    WishListService.instance.addOnRemoveIndexCallback(_onRemove);
    super.onInit();
  }

  @override
  void onClose() {
    WishListService.instance.removeOnAddIndexCallback(_onAdd);
    WishListService.instance.removeOnRemoveIndexCallback(_onRemove);
    super.onClose();
  }

  void _onAdd(final int index) {
    itemList.add(WishListService.instance.itemList[index]);
    listState.currentState!.insertItem(index);
  }

  void _onRemove(final int index) {
    final item = itemList[index];
    listState.currentState!.removeItem(
      index,
      (context, animation) => AnimatedMenuCard(
        menu: item,
        animation: animation,
      ),
      duration: const Duration(milliseconds: 300),
    );
    Future.delayed(const Duration(milliseconds: 500)).then(
      (_) => itemList.removeAt(index),
    );
  }
}
