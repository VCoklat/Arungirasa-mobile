part of 'order_page.dart';

class _OrderContent extends GetView<_OrderPageController> {
  const _OrderContent();
  @override
  Widget build(BuildContext context) => new Card(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: const EdgeInsets.all(20),
              child: const _OrderAddress(),
            ),
            const Divider(),
            new SizedBox(
              height: 100,
              child: new Obx(
                () => controller.order.value!.menuList.length == 1
                    ? new _OrderItem(
                        orderMenu: controller.order.value!.menuList.first,
                      )
                    : new Swiper(
                        itemCount: controller.order.value!.menuList.length,
                        autoplay: true,
                        itemBuilder: (_, final int index) => new _OrderItem(
                          orderMenu: controller.order.value!.menuList[index],
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 10),
            new Padding(
              padding: const EdgeInsets.all(20),
              child: const _PaymentSummary(),
            ),
            const _OrderAction(),
            const SizedBox(height: 10),
          ],
        ),
      );
}
