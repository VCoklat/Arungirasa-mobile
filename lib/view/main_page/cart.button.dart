part of 'main_page.dart';

class _CartButton extends GetView<CartService> {
  const _CartButton();
  @override
  Widget build(BuildContext context) => new Obx(
        () => controller.count < 1
            ? const SizedBox()
            : new FloatingActionButton(
                backgroundColor: Colors.white,
                child: new Badge(
                  badgeContent: new Text(controller.count.toString()),
                  child: new Icon(
                    Icons.shopping_cart_sharp,
                    color: Get.theme.primaryColor,
                    size: 32.0,
                  ),
                  badgeColor: Colors.transparent,
                  elevation: 0.0,
                ),
                onPressed: () => Get.toNamed(Routes.cart),
              ),
      );
}
