import 'package:arungi_rasa/common/error_reporter.dart';
import 'package:arungi_rasa/common/helper.dart';
import 'package:arungi_rasa/common/mixin_controller_worker.dart';
import 'package:arungi_rasa/generated/l10n.dart';
import 'package:arungi_rasa/model/address.dart';
import 'package:arungi_rasa/model/mapbox.dart';
import 'package:arungi_rasa/repository/mapbox_repository.dart';
import 'package:arungi_rasa/service/address_service.dart';
import 'package:arungi_rasa/widget/address_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_loading_button/gradient_loading_button.dart';

class _AddressCreateFormPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<_AddressCreateFormPageController>(
        () => new _AddressCreateFormPageController());
  }
}

class AddressCreateFormPage extends GetView<_AddressCreateFormPageController> {
  const AddressCreateFormPage();
  static _AddressCreateFormPageBinding binding() =>
      new _AddressCreateFormPageBinding();
  @override
  Widget build(BuildContext context) => new Scaffold(
        body: new NestedScrollView(
          headerSliverBuilder: (_, __) => <Widget>[
            new SliverAppBar(
              title: new Text(
                controller.currentAddress.value == null
                    ? S.current.addAddress
                    : S.current.editAddress,
              ),
              actions: [
                new IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: controller.removeAddress,
                )
              ],
            ),
          ],
          body: new ListView(
            padding: const EdgeInsets.all(20),
            shrinkWrap: true,
            children: [
              new Obx(
                () => new TextField(
                  controller: controller.nameFieldController,
                  decoration: new InputDecoration(
                    labelText:
                        "${S.current.name} ( ${S.current.requiredToFill} )",
                    errorText: controller.nameValidator.value,
                  ),
                  onChanged: (final text) => controller.name.value = text,
                ),
              ),
              const SizedBox(height: 10),
              new AddressField(
                controller: controller.addressFieldController,
                decoration: new InputDecoration(
                  labelText:
                      "${S.current.address} ( ${S.current.requiredToFill} )",
                ),
              ),
              const SizedBox(height: 10),
              new TextField(
                controller: controller.detailFieldController,
                decoration: new InputDecoration(
                  labelText: S.current.detail,
                  prefixIcon: const Icon(Icons.note_sharp),
                ),
                maxLines: null,
                onChanged: (final text) => controller.detail.value = text,
              ),
              const SizedBox(height: 10),
              new TextField(
                controller: controller.contactNameFieldController,
                decoration: new InputDecoration(
                  labelText: S.current.contactName,
                  prefixIcon: const Icon(Icons.person_sharp),
                ),
                onChanged: (final text) => controller.contactName.value = text,
              ),
              const SizedBox(height: 10),
              new Obx(
                () => new TextField(
                  controller: controller.contactPhoneNumberFieldController,
                  decoration: new InputDecoration(
                    labelText: S.current.contactPhoneNumber,
                    prefixIcon: const Icon(Icons.contact_phone_sharp),
                    errorText: controller.contactPhoneNumberValidator.value,
                  ),
                  keyboardType: TextInputType.phone,
                  onChanged: (final text) =>
                      controller.contactPhoneNumber.value = text,
                ),
              ),
              const SizedBox(height: 30),
              new Center(
                child: new SizedBox(
                  width: 250,
                  child: new LoadingButton(
                    child: new Text(
                      controller.currentAddress.value == null
                          ? S.current.addAddress
                          : S.current.editAddress,
                    ),
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
                    onPressed: controller.create,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

class _AddressCreateFormPageController extends GetxController
    with MixinControllerWorker {
  final currentAddress = new Rxn<Address>();

  final name = new RxString("");
  final detail = new RxString("");
  final contactName = new RxString("");
  final contactPhoneNumber = new RxString("");

  final nameValidator = new RxnString();
  final addressValidator = new RxnString();
  final contactPhoneNumberValidator = new RxnString();

  late TextEditingController nameFieldController;
  late AddressFieldController addressFieldController;
  late TextEditingController detailFieldController;
  late TextEditingController contactNameFieldController;
  late TextEditingController contactPhoneNumberFieldController;

  @override
  void onInit() {
    nameFieldController = new TextEditingController();
    addressFieldController = new AddressFieldController();
    detailFieldController = new TextEditingController();
    contactNameFieldController = new TextEditingController();
    contactPhoneNumberFieldController = new TextEditingController();
    super.onInit();
    if (Get.arguments != null && Get.arguments is Address) {
      currentAddress.value = Get.arguments;
    }
  }

  @override
  void dispose() {
    nameFieldController.dispose();
    addressFieldController.dispose();
    detailFieldController.dispose();
    contactNameFieldController.dispose();
    contactPhoneNumberFieldController.dispose();
    super.dispose();
  }

  Future<void> removeAddress() async {
    try {
      Helper.showLoading();
      await AddressService.instance.remove(currentAddress.value!);
      Helper.hideLoadingWithSuccess();
      await new Future.delayed(const Duration(milliseconds: 500));
      Get.back();
    } catch (error, st) {
      ErrorReporter.instance.captureException(error, st);
      Helper.hideLoadingWithError();
    }
  }

  Future<void> create(final LoadingButtonController controller) async {
    try {
      controller.loading();
      final data = new CreateUpdateAddress(
        name: name.value,
        latitude: addressFieldController.item.value!.geometry.lat,
        longitude: addressFieldController.item.value!.geometry.lng,
        detail: detail.value,
        note: "",
        contactName: contactName.value.isEmpty ? null : contactName.value,
        contactNumber:
            contactPhoneNumber.value.isEmpty ? null : contactPhoneNumber.value,
      );
      if (currentAddress.value == null) {
        await AddressService.instance.add(data);
      } else {
        await AddressService.instance.update(currentAddress.value!, data);
      }
      controller.success();
      await new Future.delayed(const Duration(milliseconds: 500));
      Get.back();
    } catch (error, st) {
      controller.error();
      ErrorReporter.instance.captureException(error, st);
    }
  }

  @override
  List<Worker> getWorkers() => <Worker>[
        ever<String>(name, _validateName),
        ever<MapBoxFeature?>(addressFieldController.item, _validateAddress),
        ever<String>(contactPhoneNumber, _validateContactPhoneNumber),
        ever<Address?>(currentAddress, _onCurrentAddressChanged),
      ];

  void _validateName(final String name) =>
      nameValidator.value = name.isEmpty ? S.current.errorNameEmpty : null;

  void _validateAddress(final MapBoxFeature? address) =>
      addressValidator.value =
          address == null ? S.current.errorAddressEmpty : null;

  void _validateContactPhoneNumber(final String phoneNumber) {
    if (phoneNumber.isNotEmpty && !phoneNumber.isPhoneNumber) {
      contactPhoneNumberValidator.value =
          S.current.errorContactPhoneNumberInvalid;
    } else {
      contactPhoneNumberValidator.value = null;
    }
  }

  Future<void> _onCurrentAddressChanged(final Address? address) async {
    if (address == null) return;

    name.value = address.name;
    nameFieldController.text = address.name;

    detail.value = address.detail ?? "";
    detailFieldController.text = address.detail ?? "";

    contactName.value = address.contactName ?? "";
    contactNameFieldController.text = address.contactName ?? "";

    contactPhoneNumber.value = address.contactNumber ?? "";
    contactPhoneNumberFieldController.text = address.contactNumber ?? "";

    final locationResult = await MapBoxRepository.instance.findByLatLng(
      address.latLng.lat,
      address.latLng.lng,
    );
    if (locationResult.features.isEmpty) return;
    addressFieldController.item.value = locationResult.features.first;
  }
}
