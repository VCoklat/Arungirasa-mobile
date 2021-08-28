import 'dart:io';
import 'dart:typed_data';

import 'package:arungi_rasa/common/config.dart';
import 'package:arungi_rasa/common/error_reporter.dart';
import 'package:arungi_rasa/common/helper.dart';
import 'package:arungi_rasa/common/pick_image_option.dart';
import 'package:arungi_rasa/generated/assets.gen.dart';
import 'package:arungi_rasa/generated/fonts.gen.dart';
import 'package:arungi_rasa/generated/l10n.dart';
import 'package:arungi_rasa/model/order.dart';
import 'package:arungi_rasa/repository/order_repository.dart';
import 'package:arungi_rasa/repository/payment_repository.dart';
import 'package:arungi_rasa/util/image_util.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:document_scanner_flutter/configs/configs.dart';
import 'package:document_scanner_flutter/document_scanner_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_loading_button/gradient_loading_button.dart';

part 'action.dart';
part 'address.dart';
part 'content.dart';
part 'controller.dart';
part 'error.dart';
part 'image.status.dart';
part 'item.dart';
part 'loading.dart';
part 'not.found.dart';
part 'payment.dart';
part 'payment.summary.dart';
part 'text.status.dart';
part 'widget.dart';

class _OrderPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<_OrderPageController>(() => new _OrderPageController());
  }
}

class OrderPage extends GetView<_OrderPageController> {
  static _OrderPageBinding binding() => new _OrderPageBinding();
  static open(final String id) => Get.toNamed("/order/$id");
  const OrderPage();
  @override
  Widget build(BuildContext context) => new Scaffold(
        body: new NestedScrollView(
          headerSliverBuilder: (_, __) {
            if (controller.order.value == null) {
              return <Widget>[
                new SliverAppBar(
                  elevation: 0.0,
                ),
              ];
            }
            Color color;
            final order = controller.order.value!;
            switch (order.status) {
              case OrderStatus.unpaid:
              case OrderStatus.awaitingConfirmation:
              case OrderStatus.onProcess:
                color = Get.theme.primaryColor;
                break;
              case OrderStatus.sent:
              case OrderStatus.arrived:
                color = const Color(0XFFF7CC0D);
                break;
              default:
                color = Get.theme.primaryColor;
                break;
            }
            return <Widget>[
              new SliverAppBar(
                elevation: 0.0,
                backgroundColor: color,
              ),
            ];
          },
          body: new Obx(
            () {
              if (controller.onLoading.value) {
                return const _LoadingWidget();
              } else if (controller.isError.value) {
                return new _ErrorWidget(controller.loadOrder);
              } else if (controller.order.value == null) {
                return const _NotFoundWidget();
              } else {
                return new SingleChildScrollView(
                  child: const _OrderWidget(),
                );
              }
            },
          ),
        ),
      );
}
