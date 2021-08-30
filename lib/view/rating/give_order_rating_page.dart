import 'package:arungi_rasa/common/config.dart';
import 'package:arungi_rasa/common/error_reporter.dart';
import 'package:arungi_rasa/common/helper.dart';
import 'package:arungi_rasa/generated/fonts.gen.dart';
import 'package:arungi_rasa/generated/l10n.dart';
import 'package:arungi_rasa/model/order.dart';
import 'package:arungi_rasa/repository/order_repository.dart';
import 'package:arungi_rasa/repository/rating_repository.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:gradient_loading_button/gradient_loading_button.dart';

class _GiveOrderRatingPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<_GiveOrderRatingPageController>(
        () => new _GiveOrderRatingPageController());
  }
}

class GiveOrderRatingPage extends GetView<_GiveOrderRatingPageController> {
  const GiveOrderRatingPage();
  static _GiveOrderRatingPageBinding binding() =>
      new _GiveOrderRatingPageBinding();
  @override
  Widget build(BuildContext context) => new Scaffold(
        body: new NestedScrollView(
          headerSliverBuilder: (_, __) => <Widget>[
            new SliverAppBar(
              title: new Text(S.current.giveRating),
            ),
          ],
          body: new Obx(
            () {
              if (controller.onLoading.value) {
                return const _LoadingWidget();
              } else if (controller.isError.value) {
                return new _ErrorWidget(controller.loadOrder);
              } else if (controller.order.value == null) {
                return const _NotFoundWidget();
              } else {
                return new SingleChildScrollView(
                  child: const _RatingWidget(),
                );
              }
            },
          ),
        ),
      );
}

class _RatingWidget extends GetView<_GiveOrderRatingPageController> {
  const _RatingWidget();
  @override
  Widget build(BuildContext context) => new Padding(
        padding: const EdgeInsets.all(20.0),
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _RestaurantWidget(),
            const Divider(),
            new SizedBox(
              height: 100,
              child: new Obx(
                () => controller.order.value!.menuList.length == 1
                    ? new _OrderItem(
                        orderMenu: controller.order.value!.menuList.first,
                      )
                    : new Swiper(
                        itemCount: controller.order.value!.menuList.length,
                        autoplay: true,
                        itemBuilder: (_, final int index) => new _OrderItem(
                          orderMenu: controller.order.value!.menuList[index],
                        ),
                      ),
              ),
            ),
            const Divider(),
            const Text(
              "Rating",
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12.0,
              ),
            ),
            new RatingBar.builder(
              initialRating: controller.rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) => controller.rating = rating,
            ),
            const Divider(),
            new Padding(
              padding: const EdgeInsets.all(20),
              child: new LoadingButton(
                child: new Text(S.current.send),
                successChild: const Icon(
                  Icons.check_sharp,
                  size: 35,
                  color: Colors.white,
                ),
                errorChild: const Icon(
                  Icons.close_sharp,
                  size: 35,
                  color: Colors.white,
                ),
                style: new ButtonStyle(
                    shape: MaterialStateProperty.all(
                      new RoundedRectangleBorder(
                          borderRadius: const BorderRadius.all(
                              const Radius.circular(30))),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all(Get.theme.accentColor),
                    textStyle: MaterialStateProperty.all(const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                    ))),
                onPressed: controller.send,
              ),
            ),
          ],
        ),
      );
}

class _RestaurantWidget extends GetView<_GiveOrderRatingPageController> {
  const _RestaurantWidget();
  @override
  Widget build(BuildContext context) => new Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Restaurant",
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12.0,
            ),
          ),
          new Text(
            controller.order.value!.menuList.first.menu.restaurant.name,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
}

class _OrderItem extends StatelessWidget {
  final OrderMenu orderMenu;
  const _OrderItem({Key? key, required this.orderMenu}) : super(key: key);
  @override
  Widget build(BuildContext context) => new Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          new Text(
            orderMenu.menu.name,
            style: new TextStyle(
              color: Get.theme.primaryColor,
              fontFamily: FontFamily.monetaSans,
              fontSize: 24,
            ),
          ),
          new Text(
            Helper.formatMoney(orderMenu.menu.price.toDouble()),
            style: new TextStyle(
              color: kPriceColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          new RichText(
            text: new TextSpan(
              children: <TextSpan>[
                new TextSpan(
                  text: orderMenu.qty.toString() + " ",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 30,
                  ),
                ),
                new TextSpan(
                  text: S.current.portion,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}

class _GiveOrderRatingPageController extends GetxController {
  final order = new Rxn<Order>();
  final onLoading = new RxBool(true);
  final isError = new RxBool(false);
  double rating = .0;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    new Future.delayed(Duration.zero, loadOrder);
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> loadOrder() async {
    isError.value = false;
    final orderId = Get.parameters["orderId"];
    if (orderId == null) {
      order.value = null;
      onLoading.value = false;
      return;
    }
    try {
      onLoading.value = true;
      order.value = await OrderRepository.instance.findOne(orderId);
    } catch (error, st) {
      ErrorReporter.instance.captureException(error, st);
      isError.value = true;
    } finally {
      onLoading.value = false;
    }
  }

  Future<void> send(final LoadingButtonController controller) async {
    try {
      await controller.loading();
      await RatingRepository.instance.create(
        order: order.value!,
        rating: rating,
      );
      await controller.success();
      await new Future.delayed(const Duration(milliseconds: 500));
      Get.back();
    } catch (error, st) {
      ErrorReporter.instance.captureException(error, st);
      await controller.error();
    }
  }
}

class _NotFoundWidget extends StatelessWidget {
  const _NotFoundWidget();
  @override
  Widget build(BuildContext context) => new Center(
        child: new Text(
          S.current.orderWasNotFound,
        ),
      );
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();
  @override
  Widget build(BuildContext context) => new Center(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            new Text(
              S.current.pleaseWait,
            ),
            const SizedBox(height: 10),
            new Center(
              child: new CircularProgressIndicator(
                valueColor:
                    new AlwaysStoppedAnimation<Color>(Get.theme.primaryColor),
              ),
            ),
          ],
        ),
      );
}

class _ErrorWidget extends StatelessWidget {
  final VoidCallback onRefresh;
  const _ErrorWidget(this.onRefresh);
  @override
  Widget build(BuildContext context) => new Center(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            new Text(
              S.current.errorOccurred,
            ),
            const SizedBox(height: 10),
            new IconButton(
              icon: const Icon(Icons.refresh_sharp),
              color: Get.theme.primaryColor,
              iconSize: 48.0,
              onPressed: onRefresh,
            ),
          ],
        ),
      );
}
