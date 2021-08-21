import 'package:arungi_rasa/common/error_reporter.dart';
import 'package:arungi_rasa/model/order.dart';
import 'package:arungi_rasa/repository/order_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderService extends GetxService {
  static OrderService get instance => Get.find<OrderService>();

  final itemList = new RxList<Order>();

  List<Order> get onGoingOrder => itemList
      .where((e) =>
          e.status != OrderStatus.arrived &&
          e.status != OrderStatus.cancelled &&
          e.status != OrderStatus.complained)
      .toList(growable: false);

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

  Future<void> load() async {
    try {
      itemList.assignAll(await OrderRepository.instance.find());
    } catch (error, st) {
      ErrorReporter.instance.captureException(error, st);
    }
  }

  void clear() {
    itemList.clear();
  }
}
