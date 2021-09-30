import 'package:arungi_rasa/common/error_reporter.dart';
import 'package:arungi_rasa/common/mixin_controller_worker.dart';
import 'package:arungi_rasa/generated/l10n.dart';
import 'package:arungi_rasa/model/order.dart';
import 'package:arungi_rasa/routes/routes.dart';
import 'package:arungi_rasa/service/order_service.dart';
import 'package:arungi_rasa/service/wistlist_service.dart';
import 'package:arungi_rasa/widget/order_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class _OrderListPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<_OrderListPageController>(() => _OrderListPageController());
  }
}

class OrderListPage extends GetView<_OrderListPageController> {
  const OrderListPage({Key? key}) : super(key: key);
  static _OrderListPageBinding binding() => _OrderListPageBinding();
  @override
  Widget build(BuildContext context) => Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (_, __) => <Widget>[
            SliverAppBar(title: Text(S.current.order)),
          ],
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      Obx(
                        () => FilterChip(
                          label: Text(S.current.all),
                          selected: controller.status.value == null,
                          onSelected: controller.busy.value
                              ? null
                              : (_) => controller.status.value = null,
                        ),
                      ),
                      gap,
                      Obx(
                        () => FilterChip(
                          label: Text(S.current.unpaid),
                          selected:
                              controller.status.value == OrderStatus.unpaid,
                          onSelected: controller.busy.value
                              ? null
                              : (_) =>
                                  controller.status.value = OrderStatus.unpaid,
                        ),
                      ),
                      gap,
                      Obx(
                        () => FilterChip(
                          label: Text(S.current.confirm),
                          selected: controller.status.value ==
                              OrderStatus.awaitingConfirmation,
                          onSelected: controller.busy.value
                              ? null
                              : (_) => controller.status.value =
                                  OrderStatus.awaitingConfirmation,
                        ),
                      ),
                      gap,
                      Obx(
                        () => FilterChip(
                          label: Text(S.current.onProcess),
                          selected:
                              controller.status.value == OrderStatus.onProcess,
                          onSelected: controller.busy.value
                              ? null
                              : (_) => controller.status.value =
                                  OrderStatus.onProcess,
                        ),
                      ),
                      gap,
                      Obx(
                        () => FilterChip(
                          label: Text(S.current.sent),
                          selected: controller.status.value == OrderStatus.sent,
                          onSelected: controller.busy.value
                              ? null
                              : (_) =>
                                  controller.status.value = OrderStatus.sent,
                        ),
                      ),
                      gap,
                      Obx(
                        () => FilterChip(
                          label: Text(S.current.arrived),
                          selected:
                              controller.status.value == OrderStatus.arrived,
                          onSelected: controller.busy.value
                              ? null
                              : (_) =>
                                  controller.status.value = OrderStatus.arrived,
                        ),
                      ),
                      gap,
                      Obx(
                        () => FilterChip(
                          label: Text(S.current.complained),
                          selected:
                              controller.status.value == OrderStatus.complained,
                          onSelected: controller.busy.value
                              ? null
                              : (_) => controller.status.value =
                                  OrderStatus.complained,
                        ),
                      ),
                      gap,
                      Obx(
                        () => FilterChip(
                          label: Text(S.current.cancelled),
                          selected:
                              controller.status.value == OrderStatus.cancelled,
                          onSelected: controller.busy.value
                              ? null
                              : (_) => controller.status.value =
                                  OrderStatus.cancelled,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: AnimatedList(
                    key: controller.listState,
                    initialItemCount: controller.itemList.length,
                    shrinkWrap: true,
                    itemBuilder: (_, final int index, final animation) =>
                        InkWell(
                      child: AnimatedOrderCard(
                        order: controller.itemList[index],
                        animation: animation,
                      ),
                      onTap: () async {
                        await Routes.openOrder(controller.itemList[index].id);
                        await OrderService.instance.load();
                        controller.refresh();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget get gap => const SizedBox(width: 10);
}

class _OrderListPageController extends GetxController
    with MixinControllerWorker {
  final listState = GlobalKey<AnimatedListState>();
  final itemList = <Order>[];
  final status = Rxn<OrderStatus>();
  final busy = RxBool(false);

  @override
  void onInit() {
    itemList.assignAll(OrderService.instance.itemList);
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
    itemList.add(OrderService.instance.itemList[index]);
    listState.currentState!.insertItem(index);
  }

  void _onRemove(final int index) {
    final item = itemList[index];
    listState.currentState!.removeItem(
      index,
      (context, animation) => AnimatedOrderCard(
        order: item,
        animation: animation,
      ),
      duration: const Duration(milliseconds: 300),
    );
    Future.delayed(const Duration(milliseconds: 500)).then(
      (_) => itemList.removeAt(index),
    );
  }

  @override
  void refresh() {
    super.refresh();
    _onStatusChanged(status.value);
  }

  void _onStatusChanged(final OrderStatus? status) async {
    busy.value = true;
    try {
      for (int i = itemList.length - 1; i > -1; --i) {
        listState.currentState!.removeItem(
          i,
          (context, animation) => AnimatedOrderCard(
            order: itemList[i],
            animation: animation,
          ),
          duration: const Duration(milliseconds: 300),
        );
        await Future.delayed(const Duration(milliseconds: 500));
        itemList.removeAt(i);
      }

      if (status == null) {
        itemList.assignAll(OrderService.instance.itemList);
      } else {
        itemList.assignAll(
            OrderService.instance.itemList.where((e) => e.status == status));
      }

      for (int i = 0; i < itemList.length; ++i) {
        listState.currentState!.insertItem(
          i,
          duration: const Duration(milliseconds: 300),
        );
        await Future.delayed(const Duration(milliseconds: 500));
      }
    } catch (error, st) {
      ErrorReporter.instance.captureException(error, st);
    } finally {
      busy.value = false;
    }
  }

  @override
  List<Worker> getWorkers() => <Worker>[
        ever<OrderStatus?>(status, _onStatusChanged),
      ];
}
