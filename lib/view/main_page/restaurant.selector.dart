part of 'main_page.dart';

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
