part of 'order_page.dart';

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
                  text: "Porsi",
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
