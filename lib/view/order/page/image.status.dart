part of 'order_page.dart';

class _OrderImageStatus extends GetView<_OrderPageController> {
  const _OrderImageStatus();
  @override
  Widget build(BuildContext context) => new Obx(
        () {
          Widget image;
          Color color;
          final order = controller.order.value!;
          switch (order.status) {
            case OrderStatus.unpaid:
            case OrderStatus.awaitingConfirmation:
            case OrderStatus.onProcess:
              color = Get.theme.primaryColor;
              image = Assets.images.onPrepareImage.image(
                width: Get.width,
                fit: BoxFit.cover,
              );
              break;
            case OrderStatus.sent:
            case OrderStatus.arrived:
              color = const Color(0XFFF7CC0D);
              image = Assets.images.onDeliveryImage.image(
                width: Get.width,
                fit: BoxFit.cover,
              );
              break;
            default:
              color = Get.theme.primaryColor;
              image = Assets.images.onPrepareImage.image(
                width: Get.width,
                fit: BoxFit.cover,
              );
              break;
          }
          return new SizedBox(
            width: Get.width,
            height: Get.height / 2 - Get.statusBarHeight,
            child: new Container(
              color: color,
              child: new Padding(
                padding: const EdgeInsets.only(top: 20),
                child: image,
              ),
            ),
          );
        },
      );
}
