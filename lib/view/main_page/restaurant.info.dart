part of 'main_page.dart';

class _RestaurantInfo extends GetView<_MainPageController> {
  const _RestaurantInfo();
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => Text(
                controller.restaurant.value?.name ?? S.current.appName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Get.theme.primaryColor,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: Get.theme.primaryColor,
                ),
                Obx(
                  () => _RestaurantDistance(
                    future: controller.restaurant.value == null
                        ? null
                        : MapBoxRepository.instance.getDistance(
                            controller.restaurant.value!.latLng,
                            SessionService.instance.location.value,
                          ),
                  ),
                ),
                const SizedBox(width: 10.0),
                const Icon(Icons.star, color: Colors.orangeAccent),
                Obx(
                  () => Text(
                    (controller.restaurant.value?.rating ?? .0)
                        .toStringAsFixed(1),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
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
        builder: (_, snapshot) => Text(
          "${((snapshot.data ?? 0) / 1000).toStringAsFixed(1)}Km",
          style: TextStyle(color: Get.theme.primaryColor, fontSize: 16.0),
        ),
      );
}
