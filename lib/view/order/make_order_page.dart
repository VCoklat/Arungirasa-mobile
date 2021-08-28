import 'dart:io';
import 'dart:typed_data';

import 'package:arungi_rasa/common/config.dart';
import 'package:arungi_rasa/common/error_reporter.dart';
import 'package:arungi_rasa/common/helper.dart';
import 'package:arungi_rasa/common/pick_image_option.dart';
import 'package:arungi_rasa/generated/assets.gen.dart';
import 'package:arungi_rasa/generated/l10n.dart';
import 'package:arungi_rasa/model/cart.dart';
import 'package:arungi_rasa/repository/order_repository.dart';
import 'package:arungi_rasa/repository/payment_repository.dart';
import 'package:arungi_rasa/service/cart_service.dart';
import 'package:arungi_rasa/service/order_service.dart';
import 'package:arungi_rasa/util/image_util.dart';
import 'package:arungi_rasa/widget/saved_address_field.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:document_scanner_flutter/configs/configs.dart';
import 'package:document_scanner_flutter/document_scanner_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_loading_button/gradient_loading_button.dart';
import 'package:octo_image/octo_image.dart';

class _MakeOrderPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<_MakeOrderPageController>(() => new _MakeOrderPageController());
  }
}

class MakeOrderPage extends GetView<_MakeOrderPageController> {
  const MakeOrderPage();
  static _MakeOrderPageBinding binding() => new _MakeOrderPageBinding();
  @override
  Widget build(BuildContext context) => new Scaffold(
        body: new NestedScrollView(
          headerSliverBuilder: (_, __) => [
            new SliverAppBar(
              title: new Text(S.current.order),
            ),
          ],
          body: new Padding(
            padding: const EdgeInsets.all(10.0),
            child: new SingleChildScrollView(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _addressField,
                  _addressDetailField,
                  const SizedBox(height: 10),
                  _itemList,
                  _paymentSummary,
                  const Divider(),
                  _payment,
                  const Divider(),
                  const SizedBox(height: 10),
                  new LoadingButton(
                    child: new Text(S.current.processTransaction),
                    successChild: const Icon(
                      Icons.check_sharp,
                      size: 35,
                      color: Colors.white,
                    ),
                    errorChild: const Icon(
                      Icons.close_sharp,
                      size: 35,
                      color: Colors.white,
                    ),
                    style: new ButtonStyle(
                        shape: MaterialStateProperty.all(
                          new RoundedRectangleBorder(
                              borderRadius: const BorderRadius.all(
                                  const Radius.circular(30))),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all(Get.theme.accentColor),
                        textStyle: MaterialStateProperty.all(const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                        ))),
                    onPressed: controller.createOrder,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Widget get _payment => new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          new Text(
            S.current.payment,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          new Text(
            S.current.uploadPayment,
            style: const TextStyle(
              fontSize: 14.0,
            ),
          ),
          const SizedBox(height: 10),
          new InkWell(
            child: new Obx(
              () => controller.paymentImage.value == null
                  ? Assets.images.proveOfPaymentUpload.image()
                  : Image.memory(controller.paymentImage.value!),
            ),
            onTap: controller.selectImage,
          ),
          const SizedBox(height: 10),
        ],
      );

  Widget get _paymentSummary => new Column(
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

  Widget get _itemList => new Obx(
        () => ListView.separated(
          itemCount: controller.itemList.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (_, final int index) => _CartCard(
            cart: controller.itemList[index].cart,
            note: controller.itemList[index].note,
          ),
        ),
      );

  Widget get _addressDetailField => new TextField(
        decoration: new InputDecoration(
          hintText: S.current.sentAddressDetail,
        ),
        onChanged: (final text) => controller.addressDetail.value = text,
      );

  Widget get _addressField => new SavedAddressField(
        controller: controller.addressFieldController,
        decoration: new InputDecoration(
          labelText: S.current.sentAddress,
        ),
      );
}

class _CartItemNote {
  final Rx<Cart> cart;
  final Rx<String> note;

  _CartItemNote({
    required this.cart,
    required this.note,
  });
}

class _MakeOrderPageController extends GetxController {
  final addressDetail = new RxString("");
  final itemList = RxList<_CartItemNote>();
  final paymentImage = new Rxn<Uint8List>();

  late SavedAddressFieldController addressFieldController;

  double get total => itemList.fold(
      0, (prev, e) => prev + e.cart.value.qty * e.cart.value.price);

  @override
  void onInit() {
    itemList
        .assignAll(CartService.instance.itemList.map((e) => new _CartItemNote(
              cart: new Rx<Cart>(e),
              note: new Rx<String>(""),
            )));
    addressFieldController = new SavedAddressFieldController();
    CartService.instance.addOnRemoveIndexCallback(_onRemove);
    CartService.instance.addOnQtyChangedIndexCallback(_onQtyChanged);
    super.onInit();
  }

  @override
  void onClose() {
    CartService.instance.removeOnRemoveIndexCallback(_onRemove);
    CartService.instance.removeOnQtyChangedIndexCallback(_onQtyChanged);
    super.onClose();
  }

  @override
  void dispose() {
    addressFieldController.dispose();
    super.dispose();
  }

  void _onRemove(final int index) {
    itemList.removeAt(index);
  }

  void _onQtyChanged(final int index) {
    itemList[index].cart.value = CartService.instance.itemList[index];
  }

  Future<void> selectImage() async {
    try {
      final option = await Get.bottomSheet<PickImageOption>(
        new SizedBox(
          width: Get.width,
          child: new Material(
            child: new Padding(
              padding: const EdgeInsets.all(10.0),
              child: new ListView(
                shrinkWrap: true,
                children: <Widget?>[
                  new ListTile(
                    title: new Text("close".tr),
                    leading: const Icon(Icons.close),
                    onTap: () => Get.back(result: PickImageOption.CLOSE),
                  ),
                  new ListTile(
                    title: new Text("camera".tr),
                    leading: const Icon(Icons.camera),
                    onTap: () => Get.back(result: PickImageOption.CAMERA),
                  ),
                  new ListTile(
                    title: new Text("gallery".tr),
                    leading: const Icon(Icons.camera_alt),
                    onTap: () => Get.back(result: PickImageOption.GALLERY),
                  ),
                ]
                    .where((e) => e != null)
                    .cast<Widget>()
                    .toList(growable: false),
              ),
            ),
          ),
        ),
      );
      ScannerFileSource? source;
      switch (option) {
        case PickImageOption.CAMERA:
          source = ScannerFileSource.CAMERA;
          break;
        case PickImageOption.GALLERY:
          source = ScannerFileSource.GALLERY;
          break;
        default:
          break;
      }
      if (source == null) return;
      final scannedDoc = await DocumentScannerFlutter.launch(Get.context!,
          source: source,
          labelsConfig: {
            ScannerLabelsConfig.PICKER_CAMERA_LABEL: "camera".tr,
            ScannerLabelsConfig.PICKER_GALLERY_LABEL: "gallery".tr,
            ScannerLabelsConfig.ANDROID_NEXT_BUTTON_LABEL: "next".tr,
            ScannerLabelsConfig.ANDROID_SAVE_BUTTON_LABEL: "save".tr,
            ScannerLabelsConfig.ANDROID_OK_LABEL: "OK",
            ScannerLabelsConfig.ANDROID_ROTATE_LEFT_LABEL: "left".tr,
            ScannerLabelsConfig.ANDROID_ROTATE_RIGHT_LABEL: "right".tr,
            ScannerLabelsConfig.ANDROID_BMW_LABEL: "blackAndWhiteShort".tr,
            ScannerLabelsConfig.ANDROID_LOADING_MESSAGE: "loading".tr,
            ScannerLabelsConfig.ANDROID_SCANNING_MESSAGE: "scanning".tr,
          });
      if (scannedDoc == null) return;
      Helper.showLoading();
      paymentImage.value = await _compressImage(scannedDoc);
      await Helper.hideLoadingWithSuccess();
    } catch (err, st) {
      ErrorReporter.instance.captureException(err, st);
      Helper.hideLoadingWithError();
    }
  }

  Future<void> createOrder(final LoadingButtonController controller) async {
    bool createOrderSuccess = false;
    try {
      await controller.loading();
      final order = await OrderRepository.instance.create(
        addressId: addressFieldController.item.value!.id,
        addressDetail: addressDetail.value,
        note: itemList.asMap().map((key, value) => new MapEntry(
            value.cart.value.menu.id.toString(), value.note.value)),
      );
      createOrderSuccess = true;
      await PaymentRepository.instance.create(
        orderId: order.id,
        image: paymentImage.value!,
      );
      CartService.instance.clear();
      await OrderService.instance.load();
      await controller.success();
      await new Future.delayed(const Duration(milliseconds: 500));
      Get.back();
    } catch (err, st) {
      ErrorReporter.instance.captureException(err, st);
      controller.error();
      if (createOrderSuccess) {
        CartService.instance.clear();
      }
    }
  }

  Future<Uint8List> _compressImage(final File file) async {
    final imageUtil = new ImageUtil();
    await imageUtil.loadImageFromFile(file);
    return await imageUtil.compress();
  }
}

class _CartCard extends StatelessWidget {
  final Rx<Cart> cart;
  final Rx<String> note;
  const _CartCard({
    Key? key,
    required this.cart,
    required this.note,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) => new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          new LayoutBuilder(
            builder: (_, constraints) => new SizedBox(
              height: constraints.maxWidth * 0.4,
              child: new Row(
                children: [
                  _getImage(constraints.maxWidth * 0.4),
                  const SizedBox(
                    width: 5.0,
                  ),
                  new Expanded(
                    child: new Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _title,
                        _totalText,
                        _stockModifier,
                        _noteWidget,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 5.0,
          ),
          const Divider(),
        ],
      );

  Widget get _noteWidget => new Expanded(
        child: new TextFormField(
          decoration: new InputDecoration(
            labelText: S.current.note,
          ),
          maxLines: 1,
          onChanged: (final text) => note.value = text,
        ),
      );

  Widget get _stockModifier => new Flexible(
        child: new Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            new IconButton(
              icon: const Icon(Icons.remove_sharp),
              padding: EdgeInsets.zero,
              iconSize: 28,
              onPressed: () =>
                  CartService.instance.subtractCart(cart.value.menu),
            ),
            const SizedBox(width: 5),
            new ObxValue<Rx<Cart>>(
              (obs) => new Text(
                obs.value.qty.toString(),
                style: const TextStyle(
                  decoration: TextDecoration.underline,
                ),
              ),
              cart,
            ),
            const SizedBox(width: 5),
            new IconButton(
              icon: const Icon(Icons.add_sharp),
              padding: EdgeInsets.zero,
              iconSize: 28,
              onPressed: () => CartService.instance.addCart(cart.value.menu),
            ),
          ],
        ),
      );

  Widget get _totalText => new ObxValue<Rx<Cart>>(
        (obs) => new Text(
          Helper.formatMoney((obs.value.qty * obs.value.price).toDouble()),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18.0,
            color: kPriceColor,
          ),
        ),
        cart,
      );

  Widget get _title => new Text(
        cart.value.menu.name,
        style: new TextStyle(
          fontWeight: FontWeight.w600,
          color: Get.theme.primaryColor,
          fontSize: 18.0,
          wordSpacing: 2.5,
        ),
      );

  Widget _getImage(final double size) => new SizedBox(
        width: size,
        height: size,
        child: new Material(
          shape: new RoundedRectangleBorder(
              borderRadius:
                  const BorderRadius.all(const Radius.circular(15.0))),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: new OctoImage(
            image:
                CachedNetworkImageProvider(cart.value.menu.imageList.first.url),
            placeholderBuilder: OctoPlaceholder.blurHash(
                cart.value.menu.imageList.first.blurhash),
            errorBuilder:
                OctoError.blurHash(cart.value.menu.imageList.first.blurhash),
            fit: BoxFit.cover,
          ),
        ),
      );
}
