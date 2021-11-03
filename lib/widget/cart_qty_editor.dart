import 'package:arungi_rasa/model/cart.dart';
import 'package:arungi_rasa/service/cart_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardQtyEditor extends StatelessWidget {
  final Rx<Cart> cart;
  const CardQtyEditor({
    Key? key,
    required this.cart,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(90)),
                border: Border.fromBorderSide(
                    BorderSide(color: Get.theme.primaryColor)),
              ),
              padding: const EdgeInsets.all(2.5),
              child: Icon(Icons.remove_sharp, color: Get.theme.primaryColor),
            ),
            onTap: () => CartService.instance.subtractCart(cart.value.menu),
          ),
          const SizedBox(width: 15),
          ObxValue<Rx<Cart>>(
            (obs) => Text(
              obs.value.qty.toString(),
              style: TextStyle(
                color: Get.theme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            cart,
          ),
          const SizedBox(width: 15),
          InkWell(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(90)),
                border: Border.fromBorderSide(
                    BorderSide(color: Get.theme.primaryColor)),
              ),
              padding: const EdgeInsets.all(2.5),
              child: Icon(Icons.add_sharp, color: Get.theme.primaryColor),
            ),
            onTap: () => CartService.instance.addCart(cart.value.menu),
          ),
        ],
      );
}
