part of 'order_page.dart';

class _OrderPageController extends GetxController {
  final order = Rxn<Order>();
  final onLoading = RxBool(true);
  final isError = RxBool(false);
  final paymentImage = Rxn<Uint8List>();
  final hasGiveRatingFuture = Rxn<Future<bool>>();
  final rating = Rxn<Rating>();

  late Timer timer;

  double get height {
    final order = this.order.value!;
    switch (order.status) {
      case OrderStatus.unpaid:
        return Get.height + Get.height / 4 - Get.statusBarHeight + 90;
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

  double get transportCost =>
      order.value == null || order.value!.menuList.isEmpty
          ? .0
          : order.value!.menuList.first.menu.restaurant.transportFee.toDouble();

  double get appCost => order.value == null || order.value!.menuList.isEmpty
      ? .0
      : order.value!.menuList.first.menu.restaurant.appFee.toDouble();

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
    Future.delayed(Duration.zero, loadOrder);
  }

  @override
  void onClose() {
    timer.cancel();
    super.onClose();
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
      final order = await OrderRepository.instance.findOne(orderId);
      this.order.value = order;
      if (order.status == OrderStatus.arrived) {
        hasGiveRatingFuture.value =
            RatingRepository.instance.hasGiveRating(this.order.value!);
        try {
          rating.value = await RatingRepository.instance.findOne(order);
        } on HttpNotFoundException {
          rating.value = null;
        } catch (error, st) {
          ErrorReporter.instance.captureException(error, st);
        }
      }
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
      final oldOrder = this.order.value;
      final order = await OrderRepository.instance.findOne(orderId);
      if (order.status == OrderStatus.arrived) {
        if (oldOrder?.status != order.status || rating.value == null) {
          try {
            rating.value = await RatingRepository.instance.findOne(order);
          } on HttpNotFoundException {
            rating.value = null;
          } catch (error, st) {
            ErrorReporter.instance.captureException(error, st);
          }
        }
        hasGiveRatingFuture.value =
            RatingRepository.instance.hasGiveRating(this.order.value!);
      }
      this.order.value = order;
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
      await Future.delayed(const Duration(milliseconds: 500));
      Future.delayed(Duration.zero, loadOrder);
    } catch (err, st) {
      ErrorReporter.instance.captureException(err, st);
      controller.error();
    }
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

  Future<Uint8List> _compressImage(final File file) async {
    final imageUtil = ImageUtil();
    await imageUtil.loadImageFromFile(file);
    return await imageUtil.compress();
  }
}
