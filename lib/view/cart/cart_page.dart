import 'package:arungi_rasa/common/config.dart';
import 'package:arungi_rasa/common/helper.dart';
import 'package:arungi_rasa/generated/l10n.dart';
import 'package:arungi_rasa/model/cart.dart';
import 'package:arungi_rasa/routes/routes.dart';
import 'package:arungi_rasa/service/cart_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:octo_image/octo_image.dart';

class _CartPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<_CartPageController>(() => _CartPageController());
  }
}

class CartPage extends GetView<_CartPageController> {
  const CartPage({Key? key}) : super(key: key);
  static _CartPageBinding binding() => _CartPageBinding();
  @override
  Widget build(BuildContext context) => Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (_, __) => <Widget>[
            SliverAppBar(title: Text(S.current.cart)),
          ],
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Expanded(
                  child: AnimatedList(
                    key: controller.listState,
                    initialItemCount: controller.itemList.length,
                    itemBuilder: (_, final int index, final animation) =>
                        _AnimatedCartCard(
                      key: Key(controller.itemList[index].value.uuid),
                      cart: controller.itemList[index],
                      animation: animation,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  child: Text(S.current.ordeButtonr),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                      ),
                      padding:
                          MaterialStateProperty.all(const EdgeInsets.all(15.0)),
                      backgroundColor:
                          MaterialStateProperty.all(Get.theme.accentColor),
                      textStyle: MaterialStateProperty.all(const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      ))),
                  onPressed: () {
                    if (controller.itemList.isEmpty) {
                      Helper.showError(text: S.current.errorEmptyCart);
                    } else {
                      Get.offNamed(Routes.makeOrder);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      );
}

class _CartCard extends StatelessWidget {
  final Rx<Cart> cart;
  const _CartCard({
    Key? key,
    required this.cart,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          LayoutBuilder(
            builder: (_, constraints) => SizedBox(
              height: constraints.maxWidth * 0.4,
              child: Row(
                children: [
                  _getImage(constraints.maxWidth * 0.4),
                  const SizedBox(width: 5.0),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _title,
                        const SizedBox(height: 5.0),
                        _description,
                        const SizedBox(height: 5.0),
                        _totalText,
                        const SizedBox(height: 5.0),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete_sharp),
                              iconSize: 28,
                              onPressed: () => CartService.instance
                                  .removeCart(cart.value.menu, 0),
                            ),
                            const SizedBox(width: 10.0),
                            IconButton(
                              icon: const Icon(Icons.remove_sharp),
                              iconSize: 28,
                              onPressed: () => CartService.instance
                                  .subtractCart(cart.value.menu),
                            ),
                            const SizedBox(width: 2.5),
                            ObxValue<Rx<Cart>>(
                              (obs) => Text(
                                obs.value.qty.toString(),
                                style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              cart,
                            ),
                            const SizedBox(width: 2.5),
                            IconButton(
                              icon: const Icon(Icons.add_sharp),
                              iconSize: 28,
                              onPressed: () =>
                                  CartService.instance.addCart(cart.value.menu),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 5.0),
          const Divider(),
        ],
      );

  Widget get _totalText => Expanded(
        child: ObxValue<Rx<Cart>>(
          (obs) => Text(
            Helper.formatMoney((obs.value.qty * obs.value.price).toDouble()),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18.0,
              color: kPriceColor,
            ),
          ),
          cart,
        ),
      );

  Widget get _description => Expanded(
        child: Text(
          cart.value.menu.description,
          maxLines: null,
          style: const TextStyle(
            fontSize: 14.0,
          ),
        ),
      );

  Widget get _title => Text(
        cart.value.menu.name,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Get.theme.primaryColor,
          fontSize: 18.0,
          wordSpacing: 2.5,
        ),
      );

  Widget _getImage(final double size) => SizedBox(
        width: size,
        height: size,
        child: Material(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: OctoImage(
            image:
                CachedNetworkImageProvider(cart.value.menu.imageList.first.url),
            placeholderBuilder: OctoPlaceholder.blurHash(
                cart.value.menu.imageList.first.blurhash),
            errorBuilder:
                OctoError.blurHash(cart.value.menu.imageList.first.blurhash),
            fit: BoxFit.cover,
          ),
        ),
      );
}

class _AnimatedCartCard extends StatelessWidget {
  final Rx<Cart> cart;
  final Animation<double> animation;
  const _AnimatedCartCard({
    Key? key,
    required this.cart,
    required this.animation,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) => SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-1, 0),
          end: const Offset(0, 0),
        ).animate(animation),
        child: _CartCard(cart: cart),
      );
}

class _CartPageController extends GetxController {
  final listState = GlobalKey<AnimatedListState>();
  final itemList = <Rx<Cart>>[];

  @override
  void onInit() {
    itemList.assignAll(CartService.instance.itemList.map((e) => Rx<Cart>(e)));
    CartService.instance.addOnAddIndexCallback(_onAdd);
    CartService.instance.addOnRemoveIndexCallback(_onRemove);
    CartService.instance.addOnQtyChangedIndexCallback(_onQtyChanged);
    super.onInit();
  }

  @override
  void onClose() {
    CartService.instance.removeOnAddIndexCallback(_onAdd);
    CartService.instance.removeOnRemoveIndexCallback(_onRemove);
    CartService.instance.removeOnQtyChangedIndexCallback(_onQtyChanged);
    super.onClose();
  }

  void _onAdd(final int index) {
    itemList.add(Rx<Cart>(CartService.instance.itemList[index]));
    listState.currentState!.insertItem(index);
  }

  void _onRemove(final int index) {
    final item = itemList[index];
    itemList.removeAt(index);
    listState.currentState!.removeItem(
      index,
      (context, animation) => _AnimatedCartCard(
        cart: item,
        animation: animation,
      ),
    );
  }

  void _onQtyChanged(final int index) {
    itemList[index].value = CartService.instance.itemList[index];
  }
}
