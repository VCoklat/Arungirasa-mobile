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
import 'package:arungi_rasa/repository/restaurant_repository.dart';
import 'package:arungi_rasa/service/cart_service.dart';
import 'package:arungi_rasa/service/order_service.dart';
import 'package:arungi_rasa/service/session_service.dart';
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
    Get.lazyPut<_MakeOrderPageController>(() => _MakeOrderPageController());
  }
}

class MakeOrderPage extends GetView<_MakeOrderPageController> {
  const MakeOrderPage({Key? key}) : super(key: key);
  static _MakeOrderPageBinding binding() => _MakeOrderPageBinding();
  @override
  Widget build(BuildContext context) => Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (_, __) => [
            SliverAppBar(title: Text(S.current.order)),
          ],
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
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
                  LoadingButton(
                    child: Text(S.current.processTransaction),
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
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
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

  Widget get _payment => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            S.current.payment,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            S.current.uploadPayment,
            style: const TextStyle(fontSize: 14.0),
          ),
          const SizedBox(height: 10),
          InkWell(
            child: Obx(
              () => controller.paymentImage.value == null
                  ? Assets.images.proveOfPaymentUpload.image()
                  : Image.memory(controller.paymentImage.value!),
            ),
            onTap: controller.selectImage,
          ),
          const SizedBox(height: 10),
        ],
      );

  Widget get _paymentSummary => Column(
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
                child: Obx(
                  () => Text(
                    Helper.formatMoney(controller.transportCost),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(S.current.appFee),
              Expanded(
                child: Obx(
                  () => Text(
                    Helper.formatMoney(controller.appCost),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
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
                        Helper.formatMoney(controller.total + 8000 + 3000),
                        textAlign: TextAlign.right,
                      ))),
            ],
          ),
          const Divider(),
          const SizedBox(height: 10),
        ],
      );

  Widget get _itemList => Obx(
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

  Widget get _addressDetailField => TextField(
        decoration: InputDecoration(hintText: S.current.sentAddressDetail),
        onChanged: (final text) => controller.addressDetail.value = text,
      );

  Widget get _addressField => SavedAddressField(
        controller: controller.addressFieldController,
        decoration: InputDecoration(labelText: S.current.sentAddress),
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
  final addressDetail = RxString("");
  final itemList = RxList<_CartItemNote>();
  final paymentImage = Rxn<Uint8List>();

  final distance = RxDouble(.0);

  late SavedAddressFieldController addressFieldController;

  double get total => itemList.fold(
      0, (prev, e) => prev + e.cart.value.qty * e.cart.value.price);

  double get transportCost => itemList.isEmpty
      ? .0
      : itemList.first.cart.value.menu.restaurant.transportFee.toDouble();

  double get appCost => itemList.isEmpty
      ? .0
      : itemList.first.cart.value.menu.restaurant.appFee.toDouble();

  @override
  void onInit() {
    itemList.assignAll(CartService.instance.itemList.map((e) => _CartItemNote(
          cart: Rx<Cart>(e),
          note: Rx<String>(""),
        )));
    addressFieldController = SavedAddressFieldController();
    CartService.instance.addOnRemoveIndexCallback(_onRemove);
    CartService.instance.addOnQtyChangedIndexCallback(_onQtyChanged);
    super.onInit();
    Future.delayed(Duration.zero, _loadDistance);
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

  void _loadDistance() {
    if (itemList.isEmpty) return;
    RestaurantRepository.instance.distance(
      ref: itemList.first.cart.value.menu.restaurant.ref,
      latLng: SessionService.instance.location.value,
    );
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
        SizedBox(
          width: Get.width,
          child: Material(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                shrinkWrap: true,
                children: <Widget?>[
                  ListTile(
                    title: Text("close".tr),
                    leading: const Icon(Icons.close),
                    onTap: () => Get.back(result: PickImageOption.close),
                  ),
                  ListTile(
                    title: Text("camera".tr),
                    leading: const Icon(Icons.camera),
                    onTap: () => Get.back(result: PickImageOption.camera),
                  ),
                  ListTile(
                    title: Text("gallery".tr),
                    leading: const Icon(Icons.camera_alt),
                    onTap: () => Get.back(result: PickImageOption.gallery),
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
        case PickImageOption.camera:
          source = ScannerFileSource.CAMERA;
          break;
        case PickImageOption.gallery:
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
        note: itemList.asMap().map((key, value) =>
            MapEntry(value.cart.value.menu.id.toString(), value.note.value)),
      );
      createOrderSuccess = true;
      await PaymentRepository.instance.create(
        orderId: order.id,
        image: paymentImage.value!,
      );
      CartService.instance.clear();
      await OrderService.instance.load();
      await controller.success();
      await Future.delayed(const Duration(milliseconds: 500));
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
    final imageUtil = ImageUtil();
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
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          LayoutBuilder(
            builder: (_, constraints) => SizedBox(
              height: constraints.maxWidth * 0.4,
              child: Row(
                children: [
                  _getImage(constraints.maxWidth * 0.4),
                  const SizedBox(width: 5.0),
                  Expanded(
                    child: Column(
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

  Widget get _noteWidget => Expanded(
        child: TextFormField(
          decoration: InputDecoration(labelText: S.current.note),
          maxLines: 1,
          onChanged: (final text) => note.value = text,
        ),
      );

  Widget get _stockModifier => Flexible(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove_sharp),
              padding: EdgeInsets.zero,
              iconSize: 28,
              onPressed: () =>
                  CartService.instance.subtractCart(cart.value.menu),
            ),
            const SizedBox(width: 5),
            ObxValue<Rx<Cart>>(
              (obs) => Text(
                obs.value.qty.toString(),
                style: const TextStyle(
                  decoration: TextDecoration.underline,
                ),
              ),
              cart,
            ),
            const SizedBox(width: 5),
            IconButton(
              icon: const Icon(Icons.add_sharp),
              padding: EdgeInsets.zero,
              iconSize: 28,
              onPressed: () => CartService.instance.addCart(cart.value.menu),
            ),
          ],
        ),
      );

  Widget get _totalText => ObxValue<Rx<Cart>>(
        (obs) => Text(
          Helper.formatMoney((obs.value.qty * obs.value.price).toDouble()),
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18.0,
            color: kPriceColor,
          ),
        ),
        cart,
      );

  Widget get _title => Text(
        cart.value.menu.name,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Get.theme.primaryColor,
          fontSize: 18.0,
          wordSpacing: 2.5,
        ),
      );

  Widget _getImage(final double size) => SizedBox(
        width: size,
        height: size,
        child: Material(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: OctoImage(
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
