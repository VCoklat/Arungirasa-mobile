part of 'order_page.dart';

class _PaymentSummary extends GetView<_OrderPageController> {
  const _PaymentSummary();
  @override
  Widget build(BuildContext context) => new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          new Text(
            S.current.paymentSummary,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          new Row(
            children: [
              new Text(S.current.price),
              new Expanded(
                  child: new Obx(() => new Text(
                        Helper.formatMoney(controller.total),
                        textAlign: TextAlign.right,
                      ))),
            ],
          ),
          const SizedBox(height: 5),
          new Row(
            children: [
              new Text(S.current.transportCost),
              new Expanded(
                  child: new Text(
                Helper.formatMoney(8000),
                textAlign: TextAlign.right,
              )),
            ],
          ),
          new Row(
            children: [
              new Text(S.current.appFee),
              new Expanded(
                  child: new Text(
                Helper.formatMoney(3000),
                textAlign: TextAlign.right,
              )),
            ],
          ),
          new Row(
            children: [
              new Text(S.current.discount),
              new Expanded(
                  child: new Text(
                Helper.formatMoney(0),
                textAlign: TextAlign.right,
              )),
            ],
          ),
          const Divider(),
          new Row(
            children: [
              new Text(S.current.totalPayment),
              new Expanded(
                  child: new Obx(() => new Text(
                        Helper.formatMoney(controller.total + 8000 + 3000),
                        textAlign: TextAlign.right,
                      ))),
            ],
          ),
          const Divider(),
          const SizedBox(height: 10),
        ],
      );
}
