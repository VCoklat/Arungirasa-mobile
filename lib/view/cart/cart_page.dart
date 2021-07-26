import 'package:arungi_rasa/common/config.dart';
import 'package:arungi_rasa/common/helper.dart';
import 'package:arungi_rasa/generated/l10n.dart';
import 'package:arungi_rasa/model/cart.dart';
import 'package:arungi_rasa/service/cart_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:octo_image/octo_image.dart';

class _CartPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<_CartPageController>(() => new _CartPageController());
  }
}

class CartPage extends GetView<_CartPageController> {
  const CartPage();
  static _CartPageBinding binding() => new _CartPageBinding();
  @override
  Widget build(BuildContext context) => new Scaffold(
        body: new NestedScrollView(
          headerSliverBuilder: (_, __) => <Widget>[
            new SliverAppBar(
              title: new Text(S.current.cart),
            ),
          ],
          body: new Padding(
            padding: const EdgeInsets.all(10.0),
            child: new AnimatedList(
              key: controller.listState,
              initialItemCount: controller.itemList.length,
              itemBuilder: (_, final int index, final animation) =>
                  new _CartCard(
                cart: controller.itemList[index],
                animation: animation,
              ),
            ),
          ),
        ),
      );
}

class _CartCard extends StatelessWidget {
  final Rx<Cart> cart;
  final Animation<double> animation;
  const _CartCard({
    Key? key,
    required this.cart,
    required this.animation,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) => new SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-1, 0),
          end: const Offset(0, 0),
        ).animate(animation),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            new LayoutBuilder(
              builder: (_, constraints) => new SizedBox(
                height: constraints.maxWidth * 0.4,
                child: new Row(
                  children: [
                    _getImage(constraints.maxWidth * 0.4),
                    const SizedBox(
                      width: 5.0,
                    ),
                    new Expanded(
                      child: new Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _title,
                          const SizedBox(height: 5.0),
                          _description,
                          const SizedBox(height: 5.0),
                          _totalText,
                          const SizedBox(height: 5.0),
                          new Row(
                            children: [
                              new IconButton(
                                icon: const Icon(Icons.delete_sharp),
                                iconSize: 28,
                                onPressed: () => CartService.instance
                                    .removeCart(cart.value.menu, 0),
                              ),
                              const SizedBox(width: 10.0),
                              new IconButton(
                                icon: const Icon(Icons.remove_sharp),
                                iconSize: 28,
                                onPressed: () => CartService.instance
                                    .subtractCart(cart.value.menu),
                              ),
                              const SizedBox(width: 2.5),
                              new ObxValue<Rx<Cart>>(
                                (obs) => new Text(
                                  obs.value.qty.toString(),
                                  style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                cart,
                              ),
                              const SizedBox(width: 2.5),
                              new IconButton(
                                icon: const Icon(Icons.add_sharp),
                                iconSize: 28,
                                onPressed: () => CartService.instance
                                    .addCart(cart.value.menu),
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
            const SizedBox(
              height: 5.0,
            ),
            const Divider(),
          ],
        ),
      );

  Widget get _totalText => new Expanded(
        child: new ObxValue<Rx<Cart>>(
          (obs) => new Text(
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

  Widget get _description => new Expanded(
        child: new Text(
          cart.value.menu.description,
          maxLines: null,
          style: const TextStyle(
            fontSize: 14.0,
          ),
        ),
      );

  Widget get _title => new Text(
        cart.value.menu.name,
        style: new TextStyle(
          fontWeight: FontWeight.w600,
          color: Get.theme.primaryColor,
          fontSize: 18.0,
          wordSpacing: 2.5,
        ),
      );

  Widget _getImage(final double size) => new SizedBox(
        width: size,
        height: size,
        child: new Material(
          shape: new RoundedRectangleBorder(
              borderRadius:
                  const BorderRadius.all(const Radius.circular(15.0))),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: new OctoImage(
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

class _CartPageController extends GetxController {
  final listState = new GlobalKey<AnimatedListState>();
  final itemList = <Rx<Cart>>[];

  @override
  void onInit() {
    itemList
        .assignAll(CartService.instance.itemList.map((e) => new Rx<Cart>(e)));
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
    itemList.add(new Rx<Cart>(CartService.instance.itemList[index]));
    listState.currentState!.insertItem(index);
  }

  void _onRemove(final int index) {
    final item = itemList[index];
    itemList.removeAt(index);
    listState.currentState!.removeItem(
      index,
      (context, animation) => new _CartCard(
        cart: item,
        animation: animation,
      ),
    );
  }

  void _onQtyChanged(final int index) {
    itemList[index].value = CartService.instance.itemList[index];
  }
}
