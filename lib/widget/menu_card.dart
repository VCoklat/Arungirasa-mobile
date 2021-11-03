import 'package:arungi_rasa/common/config.dart';
import 'package:arungi_rasa/common/helper.dart';
import 'package:arungi_rasa/generated/l10n.dart';
import 'package:arungi_rasa/model/food_drink_menu.dart';
import 'package:arungi_rasa/service/wistlist_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:octo_image/octo_image.dart';

class AnimatedMenuCard extends StatelessWidget {
  final FoodDrinkMenu menu;
  final Animation<double> animation;
  final ValueChanged<FoodDrinkMenu>? onAddPressed;
  final List<Widget> actions;
  final String? note;

  const AnimatedMenuCard({
    Key? key,
    required this.menu,
    required this.animation,
    this.onAddPressed,
    this.actions = const [],
    this.note,
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
          actions: actions,
          note: note,
        ),
      );
}

class MenuCard extends StatelessWidget {
  final FoodDrinkMenu menu;
  final ValueChanged<FoodDrinkMenu>? onAddPressed;
  final List<Widget> actions;
  final String? note;

  const MenuCard({
    Key? key,
    required this.menu,
    this.onAddPressed,
    this.actions = const [],
    this.note,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: Get.width * 0.35,
            child: Row(
              children: [
                Stack(
                  children: [
                    _getImage(Get.width * 0.35),
                    Positioned(
                      top: 7.5,
                      right: 7.5,
                      child: _wishlistButton,
                    ),
                  ],
                ),
                const SizedBox(width: 20.0),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7.5),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _title,
                        const SizedBox(height: 10.0),
                        _description,
                        const SizedBox(height: 10.0),
                        _priceText,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          note == null ? const SizedBox() : const SizedBox(height: 10.0),
          note == null
              ? const SizedBox()
              : Padding(
                  padding: EdgeInsets.only(left: Get.width * 0.35 + 20),
                  child: Text(
                    S.current.note,
                    style: TextStyle(
                      color: Get.theme.primaryColor,
                      fontSize: 10.0,
                    ),
                  ),
                ),
          note == null
              ? const SizedBox()
              : Padding(
                  padding: EdgeInsets.only(left: Get.width * 0.35 + 20),
                  child: Text(
                    note!,
                    style: TextStyle(
                      color: Get.theme.primaryColor,
                      fontSize: 18.0,
                    ),
                  ),
                ),
          const SizedBox(height: 20.0),
          Row(
            textDirection: TextDirection.rtl,
            children: [
              _addButton,
              ...actions,
            ],
          ),
        ],
      );

  Widget get _priceText => FittedBox(
        child: Text(
          Helper.formatMoney(menu.price.toDouble()),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Get.theme.primaryColor,
            fontSize: 16.0,
          ),
        ),
      );

  Widget get _wishlistButton => SizedBox(
        height: Get.width * 0.4 * 0.2,
        width: Get.width * 0.4 * 0.2,
        child: InkWell(
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(90))),
            child: Center(
              child: ObxValue<RxList<FoodDrinkMenu>>(
                (obs) => obs.any((e) => e.ref == menu.ref)
                    ? Icon(
                        Icons.favorite_sharp,
                        color: Colors.red,
                        size: (Get.width * 0.4 * 0.2) - 5,
                      )
                    : Icon(
                        Icons.favorite_border_sharp,
                        color: Colors.red,
                        size: (Get.width * 0.4 * 0.2) - 5,
                      ),
                WishListService.instance.itemList,
              ),
            ),
          ),
          onTap: () => WishListService.instance.toggle(menu),
        ),
      );

  Widget get _addButton => onAddPressed == null
      ? const SizedBox()
      : SizedBox(
          height: kSecondaryButtonHeight,
          width: secondaryButtonSize,
          child: ElevatedButton(
            child: Text(S.current.add),
            style: seondaryButtonStyle,
            onPressed: onAddPressed != null ? () => onAddPressed!(menu) : null,
          ),
        );

  Widget get _description => Expanded(
        child: Text(
          menu.description,
          maxLines: null,
          style: TextStyle(
            fontSize: 16.0,
            color: Get.theme.primaryColor,
          ),
        ),
      );

  Widget get _title => Text(
        menu.name,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Get.theme.primaryColor,
          fontSize: 16.0,
          wordSpacing: 2.5,
          //fontFamily: FontFamily.monetaSans,
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
