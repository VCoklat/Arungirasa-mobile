part of 'main_page.dart';

class _CartButton extends GetView<CartService> {
  const _CartButton();
  @override
  Widget build(BuildContext context) => new IconButton(
        icon: new Badge(
          badgeContent: new Obx(
            () => new Text(controller.count.toString()),
          ),
          child: new Icon(
            Icons.shopping_cart_sharp,
            color: Get.theme.primaryColor,
            size: 32.0,
          ),
          badgeColor: Colors.white,
        ),
        onPressed: () => Get.toNamed(Routes.cart),
      );
}
