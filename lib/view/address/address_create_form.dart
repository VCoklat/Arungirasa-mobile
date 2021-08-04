import 'package:arungi_rasa/common/error_reporter.dart';
import 'package:arungi_rasa/common/mixin_controller_worker.dart';
import 'package:arungi_rasa/generated/l10n.dart';
import 'package:arungi_rasa/model/address.dart';
import 'package:arungi_rasa/model/mapbox.dart';
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
            new SliverAppBar(title: new Text(S.current.addAddress)),
          ],
          body: new ListView(
            padding: const EdgeInsets.all(20),
            shrinkWrap: true,
            children: [
              new Obx(
                () => new TextField(
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
                decoration: new InputDecoration(
                  labelText: S.current.detail,
                  prefixIcon: const Icon(Icons.note_sharp),
                ),
                maxLines: null,
                onChanged: (final text) => controller.detail.value = text,
              ),
              const SizedBox(height: 10),
              new TextField(
                decoration: new InputDecoration(
                  labelText: S.current.contactName,
                  prefixIcon: const Icon(Icons.person_sharp),
                ),
              ),
              const SizedBox(height: 10),
              new Obx(
                () => new TextField(
                  decoration: new InputDecoration(
                    labelText: S.current.contactPhoneNumber,
                    prefixIcon: const Icon(Icons.contact_phone_sharp),
                    errorText: controller.contactPhoneNumberValidator.value,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              new Center(
                child: new SizedBox(
                  width: 250,
                  child: new LoadingButton(
                    child: new Text(S.current.addAddress),
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
  final name = new RxString("");
  final detail = new RxString("");
  final contactName = new RxString("");
  final contactPhoneNumber = new RxString("");

  final nameValidator = new RxnString();
  final addressValidator = new RxnString();
  final contactPhoneNumberValidator = new RxnString();

  late AddressFieldController addressFieldController;

  @override
  void onInit() {
    addressFieldController = new AddressFieldController();
    super.onInit();
  }

  @override
  void dispose() {
    addressFieldController.dispose();
    super.dispose();
  }

  Future<void> create(final LoadingButtonController controller) async {
    try {
      controller.loading();
      await AddressService.instance.add(new CreateUpdateAddress(
        name: name.value,
        latitude: addressFieldController.item.value!.geometry.lat,
        longitude: addressFieldController.item.value!.geometry.lng,
        detail: detail.value,
        note: "",
        contactName: contactName.value.isEmpty ? null : contactName.value,
        contactNumber:
            contactPhoneNumber.value.isEmpty ? null : contactPhoneNumber.value,
      ));
      controller.success();
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
}
