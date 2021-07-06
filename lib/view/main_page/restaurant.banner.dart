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
      shape: new RoundedRectangleBorder( borderRadius: const BorderRadius.all( const Radius.circular( 20.0 ) ) ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: new Image.network(
        "https://firebasestorage.googleapis.com/v0/b/arungi-rasa.appspot.com/o/restaurant%2F1%2Fmenu%2F1%2Fsate.jpg?alt=media&token=9650894a-0fbf-499e-ad6a-c8d846928e44",
        fit: BoxFit.cover,
      ),
    ),
  );
}