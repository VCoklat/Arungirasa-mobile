part of 'main_page.dart';

class _CartButton extends GetView<CartService> {
  const _CartButton();
  @override
  Widget build(BuildContext context) => Obx(
        () => controller.count < 1
            ? const SizedBox()
            : FloatingActionButton(
                backgroundColor: Colors.white,
                child: Badge(
                  badgeContent: Text(controller.count.toString()),
                  child: Icon(
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
