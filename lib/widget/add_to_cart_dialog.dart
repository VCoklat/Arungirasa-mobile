import 'package:arungi_rasa/common/helper.dart';
import 'package:arungi_rasa/generated/l10n.dart';
import 'package:arungi_rasa/model/food_drink_menu.dart';
import 'package:arungi_rasa/service/cart_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:octo_image/octo_image.dart';

class AddToCartDialog extends StatelessWidget {
  final FoodDrinkMenu menu;

  const AddToCartDialog({Key? key, required this.menu}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
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
                children: [
                  const SizedBox(height: 2.0),
                  _image,
                  const SizedBox(height: 10.0),
                  _name,
                  const SizedBox(height: 5.0),
                  _description,
                  const SizedBox(height: 10.0),
                  _price,
                  const SizedBox(height: 10.0),
                  _button,
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
        ),
      );

  Widget get _button => ElevatedButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)))),
            backgroundColor: MaterialStateProperty.all(Get.theme.primaryColor),
            textStyle: MaterialStateProperty.all(const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ))),
        child: Text(S.current.addToCart),
        onPressed: () async {
          await CartService.instance
              .insertCart(menu, CartService.instance.getQty(menu.ref) + 1);
          Get.back();
        },
      );

  Widget get _description => Text(
        menu.description,
        maxLines: 3,
        style: const TextStyle(fontSize: 14),
      );

  Widget get _price => Text(
        Helper.formatMoney(menu.price.toDouble()),
        style: TextStyle(
          color: Get.theme.primaryColor,
          fontWeight: FontWeight.w600,
          fontSize: 24.0,
        ),
      );

  Widget get _name => Text(
        menu.name,
        style: TextStyle(
          color: Get.theme.primaryColor,
          fontWeight: FontWeight.w600,
          fontSize: 26.0,
        ),
      );

  Widget get _image => AspectRatio(
        aspectRatio: 16 / 8.5,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          child: OctoImage(
            image: CachedNetworkImageProvider(menu.imageList.first.url),
            placeholderBuilder:
                OctoPlaceholder.blurHash(menu.imageList.first.blurhash),
            errorBuilder: OctoError.blurHash(menu.imageList.first.blurhash),
            fit: BoxFit.cover,
          ),
        ),
      );
}
