part of 'main_page.dart';

class _MainPageController extends GetxController with MixinControllerWorker {
  final refreshKey = GlobalKey<RefreshIndicatorState>();
  final menuListKey = GlobalKey<AnimatedListState>();

  final restaurantList = RxList<Restaurant>();
  final restaurant = Rxn<Restaurant>();
  final menuList = RxList<FoodDrinkMenu>();

  final searchQuery = RxString("");

  late TextEditingController searchController;

  @override
  void onInit() {
    searchController = TextEditingController();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    Future.delayed(Duration.zero, () => refreshKey.currentState!.show());
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> onRefresh() async {
    if (restaurant.value == null) {
      await loadRestaurant();
    } else {
      await loadMenu();
    }
  }

  Future<void> loadRestaurant() async {
    restaurantList.assignAll(await RestaurantRepository.instance.find());
    restaurant.value = await RestaurantRepository.instance
        .findOneNearest(LocationService.instance.location.value);
    loadMenu();
  }

  Future<void> onSearch(final String query) async {
    if (restaurant.value == null) return;
    if (query.isEmpty) return;
    try {
      await cleanUpMenu();

      final list = await FoodDrinkMenuRepository.instance
          .find(restaurantRef: restaurant.value?.ref, query: query);
      int index = 0;
      for (final menu in list) {
        menuList.add(menu);
        menuListKey.currentState!.insertItem(index++);
        await Future.delayed(const Duration(milliseconds: 500));
      }
    } catch (error, st) {
      ErrorReporter.instance.captureException(error, st);
    }
  }

  Future<void> loadMenu() async {
    if (searchController.text.isNotEmpty) {
      await onSearch(searchController.text);
      return;
    }
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
        await Future.delayed(const Duration(milliseconds: 500));
      }
    } catch (error, st) {
      ErrorReporter.instance.captureException(error, st);
    }
  }

  Future<void> cleanUpMenu() async {
    for (int i = menuList.length - 1; i > -1; --i) {
      menuListKey.currentState!.removeItem(
          i,
          (_, animation) => AnimatedMenuCard(
                menu: menuList[i],
                animation: animation,
              ),
          duration: const Duration(milliseconds: 300));
      await Future.delayed(const Duration(milliseconds: 300));
    }
    menuList.clear();
  }

  Future<void> showAddToCartDialog(final FoodDrinkMenu menu) async {
    await Get.bottomSheet(_AddToCartDialog(menu: menu));
  }

  @override
  List<Worker> getWorkers() =>
      <Worker>[debounce<String>(searchQuery, onSearch)];
}
