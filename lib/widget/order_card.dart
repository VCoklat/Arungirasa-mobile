import 'package:arungi_rasa/common/config.dart';
import 'package:arungi_rasa/common/helper.dart';
import 'package:arungi_rasa/generated/l10n.dart';
import 'package:arungi_rasa/model/order.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnimatedOrderCard extends StatelessWidget {
  final Order order;
  final Animation<double> animation;
  final ValueChanged<Order>? onPressed;

  const AnimatedOrderCard({
    Key? key,
    required this.order,
    required this.animation,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => new SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-1, 0),
          end: const Offset(0, 0),
        ).animate(animation),
        child: new OrderCard(
          order: order,
          onPressed: onPressed,
        ),
      );
}

class OrderCard extends StatelessWidget {
  final Order order;
  final ValueChanged<Order>? onPressed;
  const OrderCard({
    Key? key,
    required this.order,
    this.onPressed,
  }) : super(key: key);
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
                          color: kPriceColor,
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
              const Divider(),
              new Center(
                child: new Text(
                  order.status.toReadable(),
                ),
              ),
            ],
          ),
        ),
      );
}
