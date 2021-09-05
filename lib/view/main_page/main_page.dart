import 'dart:math';

import 'package:arungi_rasa/common/error_reporter.dart';
import 'package:arungi_rasa/common/helper.dart';
import 'package:arungi_rasa/generated/assets.gen.dart';
import 'package:arungi_rasa/generated/l10n.dart';
import 'package:arungi_rasa/model/food_drink_menu.dart';
import 'package:arungi_rasa/model/order.dart';
import 'package:arungi_rasa/model/restaurant.dart';
import 'package:arungi_rasa/repository/menu_repository.dart';
import 'package:arungi_rasa/repository/restaurant_repository.dart';
import 'package:arungi_rasa/routes/routes.dart';
import 'package:arungi_rasa/service/cart_service.dart';
import 'package:arungi_rasa/service/order_service.dart';
import 'package:arungi_rasa/service/session_service.dart';
import 'package:arungi_rasa/widget/menu_card.dart';
import 'package:arungi_rasa/widget/order_card.dart';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:octo_image/octo_image.dart';
import 'package:select_dialog/select_dialog.dart';

part 'controller.dart';
part 'restaurant.banner.dart';
part 'restaurant.info.dart';
part 'restaurant.selector.dart';
part 'cart.button.dart';
part 'add.to.cart.dialog.dart';
part 'order.widget.dart';

const _kPriceColor = const Color(0XFFF7931E);

class MainPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<_MainPageController>(() => new _MainPageController());
  }
}

class MainPage extends GetView<_MainPageController> {
  const MainPage();
  @override
  Widget build(BuildContext context) => new Scaffold(
        body: new NestedScrollView(
          headerSliverBuilder: (_, __) => [
            new SliverAppBar(
              centerTitle: true,
              backgroundColor: Get.theme.scaffoldBackgroundColor,
              elevation: 0.0,
              title: const _RestaurantSelector(),
              leading: const _UserPhotoProfile(),
              actions: [
                new IconButton(
                  icon: const Icon(Icons.chat_bubble_outline_sharp),
                  onPressed: () => Get.toNamed(Routes.chat),
                ),
              ],
            ),
          ],
          body: new RefreshIndicator(
            key: controller.refreshKey,
            onRefresh: controller.loadRestaurant,
            child: new Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: new Stack(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                children: [
                  const _MainPageContent(),
                  new Positioned(
                    bottom: 10,
                    left: 10,
                    right: 10,
                    child: const _OrderList(),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: const _CartButton(),
      );
}

class _MainPageContent extends GetView<_MainPageController> {
  const _MainPageContent();
  @override
  Widget build(BuildContext context) => new Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 10,
          ),
          new _SearchTextField(
            onSubmitted: controller.onSearch,
          ),
          const SizedBox(
            height: 20.0,
          ),
          const _RestaurantBanner(),
          const SizedBox(
            height: 7.0,
          ),
          const _RestaurantInfo(),
          const SizedBox(
            height: 10.0,
          ),
          new Expanded(
            child: new SingleChildScrollView(
              child: new AnimatedList(
                key: controller.menuListKey,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (_, index, animation) => new AnimatedMenuCard(
                  menu: controller.menuList[index],
                  animation: animation,
                  onAddPressed: controller.showAddToCartDialog,
                ),
              ),
            ),
          ),
        ],
      );
}

class _UserPhotoProfile extends StatelessWidget {
  const _UserPhotoProfile();
  @override
  Widget build(BuildContext context) => new InkWell(
        child: new Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 40.0,
            height: 60.0,
            child: new Material(
              shape: new ContinuousRectangleBorder(
                borderRadius: const BorderRadius.all(const Radius.circular(15)),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              borderOnForeground: true,
              child: new ObxValue<Rxn<User>>(
                (data) => data.value == null || data.value?.photoURL == null
                    ? Assets.images.placeholderProfile.image(
                        fit: BoxFit.cover,
                      )
                    : new Image.network(
                        data.value!.photoURL!,
                        fit: BoxFit.cover,
                      ),
                SessionService.instance.user,
              ),
            ),
          ),
        ),
        onTap: () => Get.toNamed(Routes.profile),
      );
}

class _SearchTextField extends StatelessWidget {
  final ValueChanged<String>? onSubmitted;
  const _SearchTextField({Key? key, this.onSubmitted}) : super(key: key);
  @override
  Widget build(BuildContext context) => new SizedBox(
        height: 40,
        child: new TextField(
          decoration: new InputDecoration(
            labelText: S.current.searchCulinary,
            border: new OutlineInputBorder(
                borderRadius:
                    const BorderRadius.all(const Radius.circular(30))),
            focusedBorder: new OutlineInputBorder(
                borderRadius:
                    const BorderRadius.all(const Radius.circular(30))),
            suffixIcon: const Icon(Icons.search),
          ),
          onSubmitted: onSubmitted,
        ),
      );
}
