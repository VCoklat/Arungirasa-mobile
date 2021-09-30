part of 'order_page.dart';

class _OrderAction extends GetView<_OrderPageController> {
  const _OrderAction();
  @override
  Widget build(BuildContext context) => Obx(
        () {
          final order = controller.order.value!;
          switch (order.status) {
            case OrderStatus.unpaid:
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: _OrderPayment(),
              );
            case OrderStatus.arrived:
              return Center(
                child: _GiveRatingButton(
                  future: controller.hasGiveRatingFuture.value,
                  rating: controller.rating.value,
                  onPressed: () async {
                    await Routes.giveOrderRating(controller.order.value!.id);
                    await controller.refreshOrder();
                    controller.hasGiveRatingFuture.value = RatingRepository
                        .instance
                        .hasGiveRating(controller.order.value!);
                  },
                ),
              );
            default:
              return const SizedBox();
          }
        },
      );
}

class _GiveRatingButton extends StatelessWidget {
  final Rating? rating;
  final Future<bool>? future;
  final VoidCallback onPressed;
  const _GiveRatingButton({
    Key? key,
    required this.rating,
    required this.future,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => FutureBuilder<bool>(
        future: future,
        builder: (_, snapshot) {
          Widget? widget;
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              widget = Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(Get.theme.primaryColor),
                ),
              );
              break;
            case ConnectionState.done:
              if (snapshot.hasError) {
                Future.delayed(
                    Duration.zero,
                    () => ErrorReporter.instance
                        .captureException(snapshot.error));
              } else {
                if (snapshot.hasData && !snapshot.data!) {
                  widget = ElevatedButton(
                    child: Text(S.current.giveRating),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Get.theme.primaryColor),
                      textStyle: MaterialStateProperty.all(const TextStyle(
                        color: Colors.white,
                      )),
                    ),
                    onPressed: onPressed,
                  );
                } else if (snapshot.hasData && snapshot.data!) {
                  widget = RatingBarIndicator(
                    rating: rating?.rating ?? .0,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                  );
                }
              }
              break;
          }
          if (widget == null) {
            return const SizedBox();
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: widget,
            );
          }
        },
      );
}
