part of 'order_page.dart';

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
