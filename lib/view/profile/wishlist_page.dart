import 'package:arungi_rasa/model/food_drink_menu.dart';
import 'package:arungi_rasa/service/wistlist_service.dart';
import 'package:arungi_rasa/widget/menu_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class _WishListPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<_WishListPageController>(() => new _WishListPageController());
  }
}

class WishListPage extends GetView<_WishListPageController> {
  const WishListPage();
  static _WishListPageBinding binding() => new _WishListPageBinding();
  @override
  Widget build(BuildContext context) => new Scaffold(
        body: new NestedScrollView(
          headerSliverBuilder: (_, __) => <Widget>[
            const SliverAppBar(
              title: const Text("Wish List"),
            ),
          ],
          body: new Padding(
            padding: const EdgeInsets.all(10.0),
            child: new AnimatedList(
              key: controller.listState,
              initialItemCount: controller.itemList.length,
              itemBuilder: (_, final int index, final animation) =>
                  new AnimatedMenuCard(
                menu: controller.itemList[index],
                animation: animation,
              ),
            ),
          ),
        ),
      );
}

class _WishListPageController extends GetxController {
  final listState = new GlobalKey<AnimatedListState>();
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
      (context, animation) => new AnimatedMenuCard(
        menu: item,
        animation: animation,
      ),
      duration: const Duration(milliseconds: 300),
    );
    new Future.delayed(const Duration(milliseconds: 500)).then(
      (_) => itemList.removeAt(index),
    );
  }
}
