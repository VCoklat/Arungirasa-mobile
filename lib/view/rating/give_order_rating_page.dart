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
        () => _GiveOrderRatingPageController());
  }
}

class GiveOrderRatingPage extends GetView<_GiveOrderRatingPageController> {
  const GiveOrderRatingPage({Key? key}) : super(key: key);
  static _GiveOrderRatingPageBinding binding() => _GiveOrderRatingPageBinding();
  @override
  Widget build(BuildContext context) => Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (_, __) => <Widget>[
            SliverAppBar(title: Text(S.current.giveRating)),
          ],
          body: Obx(
            () {
              if (controller.onLoading.value) {
                return const _LoadingWidget();
              } else if (controller.isError.value) {
                return _ErrorWidget(controller.loadOrder);
              } else if (controller.order.value == null) {
                return const _NotFoundWidget();
              } else {
                return const SingleChildScrollView(
                  child: _RatingWidget(),
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
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _RestaurantWidget(),
            const Divider(),
            SizedBox(
              height: 100,
              child: Obx(
                () => controller.order.value!.menuList.length == 1
                    ? _OrderItem(
                        orderMenu: controller.order.value!.menuList.first,
                      )
                    : Swiper(
                        itemCount: controller.order.value!.menuList.length,
                        autoplay: true,
                        itemBuilder: (_, final int index) => _OrderItem(
                          orderMenu: controller.order.value!.menuList[index],
                        ),
                      ),
              ),
            ),
            const Divider(),
            const Text(
              "Rating",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12.0,
              ),
            ),
            RatingBar.builder(
              initialRating: controller.rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) => controller.rating = rating,
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: LoadingButton(
                child: Text(S.current.send),
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
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all(Get.theme.primaryColor),
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
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Restaurant",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12.0,
            ),
          ),
          Text(
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
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            orderMenu.menu.name,
            style: TextStyle(
              color: Get.theme.primaryColor,
              fontFamily: FontFamily.monetaSans,
              fontSize: 24,
            ),
          ),
          Text(
            Helper.formatMoney(orderMenu.menu.price.toDouble()),
            style: const TextStyle(
              color: kPriceColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: orderMenu.qty.toString() + " ",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 30,
                  ),
                ),
                TextSpan(
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
  final order = Rxn<Order>();
  final onLoading = RxBool(true);
  final isError = RxBool(false);
  double rating = .0;

  @override
  void onReady() {
    super.onReady();
    Future.delayed(Duration.zero, loadOrder);
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
      await Future.delayed(const Duration(milliseconds: 500));
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
  Widget build(BuildContext context) => Center(
        child: Text(S.current.orderWasNotFound),
      );
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();
  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(S.current.pleaseWait),
            const SizedBox(height: 10),
            Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(Get.theme.primaryColor),
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
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(S.current.errorOccurred),
            const SizedBox(height: 10),
            IconButton(
              icon: const Icon(Icons.refresh_sharp),
              color: Get.theme.primaryColor,
              iconSize: 48.0,
              onPressed: onRefresh,
            ),
          ],
        ),
      );
}
