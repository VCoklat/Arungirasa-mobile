part of 'order_page.dart';

class _PaymentSummary extends GetView<_OrderPageController> {
  const _PaymentSummary();
  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.current.paymentSummary,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(S.current.price),
              Expanded(
                  child: Obx(() => Text(
                        Helper.formatMoney(controller.total),
                        textAlign: TextAlign.right,
                      ))),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Text(S.current.transportCost),
              Expanded(
                child: Obx(() => Text(
                      Helper.formatMoney(
                          controller.order.value!.transportFee.toDouble()),
                      textAlign: TextAlign.right,
                    )),
              ),
            ],
          ),
          Row(
            children: [
              Text(S.current.appFee),
              Expanded(
                  child: Obx(() => Text(
                        Helper.formatMoney(
                            controller.order.value!.appFee.toDouble()),
                        textAlign: TextAlign.right,
                      ))),
            ],
          ),
          Row(
            children: [
              Text(S.current.discount),
              Expanded(
                  child: Text(
                Helper.formatMoney(0),
                textAlign: TextAlign.right,
              )),
            ],
          ),
          const Divider(),
          Row(
            children: [
              Text(S.current.totalPayment),
              Expanded(
                  child: Obx(() => Text(
                        Helper.formatMoney(controller.total +
                            controller.transportCost +
                            controller.appCost),
                        textAlign: TextAlign.right,
                      ))),
            ],
          ),
          const Divider(),
          const SizedBox(height: 10),
        ],
      );
}
