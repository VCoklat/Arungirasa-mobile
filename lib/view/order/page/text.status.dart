part of 'order_page.dart';

class _OrderTextStatus extends GetView<_OrderPageController> {
  const _OrderTextStatus();
  @override
  Widget build(BuildContext context) => Obx(
        () {
          String text;
          Color color;
          final order = controller.order.value!;
          switch (order.status) {
            case OrderStatus.unpaid:
              text = S.current.orderUnpaid;
              color = Colors.white;
              break;
            case OrderStatus.awaitingConfirmation:
              text = S.current.orderConfirm;
              color = Colors.white;
              break;
            case OrderStatus.onProcess:
              text = S.current.orderOnProcess;
              color = Colors.white;
              break;
            case OrderStatus.sent:
              text = S.current.orderSent;
              color = const Color(0XFF0E3D34);
              break;
            case OrderStatus.arrived:
              text = S.current.orderArrived;
              color = const Color(0XFF0E3D34);
              break;
            default:
              text = S.current.unknown;
              color = Colors.white;
              break;
          }
          return Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 24,
              fontFamily: FontFamily.monetaSans,
            ),
          );
        },
      );
}
