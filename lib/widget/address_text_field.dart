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
  })  : controller = controller ?? new AddressFieldController(),
        _autoRemove = controller == null,
        super(key: key);

  @override
  Widget build(BuildContext context) => new GetBuilder<AddressFieldController>(
        autoRemove: _autoRemove,
        init: controller,
        builder: (final controller) => new TextField(
          controller: controller._textEditingController,
          decoration: decoration,
          readOnly: true,
          onTap: () async {
            final result = await Get.to(
              () => new _SearchAddressPage(),
              binding: new _SearchAddressPageBinding(),
            );
            if (result == null) return;
            controller.item.value = result;
          },
        ),
      );
}

class AddressFieldController extends GetxController with MixinControllerWorker {
  final item = new Rxn<MapBoxFeature>();
  late TextEditingController _textEditingController;
  @override
  void onInit() {
    super.onInit();
    _textEditingController = new TextEditingController();
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
        () => new _SearchAddressPageController());
  }
}

class _SearchAddressPage extends GetView<_SearchAddressPageController> {
  const _SearchAddressPage();
  @override
  Widget build(BuildContext context) => new Scaffold(
        appBar: new AppBar(
          title: new Text(S.current.searchAddress),
          actions: [
            new IconButton(
              icon: const Icon(Icons.map_outlined),
              onPressed: () async {
                final result = await Get.to(
                  () => _MapPinPointPage(),
                  binding: new _MapPinPointPageBinding(),
                );
                if (result == null)
                  return;
                else
                  Get.back(result: result);
              },
            ),
          ],
        ),
        body: new Padding(
          padding: const EdgeInsets.all(10.0),
          child: new Column(
            children: [
              new TextField(
                decoration: new InputDecoration(
                  labelText: S.current.searchAddress,
                ),
                onChanged: (text) => controller.query.value = text,
              ),
              const SizedBox(height: 10),
              new Expanded(
                child: new Obx(
                  () {
                    if (controller.onLoading.value) {
                      return new Center(
                        child: new CircularProgressIndicator(),
                      );
                    } else {
                      if (controller.data.value.features.isEmpty) {
                        return new Center(
                          child: new Text(
                            S.current.noData,
                          ),
                        );
                      } else {
                        return new ListView.separated(
                          shrinkWrap: true,
                          itemCount: controller.data.value.features.length,
                          separatorBuilder: (_, __) => new Divider(),
                          itemBuilder: (_, final int index) => new _AddressTile(
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
  final onLoading = new RxBool(false);
  final query = new RxString("");
  final data = new Rx<MapBoxFeatureCollection>(MapBoxFeatureCollection.empty());

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
  Widget build(BuildContext context) => new ListTile(
        title: new Text(
          feature.text,
        ),
        subtitle: new Text(
          feature.placeName,
        ),
        onTap: onChanged == null ? null : () => onChanged!(feature),
      );
}

class _MapPinPointPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<_MapPinPointPageController>(
        () => new _MapPinPointPageController());
  }
}

class _MapPinPointPage extends GetView<_MapPinPointPageController> {
  @override
  Widget build(BuildContext context) => new Scaffold(
        appBar: new AppBar(
          title: new Text(S.current.pinPointLocation),
        ),
        body: new Obx(
          () => controller.onLoading.value
              ? new Center(
                  child: new CircularProgressIndicator(),
                )
              : new Stack(
                  children: [
                    new Column(
                      children: [
                        const SizedBox(height: 10),
                        new Center(
                          child: new Obx(
                            () => new Text(
                              controller.addressText.value,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        new Expanded(
                          child: new Stack(
                            children: [
                              new MapboxMap(
                                accessToken: env.mapBoxAccessToken,
                                onMapCreated: controller.onMapCreated,
                                styleString: MapboxStyles.MAPBOX_STREETS,
                                trackCameraPosition: true,
                                compassEnabled: true,
                                myLocationRenderMode: MyLocationRenderMode.GPS,
                                onStyleLoadedCallback: controller.onStyleLoaded,
                                initialCameraPosition: new CameraPosition(
                                  target: controller.center.value,
                                  zoom: 14.0,
                                ),
                              ),
                              new Center(
                                child: const Icon(
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
                    new Positioned(
                      bottom: 10.0,
                      right: 10.0,
                      left: 10.0,
                      child: new ElevatedButton(
                        child: new Text("Confirm"),
                        style: new ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Get.theme.primaryColor),
                            textStyle: MaterialStateProperty.all(new TextStyle(
                              fontSize: 18.0,
                            ))),
                        onPressed: controller.confirm,
                      ),
                    ),
                  ],
                ),
        ),
      );
}

class _MapPinPointPageController extends GetxController {
  final onLoading = new RxBool(true);
  final center =
      new Rx<LatLng>(new LatLng(DEFAULT_LATITUDE, DEFAULT_LONGITUDE));

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
      mapController?.cameraPosition?.target.latitude ?? DEFAULT_LATITUDE,
      mapController?.cameraPosition?.target.longitude ?? DEFAULT_LONGITUDE,
    );
    if (placemarks.isEmpty) return;
    addressText.value =
        "${placemarks.first.name == null || placemarks.first.name!.isEmpty ? "" : "${placemarks.first.name}, "}${placemarks.first.street ?? ""}";
  }

  @override
  void onReady() {
    super.onReady();
    new Future.delayed(Duration.zero, _getLocation);
  }

  @override
  void dispose() {
    mapController?.removeListener(onCameraPositionChanged);
    mapController?.dispose();
    super.dispose();
  }

  Future<void> _getLocation() async {
    final locator = new Location();

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
    center.value = new LatLng(
      locationData.latitude ?? DEFAULT_LATITUDE,
      locationData.longitude ?? DEFAULT_LONGITUDE,
    );
    onLoading.value = false;
  }

  Future<void> confirm() async {
    try {
      Helper.showLoading();
      final result = await MapBoxRepository.instance.findByLatLng(
        mapController?.cameraPosition?.target.latitude ?? DEFAULT_LATITUDE,
        mapController?.cameraPosition?.target.longitude ?? DEFAULT_LONGITUDE,
      );
      Helper.hideLoadingWithSuccess();
      await new Future.delayed(const Duration(milliseconds: 500));
      Get.back(result: result.features.isEmpty ? null : result.features.first);
    } catch (error, st) {
      ErrorReporter.instance.captureException(error, st);
      Helper.hideLoadingWithError();
    }
  }
}
