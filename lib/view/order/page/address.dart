part of 'order_page.dart';

class _OrderAddress extends GetView<_OrderPageController> {
  const _OrderAddress();
  @override
  Widget build(BuildContext context) => new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          new Text(
            S.current.sentAddress,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14.0,
            ),
          ),
          const SizedBox(height: 5),
          new Text(
            controller.order.value!.address.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
        ],
      );
}
