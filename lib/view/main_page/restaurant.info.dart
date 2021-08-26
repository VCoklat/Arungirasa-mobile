part of 'main_page.dart';

class _RestaurantInfo extends GetView<_MainPageController> {
  const _RestaurantInfo();
  @override
  Widget build(BuildContext context) => new Padding(
        padding: const EdgeInsets.only(left: 80),
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
                new Icon(
                  Icons.location_on_outlined,
                  color: Get.theme.primaryColor,
                ),
                new Obx(
                  () => new _RestaurantDistance(
                    future: controller.restaurant.value == null
                        ? null
                        : RestaurantRepository.instance.distance(
                            ref: controller.restaurant.value!.ref,
                            latLng: SessionService.instance.location.value,
                          ),
                  ),
                ),
                const SizedBox(
                  width: 10.0,
                ),
                const Icon(
                  Icons.star,
                  color: Colors.orangeAccent,
                ),
                new _RestaurantRating(
                  future: controller.restaurant.value == null
                      ? null
                      : RestaurantRepository.instance
                          .rating(controller.restaurant.value!.ref),
                ),
              ],
            ),
          ],
        ),
      );
}

class _RestaurantDistance extends StatelessWidget {
  final Future<double>? future;
  const _RestaurantDistance({Key? key, this.future}) : super(key: key);
  @override
  Widget build(BuildContext context) => FutureBuilder<double>(
        initialData: 0,
        future: future,
        builder: (_, snapshot) => new Text(
          "${((snapshot.data ?? 0) / 1000).toStringAsFixed(1)}Km",
          style: new TextStyle(
            color: Get.theme.primaryColor,
            fontSize: 16.0,
          ),
        ),
      );
}

class _RestaurantRating extends StatelessWidget {
  final Future<double>? future;
  const _RestaurantRating({Key? key, this.future}) : super(key: key);
  @override
  Widget build(BuildContext context) => FutureBuilder<double>(
        initialData: 0,
        future: future,
        builder: (_, snapshot) => new Text(
          snapshot.data?.toStringAsFixed(1) ?? "0.0",
          style: new TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
      );
}
