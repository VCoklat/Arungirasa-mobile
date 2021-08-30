part of 'main_page.dart';

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

  Future<void> onSearch(final String query) async {
    if (restaurant.value == null) return;
    try {
      await cleanUpMenu();

      final list = await FoodDrinkMenuRepository.instance
          .find(restaurantRef: restaurant.value!.ref, query: query);
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

  Future<void> loadMenu() async {
    final restaurant = this.restaurant.value;
    if (restaurant == null) return;
    try {
      await cleanUpMenu();

      final list = await FoodDrinkMenuRepository.instance
          .find(restaurantRef: restaurant.ref);
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
          (_, animation) => new AnimatedMenuCard(
                menu: menuList[i],
                animation: animation,
              ),
          duration: const Duration(milliseconds: 300));
      await new Future.delayed(const Duration(milliseconds: 300));
    }
    menuList.clear();
  }

  Future<void> showAddToCartDialog(final FoodDrinkMenu menu) async {
    await Get.bottomSheet(new _AddToCartDialog(menu: menu));
  }
}
