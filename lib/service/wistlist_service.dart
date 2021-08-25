import 'package:arungi_rasa/common/error_reporter.dart';
import 'package:arungi_rasa/common/helper.dart';
import 'package:arungi_rasa/model/food_drink_menu.dart';
import 'package:arungi_rasa/repository/wishlist_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WishListService extends GetxService {
  static WishListService get instance => Get.find<WishListService>();

  final itemList = new RxList<FoodDrinkMenu>();

  int get count => itemList.length;

  final _onAddIndexCallbackList = <ValueChanged<int>>[];
  final _onRemoveIndexCallbackList = <ValueChanged<int>>[];

  void addOnAddIndexCallback(final ValueChanged<int> callback) =>
      _onAddIndexCallbackList.add(callback);
  void removeOnAddIndexCallback(final ValueChanged<int> callback) =>
      _onAddIndexCallbackList.remove(callback);

  void addOnRemoveIndexCallback(final ValueChanged<int> callback) =>
      _onRemoveIndexCallbackList.add(callback);
  void removeOnRemoveIndexCallback(final ValueChanged<int> callback) =>
      _onRemoveIndexCallbackList.remove(callback);

  Future<void> load() async {
    try {
      itemList.assignAll(await WishListRepository.instance.find());
    } catch (error, st) {
      ErrorReporter.instance.captureException(error, st);
    }
  }

  void clear() {
    itemList.clear();
  }

  Future<void> toggle(final FoodDrinkMenu menu) async {
    Helper.showLoading();
    try {
      final index = itemList.indexWhere((e) => e.ref == menu.ref);
      if (index == -1) {
        final cart = await WishListRepository.instance.create(menu);
        itemList.add(cart);
        for (final callback in _onAddIndexCallbackList)
          callback(itemList.length - 1);
      } else {
        await WishListRepository.instance.remove(menu);
        itemList.removeAt(index);
        for (final callback in _onRemoveIndexCallbackList) callback(index);
      }
      Helper.hideLoadingWithSuccess();
    } catch (error, st) {
      ErrorReporter.instance.captureException(error, st);
      Helper.hideLoadingWithError();
    }
  }
}
