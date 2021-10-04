part of 'create_order_page.dart';

class _CreateOrderPageController extends GetxController
    with MixinControllerWorker {
  final addressDetail = RxString("");
  final itemList = RxList<_CartItemNote>();
  final paymentImage = Rxn<Uint8List>();

  final distance = RxDouble(.0);
  final transportFee = RxDouble(.0);
  final appFee = RxDouble(.0);

  late SavedAddressFieldController addressFieldController;

  double get total => itemList.fold(
      0, (prev, e) => prev + e.cart.value.qty * e.cart.value.price);

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
    Future.delayed(Duration.zero, _loadDistanceAndTransportFee);
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

  Future<void> _loadDistanceAndTransportFee([_]) async {
    if (itemList.isEmpty) {
      Future.delayed(const Duration(seconds: 1), Get.back);
      return;
    }
    final address = addressFieldController.value;
    if (address == null) return;
    try {
      Helper.showLoading();
      final ref = itemList.first.cart.value.menu.restaurant.ref;
      distance.value = await MapBoxRepository.instance.getDistance(
        itemList.first.cart.value.menu.restaurant.latLng,
        address.latLng,
      );
      transportFee.value = await RestaurantRepository.instance.transportFee(
        ref: ref,
        distance: distance.value,
      );
      appFee.value =
          itemList.first.cart.value.menu.restaurant.appFee.toDouble();
      Helper.hideLoadingWithSuccess();
    } catch (error, st) {
      ErrorReporter.instance.captureException(error, st);
      await Helper.hideLoadingWithError();
      Future.delayed(const Duration(seconds: 1), Get.back);
    }
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
        transportFee: transportFee.value.toInt(),
        appFee: appFee.value.toInt(),
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

  @override
  List<Worker> getWorkers() => <Worker>[
        ever<Address?>(
            addressFieldController.item, _loadDistanceAndTransportFee),
      ];
}
