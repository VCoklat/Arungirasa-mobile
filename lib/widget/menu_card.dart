import 'package:arungi_rasa/common/helper.dart';
import 'package:arungi_rasa/generated/fonts.gen.dart';
import 'package:arungi_rasa/generated/l10n.dart';
import 'package:arungi_rasa/model/food_drink_menu.dart';
import 'package:arungi_rasa/service/wistlist_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:octo_image/octo_image.dart';

const _kPriceColor = Color(0XFFF7931E);

class AnimatedMenuCard extends StatelessWidget {
  final FoodDrinkMenu menu;
  final Animation<double> animation;
  final ValueChanged<FoodDrinkMenu>? onAddPressed;

  const AnimatedMenuCard({
    Key? key,
    required this.menu,
    required this.animation,
    this.onAddPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-1, 0),
          end: const Offset(0, 0),
        ).animate(animation),
        child: MenuCard(
          menu: menu,
          onAddPressed: onAddPressed,
        ),
      );
}

class MenuCard extends StatelessWidget {
  final FoodDrinkMenu menu;
  final ValueChanged<FoodDrinkMenu>? onAddPressed;

  const MenuCard({
    Key? key,
    required this.menu,
    this.onAddPressed,
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
                  Stack(
                    children: [
                      _getImage(constraints.maxWidth * 0.4),
                      Positioned(
                        top: 5.0,
                        right: .0,
                        child: _wishlistButton,
                      ),
                    ],
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _title,
                        const SizedBox(height: 5.0),
                        _description,
                        const SizedBox(height: 5.0),
                        Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            _addButton,
                            const SizedBox(width: 5.0),
                            _priceText,
                          ],
                        ),
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

  Widget get _priceText => Expanded(
        child: FittedBox(
          child: Text(
            Helper.formatMoney(menu.price.toDouble()),
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: _kPriceColor,
            ),
          ),
        ),
      );

  Widget get _wishlistButton => SizedBox(
        height: 25.0,
        child: IconButton(
          icon: ObxValue<RxList<FoodDrinkMenu>>(
            (obs) => obs.any((e) => e.ref == menu.ref)
                ? const Icon(
                    Icons.favorite_sharp,
                    color: Colors.red,
                  )
                : const Icon(
                    Icons.favorite_border_sharp,
                    color: Colors.red,
                  ),
            WishListService.instance.itemList,
          ),
          padding: EdgeInsets.zero,
          iconSize: 30,
          onPressed: () => WishListService.instance.toggle(menu),
        ),
      );

  Widget get _addButton => onAddPressed == null
      ? const SizedBox()
      : SizedBox(
          height: 25.0,
          child: ElevatedButton(
            child: Text(S.current.add),
            style: ButtonStyle(
                padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 5.0)),
                backgroundColor:
                    MaterialStateProperty.all(Get.theme.primaryColor),
                shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)))),
                textStyle: MaterialStateProperty.all(const TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                ))),
            onPressed: onAddPressed != null ? () => onAddPressed!(menu) : null,
          ),
        );

  Widget get _description => Expanded(
        child: Text(
          menu.description,
          maxLines: null,
          style: const TextStyle(
            fontSize: 14.0,
          ),
        ),
      );

  Widget get _title => Text(
        menu.name,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Get.theme.primaryColor,
          fontSize: 18.0,
          wordSpacing: 2.5,
          fontFamily: FontFamily.monetaSans,
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
            image: CachedNetworkImageProvider(menu.imageList.first.url),
            placeholderBuilder:
                OctoPlaceholder.blurHash(menu.imageList.first.blurhash),
            errorBuilder: OctoError.blurHash(menu.imageList.first.blurhash),
            fit: BoxFit.cover,
          ),
        ),
      );
}
