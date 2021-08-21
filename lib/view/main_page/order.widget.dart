part of 'main_page.dart';

class _OrderList extends GetView<OrderService> {
  const _OrderList();
  @override
  Widget build(BuildContext context) => new Obx(
        () => new ListView.separated(
          itemCount: min(3, controller.onGoingOrder.length),
          shrinkWrap: true,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, final int index) => new InkWell(
            child: new _OrderCard(
              order: controller.onGoingOrder[index],
            ),
            onTap: () => OrderService.instance.itemList
                .removeWhere((e) => e.id == controller.onGoingOrder[index].id),
          ),
        ),
      );
}

class _OrderCard extends StatelessWidget {
  final Order order;
  const _OrderCard({Key? key, required this.order}) : super(key: key);
  @override
  Widget build(BuildContext context) => new Card(
        elevation: 6.0,
        child: new Padding(
          padding: const EdgeInsets.all(10),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              new Text(
                "${S.current.order} ${order.reference}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
              const Divider(),
              new Row(
                children: [
                  const Icon(Icons.delivery_dining_sharp),
                  const SizedBox(width: 5),
                  new Text(
                    "${S.current.deliverTo} ${order.address.name}",
                    style: const TextStyle(
                      fontSize: 14.0,
                    ),
                  ),
                  const SizedBox(width: 5),
                  new Expanded(
                    child: new Align(
                      alignment: Alignment.centerRight,
                      child: new Text(
                        Helper.formatMoney(order.total),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: _kPriceColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(),
              new SizedBox(
                height: 50,
                width: Get.width - 60,
                child: new ListView.separated(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: order.menuList.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 5),
                  itemBuilder: (_, final int index) => new Chip(
                    label: new Text(
                        "${order.menuList[index].menu.name} x ${order.menuList[index].qty}"),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
