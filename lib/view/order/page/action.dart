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
              return new _GiveRatingButton(
                future: RatingRepository.instance
                    .hasGiveRating(controller.order.value!),
                onPressed: Routes.giveOrderRating(controller.order.value!.id),
              );
            default:
              return const SizedBox();
          }
        },
      );
}

class _GiveRatingButton extends StatelessWidget {
  final Future<bool> future;
  final VoidCallback onPressed;
  const _GiveRatingButton({
    Key? key,
    required this.future,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => new FutureBuilder<bool>(
        future: future,
        builder: (_, snapshot) {
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
                if (snapshot.hasData && snapshot.data!) {
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
