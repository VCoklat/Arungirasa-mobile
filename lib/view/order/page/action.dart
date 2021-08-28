part of 'order_page.dart';

class _OrderAction extends GetView<_OrderPageController> {
  const _OrderAction();
  @override
  Widget build(BuildContext context) => new Obx(
        () {
          final order = controller.order.value!;
          switch (order.status) {
            case OrderStatus.unpaid:
              return new Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: const _OrderPayment(),
              );
            case OrderStatus.awaitingConfirmation:
            case OrderStatus.onProcess:
            case OrderStatus.sent:
            case OrderStatus.arrived:
            default:
              return const SizedBox();
          }
        },
      );
}
