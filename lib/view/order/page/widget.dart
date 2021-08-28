part of 'order_page.dart';

class _OrderWidget extends GetView<_OrderPageController> {
  const _OrderWidget();
  @override
  Widget build(BuildContext context) => new SizedBox(
        width: Get.width,
        height: controller.height,
        child: new Stack(
          children: [
            const _OrderImageStatus(),
            new Positioned(
              top: 10.0,
              left: 10.0,
              right: 10.0,
              child: new Center(
                child: const _OrderTextStatus(),
              ),
            ),
            new Positioned(
              top: Get.height / 4 - Get.statusBarHeight + 30,
              left: 10.0,
              right: 10.0,
              child: const _OrderContent(),
            ),
          ],
        ),
      );
  /*
  @override
  Widget build(BuildContext context) => new SizedBox(
        width: Get.width,
        height: Get.height,
        child: new Stack(
          children: [
            const _OrderImageStatus(),
            new Positioned(
              top: 10.0,
              left: 10.0,
              right: 10.0,
              child: new Center(
                child: const _OrderTextStatus(),
              ),
            ),
            new Positioned(
              top: Get.height / 4 - Get.statusBarHeight + 30,
              left: 10.0,
              right: 10.0,
              child: const _OrderContent(),
            ),
          ],
        ),
      );
      */
}
