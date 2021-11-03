import 'package:arungi_rasa/common/config.dart';
import 'package:arungi_rasa/common/error_reporter.dart';
import 'package:arungi_rasa/common/helper.dart';
import 'package:arungi_rasa/generated/l10n.dart';
import 'package:arungi_rasa/model/cart.dart';
import 'package:arungi_rasa/routes/routes.dart';
import 'package:arungi_rasa/service/cart_service.dart';
import 'package:arungi_rasa/widget/cart_qty_editor.dart';
import 'package:arungi_rasa/widget/menu_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
            padding: kPagePadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: AnimatedList(
                    key: controller.listState,
                    initialItemCount: controller.itemList.length,
                    itemBuilder: (_, final int index, final animation) =>
                        AnimatedMenuCard(
                      key: Key(controller.itemList[index].value.uuid),
                      menu: controller.itemList[index].value.menu,
                      animation: animation,
                      actions: [
                        CardQtyEditor(cart: controller.itemList[index]),
                        const SizedBox(width: 20),
                        _CartNoteWidget(cart: controller.itemList[index]),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    child: Text(S.current.ordeButtonr),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all(Get.theme.primaryColor),
                      textStyle: MaterialStateProperty.all(const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      )),
                    ),
                    onPressed: () {
                      if (controller.itemList.isEmpty) {
                        Helper.showError(text: S.current.errorEmptyCart);
                      } else {
                        Get.offNamed(Routes.makeOrder);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class _CartNoteWidget extends StatelessWidget {
  final Rx<Cart> cart;
  const _CartNoteWidget({
    Key? key,
    required this.cart,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) => SizedBox(
        height: kSecondaryButtonHeight,
        width: secondaryButtonSize,
        child: ElevatedButton(
          child: Text(S.current.note),
          style: seondaryButtonStyle,
          onPressed: _onShowNoteDialog,
        ),
      );

  void _onShowNoteDialog() async {
    final controller = TextEditingController(text: cart.value.note);
    try {
      await Get.bottomSheet(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Card(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 10.0),
                  SizedBox(
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        labelText: S.current.note,
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        focusedBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                      ),
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                            const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)))),
                        backgroundColor:
                            MaterialStateProperty.all(Get.theme.primaryColor),
                        textStyle: MaterialStateProperty.all(const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ))),
                    child: Text(S.current.save),
                    onPressed: Get.back,
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
        ),
      ));
      await Future.delayed(const Duration(milliseconds: 500));
      cart.value = cart.value.updateNote(controller.text);
      await CartService.instance.updateNote(cart.value.menu, controller.text);
    } catch (error, st) {
      ErrorReporter.instance.captureException(error, st);
    } finally {
      controller.dispose();
    }
  }
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
      (context, animation) => AnimatedMenuCard(
        key: Key(item.value.uuid),
        menu: item.value.menu,
        animation: animation,
        actions: [
          CardQtyEditor(cart: item),
          const SizedBox(width: 20),
          _CartNoteWidget(cart: item),
        ],
      ),
    );
  }

  void _onQtyChanged(final int index) {
    itemList[index].value = CartService.instance.itemList[index];
  }
}
