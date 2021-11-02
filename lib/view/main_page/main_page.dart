import 'dart:math';

import 'package:arungi_rasa/common/config.dart';
import 'package:arungi_rasa/common/error_reporter.dart';
import 'package:arungi_rasa/common/mixin_controller_worker.dart';
import 'package:arungi_rasa/generated/assets.gen.dart';
import 'package:arungi_rasa/generated/l10n.dart';
import 'package:arungi_rasa/model/food_drink_menu.dart';
import 'package:arungi_rasa/model/restaurant.dart';
import 'package:arungi_rasa/repository/mapbox_repository.dart';
import 'package:arungi_rasa/repository/menu_repository.dart';
import 'package:arungi_rasa/repository/restaurant_repository.dart';
import 'package:arungi_rasa/routes/routes.dart';
import 'package:arungi_rasa/service/cart_service.dart';
import 'package:arungi_rasa/service/location_service.dart';
import 'package:arungi_rasa/service/notification_service.dart';
import 'package:arungi_rasa/service/order_service.dart';
import 'package:arungi_rasa/service/session_service.dart';
import 'package:arungi_rasa/widget/add_to_cart_dialog.dart';
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
part 'order.widget.dart';

class MainPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<_MainPageController>(() => _MainPageController());
  }
}

class MainPage extends GetView<_MainPageController> {
  const MainPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (_, __) => [
            SliverAppBar(
              centerTitle: true,
              backgroundColor: Get.theme.scaffoldBackgroundColor,
              elevation: 0.0,
              title: const _RestaurantSelector(),
              leading: const _UserPhotoProfile(),
              actions: [
                IconButton(
                  icon: Badge(
                    badgeContent: FittedBox(
                      child: ObxValue<RxInt>(
                        (obs) => Text(obs.value.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            )),
                        NotificationService.instance.unreadCount,
                      ),
                    ),
                    child: Icon(
                      Icons.notifications,
                      color: Get.theme.primaryColor,
                      size: 28,
                    ),
                    badgeColor: Get.theme.primaryColor,
                    showBadge: true,
                    stackFit: StackFit.loose,
                    toAnimate: true,
                  ),
                  color: Get.theme.primaryColor,
                  onPressed: () => Get.toNamed(Routes.notification),
                ),
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline_sharp),
                  color: Get.theme.primaryColor,
                  onPressed: () => Get.toNamed(Routes.chat),
                ),
              ],
            ),
          ],
          body: RefreshIndicator(
            key: controller.refreshKey,
            onRefresh: controller.onRefresh,
            child: Padding(
              padding: kPagePadding,
              child: Stack(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                children: const [
                  _MainPageContent(),
                  Positioned(
                    bottom: 50,
                    left: 10,
                    right: 10,
                    child: _OrderList(),
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
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          const _SearchTextField(),
          const SizedBox(height: 20.0),
          const _RestaurantBanner(),
          const SizedBox(height: 7.0),
          const _RestaurantInfo(),
          const SizedBox(height: 30.0),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  AnimatedList(
                    key: controller.menuListKey,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (_, index, animation) => Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: AnimatedMenuCard(
                        menu: controller.menuList[index],
                        animation: animation,
                        onAddPressed: controller.showAddToCartDialog,
                      ),
                    ),
                  ),
                  const SizedBox(height: 60.0),
                ],
              ),
            ),
          ),
        ],
      );
}

class _UserPhotoProfile extends StatelessWidget {
  const _UserPhotoProfile();
  @override
  Widget build(BuildContext context) => InkWell(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 40.0,
            height: 60.0,
            child: Material(
              shape: const ContinuousRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              borderOnForeground: true,
              child: ObxValue<Rxn<User>>(
                (data) => data.value == null || data.value?.photoURL == null
                    ? Assets.images.placeholderProfile.image(
                        fit: BoxFit.cover,
                      )
                    : Image.network(
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

class _SearchTextField extends GetView<_MainPageController> {
  const _SearchTextField({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => SizedBox(
        height: 40,
        child: TextField(
          controller: controller.searchController,
          decoration: InputDecoration(
            labelText: S.current.searchCulinary,
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            suffixIcon: const Icon(Icons.search),
          ),
          onSubmitted: controller.onSearch,
          onChanged: (final text) => controller.searchQuery.value = text,
        ),
      );
}
