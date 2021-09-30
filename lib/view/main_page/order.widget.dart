part of 'main_page.dart';

class _OrderList extends GetView<OrderService> {
  const _OrderList();
  @override
  Widget build(BuildContext context) => Obx(
        () => ListView.separated(
          itemCount: min(3, controller.onGoingOrder.length),
          shrinkWrap: true,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, final int index) => InkWell(
            child: OrderCard(order: controller.onGoingOrder[index]),
            onTap: () async {
              await Routes.openOrder(controller.onGoingOrder[index].id);
              await OrderService.instance.load();
            },
          ),
        ),
      );
}
