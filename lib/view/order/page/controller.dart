part of 'order_page.dart';

class _OrderPageController extends GetxController {
  final order = new Rxn<Order>();
  final onLoading = new RxBool(true);
  final isError = new RxBool(false);
  final paymentImage = new Rxn<Uint8List>();

  late Timer timer;

  double get height {
    final order = this.order.value!;
    switch (order.status) {
      case OrderStatus.unpaid:
        return Get.height + Get.height / 4 - Get.statusBarHeight + 60;
      case OrderStatus.awaitingConfirmation:
      case OrderStatus.onProcess:
        return Get.height;
      case OrderStatus.sent:
      case OrderStatus.arrived:
        return Get.height;
      default:
        return Get.height;
    }
  }

  double get total =>
      order.value?.menuList
          .fold<double>(.0, (prev, e) => prev + (e.menu.price * e.qty)) ??
      .0;

  @override
  void onInit() {
    super.onInit();
    timer = Timer.periodic(
      const Duration(seconds: 30),
      refreshOrder,
    );
  }

  @override
  void onReady() {
    super.onReady();
    new Future.delayed(Duration.zero, loadOrder);
  }

  @override
  void onClose() {
    timer.cancel();
    super.onClose();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> loadOrder() async {
    isError.value = false;
    final orderId = Get.parameters["orderId"];
    if (orderId == null) {
      order.value = null;
      onLoading.value = false;
      return;
    }
    try {
      onLoading.value = true;
      order.value = await OrderRepository.instance.findOne(orderId);
    } catch (error, st) {
      ErrorReporter.instance.captureException(error, st);
      isError.value = true;
    } finally {
      onLoading.value = false;
    }
  }

  Future<void> refreshOrder([_]) async {
    final orderId = order.value == null ? null : order.value!.id;
    if (orderId == null || isClosed) {
      return;
    }
    try {
      order.value = await OrderRepository.instance.findOne(orderId);
    } catch (error, st) {
      ErrorReporter.instance.captureException(error, st);
    }
  }

  Future<void> uploadPayment(final LoadingButtonController controller) async {
    if (paymentImage.value == null) {
      return;
    }
    try {
      await controller.loading();
      await PaymentRepository.instance.create(
        orderId: order.value!.id,
        image: paymentImage.value!,
      );
      await controller.success();
      await new Future.delayed(const Duration(milliseconds: 500));
      new Future.delayed(Duration.zero, loadOrder);
    } catch (err, st) {
      ErrorReporter.instance.captureException(err, st);
      controller.error();
    }
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

  Future<Uint8List> _compressImage(final File file) async {
    final imageUtil = new ImageUtil();
    await imageUtil.loadImageFromFile(file);
    return await imageUtil.compress();
  }
}
