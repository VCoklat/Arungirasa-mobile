part of 'main_page.dart';

class _RestaurantSelector extends GetView<_MainPageController> {
  const _RestaurantSelector();
  @override
  Widget build(BuildContext context) => new Center(
        child: new InkWell(
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
          onTap: () => SelectDialog.showModal<Restaurant?>(
            context,
            label: "Restaurant",
            selectedValue: controller.restaurant.value == null
                ? null
                : controller.restaurantList
                    .firstWhere((e) => e.id == controller.restaurant.value!.id),
            showSearchBox: false,
            items: controller.restaurantList,
            itemBuilder: (_, item, isSelected) => new ListTile(
              title: new Text(item!.name),
              selected: isSelected,
            ),
            onChange: (final item) {
              controller.restaurant.value = item;
              controller.update();
              controller.loadMenu();
            },
          ),
        ),
      );
}
