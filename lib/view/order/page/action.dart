part of 'order_page.dart';

class _OrderAction extends GetView<_OrderPageController> {
  const _OrderAction();
  @override
  Widget build(BuildContext context) => new Obx(
        () {
          final order = controller.order.value!;
          switch (order.status) {
            case OrderStatus.unpaid:
              return new Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: const _OrderPayment(),
              );
            case OrderStatus.arrived:
              return new Center(
                child: new _GiveRatingButton(
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
  Widget build(BuildContext context) => new FutureBuilder<bool>(
        future: future,
        builder: (_, snapshot) {
          print(snapshot.connectionState);
          print(snapshot.data);
          print(future);
          Widget? widget;
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              widget = new Center(
                child: new CircularProgressIndicator(
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(Get.theme.primaryColor),
                ),
              );
              break;
            case ConnectionState.done:
              if (snapshot.hasError) {
                new Future.delayed(
                    Duration.zero,
                    () => ErrorReporter.instance
                        .captureException(snapshot.error));
              } else {
                if (snapshot.hasData && !snapshot.data!) {
                  widget = new ElevatedButton(
                    child: new Text(S.current.giveRating),
                    style: new ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Get.theme.primaryColor),
                      textStyle: MaterialStateProperty.all(const TextStyle(
                        color: Colors.white,
                      )),
                    ),
                    onPressed: onPressed,
                  );
                } else if (snapshot.hasData && snapshot.data!) {
                  widget = new RatingBarIndicator(
                    rating: rating?.rating ?? .0,
                    direction: Axis.horizontal,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
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
            return new Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: widget,
            );
          }
        },
      );
}
