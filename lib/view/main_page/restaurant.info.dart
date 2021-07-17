part of 'main_page.dart';

class _RestaurantInfo extends GetView<_MainPageController> {
  const _RestaurantInfo();
  @override Widget build(BuildContext context) => new Padding(
    padding: const EdgeInsets.only( left: 80 ),
    child: new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        new Obx(
          () => new Text(
            controller.restaurant.value?.name ?? S.current.appName,
            style: new TextStyle(
              fontWeight: FontWeight.bold,
              color: Get.theme.primaryColor,
            ),
          ),
        ),
        new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            new Icon( Icons.location_on_outlined, color: Get.theme.primaryColor, ),
            new Text(
              "3.3Km",
              style: new TextStyle(
                color: Get.theme.primaryColor,
                fontSize: 16.0,
              ),
            ),
            const SizedBox( width: 10.0, ),
            const Icon( Icons.star, color: Colors.orangeAccent, ),
            new Text(
              "4.8",
              style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            new Expanded(
              child: new Align(
                alignment: Alignment.centerRight,
                child: _sortButton,
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget get _sortButton => new SizedBox(
    height: 25.0,
    width: 50.0,
    child: new MaterialButton(
      shape: new RoundedRectangleBorder(
        borderRadius: const BorderRadius.all( const Radius.circular( 15.0 ) ),
        side: new BorderSide( color: Get.theme.primaryColor ),
      ),
      child: new FittedBox( child: new Text( "Sort" ), ),
      textColor: Get.theme.primaryColor,
      onPressed: controller.onSort,
    ),
  );
}