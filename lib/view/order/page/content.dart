part of 'order_page.dart';

class _OrderContent extends GetView<_OrderPageController> {
  const _OrderContent();
  @override
  Widget build(BuildContext context) => Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: _OrderAddress(),
            ),
            const Divider(),
            SizedBox(
              height: 100,
              child: Obx(
                () => controller.order.value!.menuList.length == 1
                    ? _OrderItem(
                        orderMenu: controller.order.value!.menuList.first,
                      )
                    : Swiper(
                        itemCount: controller.order.value!.menuList.length,
                        autoplay: true,
                        itemBuilder: (_, final int index) => _OrderItem(
                          orderMenu: controller.order.value!.menuList[index],
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
                padding: EdgeInsets.all(20), child: _PaymentSummary()),
            const _OrderAction(),
            const SizedBox(height: 10),
          ],
        ),
      );
}
