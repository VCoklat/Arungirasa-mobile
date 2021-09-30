import 'package:arungi_rasa/common/config.dart';
import 'package:arungi_rasa/common/error_reporter.dart';
import 'package:arungi_rasa/common/helper.dart';
import 'package:arungi_rasa/common/mixin_controller_worker.dart';
import 'package:arungi_rasa/env/env.dart';
import 'package:arungi_rasa/generated/l10n.dart';
import 'package:arungi_rasa/model/mapbox.dart';
import 'package:arungi_rasa/repository/mapbox_repository.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class AddressField extends StatelessWidget {
  final AddressFieldController controller;
  final ValueChanged<MapBoxFeature?>? onChange;
  final InputDecoration decoration;
  final bool _autoRemove;

  AddressField({
    Key? key,
    final AddressFieldController? controller,
    this.onChange,
    this.decoration = const InputDecoration(),
  })  : controller = controller ?? AddressFieldController(),
        _autoRemove = controller == null,
        super(key: key);

  @override
  Widget build(BuildContext context) => GetBuilder<AddressFieldController>(
        autoRemove: _autoRemove,
        init: controller,
        builder: (final controller) => TextField(
          controller: controller._textEditingController,
          decoration: decoration,
          readOnly: true,
          onTap: () async {
            final result = await Get.to(
              () => const _SearchAddressPage(),
              binding: _SearchAddressPageBinding(),
            );
            if (result == null) return;
            controller.item.value = result;
          },
        ),
      );
}

class AddressFieldController extends GetxController with MixinControllerWorker {
  final item = Rxn<MapBoxFeature>();
  late TextEditingController _textEditingController;
  @override
  void onInit() {
    super.onInit();
    _textEditingController = TextEditingController();
    _updateText(item.value);
  }

  @override
  void onClose() {
    _textEditingController.dispose();
    super.onClose();
  }

  void _updateText(final MapBoxFeature? address) =>
      _textEditingController.text = address?.placeName ?? (address?.text ?? "");

  @override
  List<Worker> getWorkers() => <Worker>[
        ever<MapBoxFeature?>(item, _updateText),
      ];
}

class _SearchAddressPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<_SearchAddressPageController>(
        () => _SearchAddressPageController());
  }
}

