part of 'main_page.dart';

class _RestaurantBanner extends GetView<_MainPageController> {
  const _RestaurantBanner();
  @override
  Widget build(BuildContext context) => new Stack(
        clipBehavior: Clip.none,
        children: [
          _imageBanner,
          _restaurantProfile,
        ],
      );

  Widget get _restaurantProfile => new Positioned(
        left: 10,
        top: 90,
        child: new CircleAvatar(
          radius: 30,
          backgroundColor: Colors.white,
          child: Assets.images.logoWithText.image(),
        ),
      );

  Widget get _imageBanner => new SizedBox(
        height: 110,
        width: Get.width - 40,
        child: new Material(
          shape: new RoundedRectangleBorder(
              borderRadius:
                  const BorderRadius.all(const Radius.circular(20.0))),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: new Obx(
            () => new OctoImage(
              image: new CachedNetworkImageProvider(controller
                      .restaurant.value?.imageList.first.url ??
                  "https://firebasestorage.googleapis.com/v0/b/arungi-rasa.appspot.com/o/default.jpg?alt=media&token=5ccfee2e-99c5-4347-8204-185d2e07b89a"),
              placeholderBuilder: OctoPlaceholder.blurHash(
                  controller.restaurant.value?.imageList.first.blurhash ??
                      "LCGHeu025XtQ00~V=_NI0h\$ewIRP"),
              errorBuilder: OctoError.blurHash(
                  controller.restaurant.value?.imageList.first.blurhash ??
                      "LCGHeu025XtQ00~V=_NI0h\$ewIRP"),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
}
