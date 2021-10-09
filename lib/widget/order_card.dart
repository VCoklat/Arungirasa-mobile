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
  Widget build(BuildContext context) => SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-1, 0),
          end: const Offset(0, 0),
        ).animate(animation),
        child: OrderCard(
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
  Widget build(BuildContext context) => Card(
        elevation: 6.0,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${S.current.order} ${order.reference}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                ),
              ),
              const Divider(),
              Row(
                children: [
                  const Icon(Icons.delivery_dining_sharp),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "${S.current.deliverTo} ${order.address.name}",
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 10.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(),
              Text(
                Helper.formatMoney(order.total),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: kPriceColor,
                  fontSize: 12.0,
                ),
              ),
              const Divider(),
              SizedBox(
                height: 50,
                width: Get.width - 60,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: order.menuList.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 5),
                  itemBuilder: (_, final int index) => Chip(
                    label: Text(
                      "${order.menuList[index].menu.name} x ${order.menuList[index].qty}",
                      style: const TextStyle(fontSize: 12.0),
                    ),
                  ),
                ),
              ),
              const Divider(),
              Center(
                  child: Text(
                order.status.toReadable(),
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              )),
            ],
          ),
        ),
      );
}