class _SearchAddressPage extends GetView<_SearchAddressPageController> {
  const _SearchAddressPage();
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(S.current.searchAddress),
          actions: [
            IconButton(
              icon: const Icon(Icons.map_outlined),
              onPressed: () async {
                final result = await Get.to(
                  () => _MapPinPointPage(),
                  binding: _MapPinPointPageBinding(),
                );
                if (result == null) {
                  return;
                } else {
                  Get.back(result: result);
                }
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: S.current.searchAddress),
                onChanged: (text) => controller.query.value = text,
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Obx(
                  () {
                    if (controller.onLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      if (controller.data.value.features.isEmpty) {
                        return Center(child: Text(S.current.noData));
                      } else {
                        return ListView.separated(
                          shrinkWrap: true,
                          itemCount: controller.data.value.features.length,
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (_, final int index) => _AddressTile(
                            feature: controller.data.value.features[index],
                            onChanged: (feature) => Get.back(result: feature),
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      );
}

class _SearchAddressPageController extends GetxController
    with MixinControllerWorker {
  final onLoading = RxBool(false);
  final query = RxString("");
  final data = Rx<MapBoxFeatureCollection>(MapBoxFeatureCollection.empty());

  @override
  List<Worker> getWorkers() => <Worker>[debounce(query, _loadAddress)];

  Future<void> _loadAddress(final String query) async {
    if (query.isEmpty) {
      data.value = MapBoxFeatureCollection.empty();
      return;
    }
    try {
      onLoading.value = true;
      data.value = await MapBoxRepository.instance.find(query);
    } catch (error, st) {
      ErrorReporter.instance.captureException(error, st);
      Helper.showError();
    } finally {
      onLoading.value = false;
    }
  }
}

class _AddressTile extends StatelessWidget {
  final MapBoxFeature feature;
  final ValueChanged<MapBoxFeature>? onChanged;
  const _AddressTile({
    Key? key,
    required this.feature,
    this.onChanged,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) => ListTile(
        title: Text(feature.text),
        subtitle: Text(feature.placeName),
        onTap: onChanged == null ? null : () => onChanged!(feature),
      );
}

class _MapPinPointPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<_MapPinPointPageController>(() => _MapPinPointPageController());
  }
}

class _MapPinPointPage extends GetView<_MapPinPointPageController> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(S.current.pinPointLocation)),
        body: Obx(
          () => controller.onLoading.value
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                  children: [
                    Column(
                      children: [
                        const SizedBox(height: 10),
                        Center(
                          child: Obx(
                            () => Text(controller.addressText.value),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: Stack(
                            children: [
                              MapboxMap(
                                accessToken: env.mapBoxAccessToken,
                                onMapCreated: controller.onMapCreated,
                                styleString: MapboxStyles.MAPBOX_STREETS,
                                trackCameraPosition: true,
                                compassEnabled: true,
                                myLocationRenderMode: MyLocationRenderMode.GPS,
                                onStyleLoadedCallback: controller.onStyleLoaded,
                                initialCameraPosition: CameraPosition(
                                  target: controller.center.value,
                                  zoom: 14.0,
                                ),
                              ),
                              const Center(
                                child: Icon(
                                  Icons.location_pin,
                                  color: Colors.red,
                                  size: 48.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 10.0,
                      right: 10.0,
                      left: 10.0,
                      child: ElevatedButton(
                        child: const Text("Confirm"),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Get.theme.primaryColor),
                            textStyle: MaterialStateProperty.all(
                                const TextStyle(fontSize: 18.0))),
                        onPressed: controller.confirm,
                      ),
                    ),
                  ],
                ),
        ),
      );
}

class _MapPinPointPageController extends GetxController {
  final onLoading = RxBool(true);
  final center = Rx<LatLng>(const LatLng(kDefaultLatitude, kDefaultLongitude));

  final addressText = "".obs;

  MapboxMapController? mapController;

  void onMapCreated(final MapboxMapController controller) {
    mapController = controller;
  }

  void onStyleLoaded() {
    mapController?.addListener(onCameraPositionChanged);
  }

  Future<void> onCameraPositionChanged() async {
    final placemarks = await geocoding.placemarkFromCoordinates(
      mapController?.cameraPosition?.target.latitude ?? kDefaultLatitude,
      mapController?.cameraPosition?.target.longitude ?? kDefaultLongitude,
    );
    if (placemarks.isEmpty) return;
    addressText.value =
        "${placemarks.first.name == null || placemarks.first.name!.isEmpty ? "" : "${placemarks.first.name}, "}${placemarks.first.street ?? ""}";
  }

  @override
  void onReady() {
    super.onReady();
    Future.delayed(Duration.zero, _getLocation);
  }

  @override
  void dispose() {
    mapController?.removeListener(onCameraPositionChanged);
    mapController?.dispose();
    super.dispose();
  }

  Future<void> _getLocation() async {
    final locator = Location();

    bool serviceEnabled = await locator.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await locator.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permission = await locator.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await locator.requestPermission();
      if (permission != PermissionStatus.granted) {
        return;
      }
    }

    final locationData = await locator.getLocation();
    center.value = LatLng(
      locationData.latitude ?? kDefaultLatitude,
      locationData.longitude ?? kDefaultLongitude,
    );
    onLoading.value = false;
  }

  Future<void> confirm() async {
    try {
      Helper.showLoading();
      final result = await MapBoxRepository.instance.findByLatLng(
        mapController?.cameraPosition?.target.latitude ?? kDefaultLatitude,
        mapController?.cameraPosition?.target.longitude ?? kDefaultLongitude,
      );
      Helper.hideLoadingWithSuccess();
      await Future.delayed(const Duration(milliseconds: 500));
      Get.back(result: result.features.isEmpty ? null : result.features.first);
    } catch (error, st) {
      ErrorReporter.instance.captureException(error, st);
      Helper.hideLoadingWithError();
    }
  }
}
