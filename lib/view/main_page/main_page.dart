import 'package:arungi_rasa/common/error_reporter.dart';
import 'package:arungi_rasa/generated/assets.gen.dart';
import 'package:arungi_rasa/generated/l10n.dart';
import 'package:arungi_rasa/model/food_drink_menu.dart';
import 'package:arungi_rasa/model/restaurant.dart';
import 'package:arungi_rasa/repository/menu_repository.dart';
import 'package:arungi_rasa/repository/restaurant_repository.dart';
import 'package:arungi_rasa/service/session_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:octo_image/octo_image.dart';

part 'restaurant.banner.dart';
part 'restaurant.info.dart';
part 'menu.card.dart';
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
              actions: [const _UserPhotoProfile()],
            ),
          ],
          body: new RefreshIndicator(
            key: controller.refreshKey,
            onRefresh: controller.loadRestaurant,
            child: new Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  new _SearchTextField(),
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
                        itemBuilder: (_, index, animation) => new _MenuCard(
                          menu: controller.menuList[index],
                          animation: animation,
                          isInWishList: false,
                          onPressed: (_) {},
                          onAddPressed: (_) {},
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

class _MainPageController extends GetxController {
  final refreshKey = new GlobalKey<RefreshIndicatorState>();
  final menuListKey = new GlobalKey<AnimatedListState>();

  final restaurant = new Rxn<Restaurant>();
  final menuList = new RxList<FoodDrinkMenu>();

  Future<void> onSort() async {}

  @override
  void onReady() {
    super.onReady();
    new Future.delayed(Duration.zero, () => refreshKey.currentState!.show());
  }

  Future<void> loadRestaurant() async {
    restaurant.value = await RestaurantRepository.instance
        .findOneNearest(SessionService.instance.location.value);
    loadMenu();
  }

  Future<void> loadMenu() async {
    if (restaurant.value == null) return;
    try {
      await cleanUpMenu();

      final list =
          await FoodDrinkMenuRepository.instance.find(restaurant.value!.id);
      int index = 0;
      for (final menu in list) {
        menuList.add(menu);
        menuListKey.currentState!.insertItem(index++);
        await new Future.delayed(const Duration(milliseconds: 500));
      }
    } catch (error, st) {
      ErrorReporter.instance.captureException(error, st);
    }
  }

  Future<void> cleanUpMenu() async {
    for (int i = menuList.length - 1; i > -1; --i) {
      menuListKey.currentState!.removeItem(
          i,
          (_, animation) => new _MenuCard(
                menu: menuList[i],
                animation: animation,
                isInWishList: false,
              ),
          duration: const Duration(milliseconds: 300));
      await new Future.delayed(const Duration(milliseconds: 300));
    }
    menuList.clear();
  }
}

class _UserPhotoProfile extends StatelessWidget {
  const _UserPhotoProfile();
  @override
  Widget build(BuildContext context) => Padding(
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
      );
}

class _SearchTextField extends StatelessWidget {
  final ValueChanged<String>? onChange;
  const _SearchTextField({Key? key, this.onChange}) : super(key: key);
  @override
  Widget build(BuildContext context) => new TextField(
        decoration: new InputDecoration(
          labelText: S.current.searchCulinary,
          border: new OutlineInputBorder(
              borderRadius: const BorderRadius.all(const Radius.circular(30))),
          focusedBorder: new OutlineInputBorder(
              borderRadius: const BorderRadius.all(const Radius.circular(30))),
          suffixIcon: const Icon(Icons.search),
        ),
        onChanged: onChange,
      );
}

class ImageContinuousClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(200 * 0.625))
        .getOuterPath(Rect.fromLTWH(0, 0, size.width, size.height));
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _RestaurantSelector extends GetView<_MainPageController> {
  const _RestaurantSelector();
  @override
  Widget build(BuildContext context) => new Center(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            new Center(
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  new Text(
                    S.current.location,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14.0,
                    ),
                  ),
                  new Icon(
                    Icons.keyboard_arrow_down_sharp,
                    color: Get.theme.primaryColor,
                    size: 30.0,
                  ),
                ],
              ),
            ),
            new Center(
              child: new Obx(
                () => new Text(
                  controller.restaurant.value?.name ?? S.current.appName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
