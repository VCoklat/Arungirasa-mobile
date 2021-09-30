import 'package:arungi_rasa/common/error_reporter.dart';
import 'package:arungi_rasa/common/helper.dart';
import 'package:arungi_rasa/model/cart.dart';
import 'package:arungi_rasa/model/food_drink_menu.dart';
import 'package:arungi_rasa/repository/cart_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CartService extends GetxService {
  static CartService get instance => Get.find<CartService>();

  final itemList = RxList<Cart>();

  int get count => itemList.length;

  final _onAddIndexCallbackList = <ValueChanged<int>>[];
  final _onRemoveIndexCallbackList = <ValueChanged<int>>[];
  final _onQtyChangedIndexCallbackList = <ValueChanged<int>>[];

  void addOnAddIndexCallback(final ValueChanged<int> callback) =>
      _onAddIndexCallbackList.add(callback);
  void removeOnAddIndexCallback(final ValueChanged<int> callback) =>
      _onAddIndexCallbackList.remove(callback);

  void addOnRemoveIndexCallback(final ValueChanged<int> callback) =>
      _onRemoveIndexCallbackList.add(callback);
  void removeOnRemoveIndexCallback(final ValueChanged<int> callback) =>
      _onRemoveIndexCallbackList.remove(callback);

  void addOnQtyChangedIndexCallback(final ValueChanged<int> callback) =>
      _onQtyChangedIndexCallbackList.add(callback);
  void removeOnQtyChangedIndexCallback(final ValueChanged<int> callback) =>
      _onQtyChangedIndexCallbackList.remove(callback);

  int get totalQty => itemList.fold(0, (prev, e) => prev + e.qty);

  int getQty(final FoodDrinkMenuRef menu) {
    return itemList
            .cast<Cart?>()
            .firstWhere((e) => e?.menu.ref == menu, orElse: () => null)
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

  Future<void> addCart(final FoodDrinkMenu menu) async {
    Helper.showLoading();
    try {
      final index = itemList.indexWhere((e) => e.menu.ref == menu.ref);
      if (index == -1) {
        final cart = await CartRepository.instance.create(menu.ref, 1);
        itemList.add(cart);
        for (final callback in _onAddIndexCallbackList) {
          callback(itemList.length - 1);
        }
      } else {
        final newCart = itemList[index].updateQty(itemList[index].qty + 1);
        final cart = await CartRepository.instance.updateQty(newCart);
        itemList[index] = cart;
        for (final callback in _onQtyChangedIndexCallbackList) {
          callback(index);
        }
      }
      Helper.hideLoadingWithSuccess();
    } catch (error, st) {
      ErrorReporter.instance.captureException(error, st);
      Helper.hideLoadingWithError();
    }
  }

  Future<void> subtractCart(final FoodDrinkMenu menu) async {
    final index = itemList.indexWhere((e) => e.menu.ref == menu.ref);
    if (index == -1) return;
    Helper.showLoading();
    try {
      final newCart = itemList[index].updateQty(itemList[index].qty - 1);
      if (newCart.qty < 1) {
        await CartRepository.instance.remove(itemList[index]);
        for (final callback in _onRemoveIndexCallbackList) {
          callback(itemList.length - 1);
        }
      } else {
        final cart = await CartRepository.instance.updateQty(newCart);
        itemList[index] = cart;
        for (final callback in _onQtyChangedIndexCallbackList) {
          callback(index);
        }
      }
      Helper.hideLoadingWithSuccess();
    } catch (error, st) {
      ErrorReporter.instance.captureException(error, st);
      Helper.hideLoadingWithError();
    }
  }

  Future<void> insertCart(final FoodDrinkMenu menu, final int qty) async {
    Helper.showLoading();
    try {
      final index = itemList.indexWhere((e) => e.menu.ref == menu.ref);
      if (index == -1) {
        final cart = await CartRepository.instance.create(menu.ref, qty);
        itemList.add(cart);
        for (final callback in _onAddIndexCallbackList) {
          callback(itemList.length - 1);
        }
      } else {
        final newCart = itemList[index].updateQty(qty);
        final cart = await CartRepository.instance.updateQty(newCart);
        itemList[index] = cart;
        for (final callback in _onQtyChangedIndexCallbackList) {
          callback(index);
        }
      }
      Helper.hideLoadingWithSuccess();
    } catch (error, st) {
      ErrorReporter.instance.captureException(error, st);
      Helper.hideLoadingWithError();
    }
  }

  Future<void> removeCart(final FoodDrinkMenu menu, final int qty) async {
    final index = itemList.indexWhere((e) => e.menu.ref == menu.ref);
    if (index == -1) return;
    Helper.showLoading();
    try {
      final newCart = itemList[index].updateQty(qty);
      if (newCart.qty < 1) {
        await CartRepository.instance.remove(itemList[index]);
        itemList.removeAt(index);
        Helper.hideLoadingWithSuccess();
        for (final callback in _onRemoveIndexCallbackList) {
          callback(index);
        }
      } else {
        final newCart = itemList[index].updateQty(qty);
        final cart = await CartRepository.instance.updateQty(newCart);
        itemList[index] = cart;
        for (final callback in _onQtyChangedIndexCallbackList) {
          callback(index);
        }
      }
    } catch (error, st) {
      ErrorReporter.instance.captureException(error, st);
      Helper.hideLoadingWithError();
    }
  }
}
