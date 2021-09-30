part of 'order_page.dart';

class _OrderStatus extends GetView<_OrderPageController> {
  const _OrderStatus();
  @override
  Widget build(BuildContext context) => Obx(
        () {
          Color bgColor;
          final order = controller.order.value!;
          switch (order.status) {
            case OrderStatus.unpaid:
            case OrderStatus.awaitingConfirmation:
            case OrderStatus.onProcess:
              bgColor = Get.theme.primaryColor;
              break;
            case OrderStatus.sent:
            case OrderStatus.arrived:
              bgColor = const Color(0XFFF7CC0D);
              break;
            default:
              bgColor = Get.theme.primaryColor;
              break;
          }
          return SizedBox(
            width: Get.width,
            height: Get.height / 2 - Get.statusBarHeight,
            child: Container(
              color: bgColor,
              child: Column(
                children: const [
                  Center(child: _OrderTextStatus()),
                  Expanded(child: _OrderImageStatus()),
                ],
              ),
            ),
          );
        },
      );
}
