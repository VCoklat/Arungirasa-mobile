part of 'order_page.dart';

class _OrderImageStatus extends GetView<_OrderPageController> {
  const _OrderImageStatus();
  @override
  Widget build(BuildContext context) => new Obx(
        () {
          final order = controller.order.value!;
          switch (order.status) {
            case OrderStatus.unpaid:
            case OrderStatus.awaitingConfirmation:
            case OrderStatus.onProcess:
              return Assets.images.onPrepareImage.image(
                width: Get.width,
                fit: BoxFit.fitWidth,
              );
            case OrderStatus.sent:
            case OrderStatus.arrived:
              return Assets.images.onDeliveryImage.image(
                width: Get.width,
                fit: BoxFit.fitHeight,
              );
            default:
              return Assets.images.onPrepareImage.image(
                width: Get.width,
                fit: BoxFit.fitHeight,
              );
          }
        },
      );
}
