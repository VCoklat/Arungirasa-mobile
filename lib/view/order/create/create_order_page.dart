import 'dart:io';
import 'dart:typed_data';

import 'package:arungi_rasa/common/config.dart';
import 'package:arungi_rasa/common/error_reporter.dart';
import 'package:arungi_rasa/common/helper.dart';
import 'package:arungi_rasa/common/mixin_controller_worker.dart';
import 'package:arungi_rasa/common/pick_image_option.dart';
import 'package:arungi_rasa/generated/assets.gen.dart';
import 'package:arungi_rasa/generated/l10n.dart';
import 'package:arungi_rasa/model/address.dart';
import 'package:arungi_rasa/model/cart.dart';
import 'package:arungi_rasa/repository/mapbox_repository.dart';
import 'package:arungi_rasa/repository/order_repository.dart';
import 'package:arungi_rasa/repository/payment_repository.dart';
import 'package:arungi_rasa/repository/restaurant_repository.dart';
import 'package:arungi_rasa/service/cart_service.dart';
import 'package:arungi_rasa/service/order_service.dart';
import 'package:arungi_rasa/util/image_util.dart';
import 'package:arungi_rasa/widget/cart_qty_editor.dart';
import 'package:arungi_rasa/widget/menu_card.dart';
import 'package:arungi_rasa/widget/saved_address_field.dart';
import 'package:document_scanner_flutter/configs/configs.dart';
import 'package:document_scanner_flutter/document_scanner_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_loading_button/gradient_loading_button.dart';

part 'create.button.dart';
part 'controller.dart';
part 'payment.dart';
part 'payment.summary.dart';

class _CreateOrderPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<_CreateOrderPageController>(() => _CreateOrderPageController());
  }
}

class CreateOrderPage extends GetView<_CreateOrderPageController> {
  const CreateOrderPage({Key? key}) : super(key: key);
  static _CreateOrderPageBinding binding() => _CreateOrderPageBinding();
  @override
  Widget build(BuildContext context) => Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (_, __) => [
            SliverAppBar(title: Text(S.current.order)),
          ],
          body: Padding(
            padding: kPagePadding,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _addressField,
                  _addressDetailField,
                  const SizedBox(height: 20),
                  _itemList,
                  const SizedBox(height: 20),
                  const _PaymentSummary(),
                  const SizedBox(height: 20),
                  const _Payment(),
                  const Divider(),
                  const SizedBox(height: 10),
                  const _CreateButton(),
                ],
              ),
            ),
          ),
        ),
      );

  Widget get _itemList => Obx(
        () => ListView.separated(
          itemCount: controller.itemList.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (_, final int index) => MenuCard(
            menu: controller.itemList[index].value.menu,
            note: controller.itemList[index].value.note,
            actions: [
              CardQtyEditor(
                cart: controller.itemList[index],
              ),
            ],
          ),
        ),
      );

  Widget get _addressDetailField => TextField(
        decoration: InputDecoration(hintText: S.current.sentAddressDetail),
        onChanged: (final text) => controller.addressDetail.value = text,
      );

  Widget get _addressField => SavedAddressField(
        controller: controller.addressFieldController,
        decoration: InputDecoration(labelText: S.current.sentAddress),
      );
}
