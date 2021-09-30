part of 'order_page.dart';

class _OrderWidget extends GetView<_OrderPageController> {
  const _OrderWidget();
  @override
  Widget build(BuildContext context) => Obx(
        () => SizedBox(
          width: Get.width,
          height: controller.height,
          child: Stack(
            children: [
              const _OrderStatus(),
              Positioned(
                top: Get.height / 4 - Get.statusBarHeight + 30,
                left: 10.0,
                right: 10.0,
                child: const _OrderContent(),
              ),
            ],
          ),
        ),
      );
}
