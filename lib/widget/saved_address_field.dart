import 'dart:async';

import 'package:arungi_rasa/common/error_reporter.dart';
import 'package:arungi_rasa/common/mixin_controller_worker.dart';
import 'package:arungi_rasa/model/address.dart';
import 'package:arungi_rasa/repository/address_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:select_dialog/select_dialog.dart';

class SavedAddressField extends StatelessWidget {
  final SavedAddressFieldController controller;
  final String? label;
  final ValueChanged<Address?>? onChange;
  final InputDecoration decoration;
  final InputDecoration? searchBoxDecoration;
  final bool showSearchBox, showSelectedItem;
  final bool _autoRemove;

  SavedAddressField({
    Key? key,
    SavedAddressFieldController? controller,
    this.onChange,
    this.label,
    this.decoration = const InputDecoration(),
    this.searchBoxDecoration,
    this.showSearchBox = true,
    this.showSelectedItem = true,
  })  : controller = controller ?? new SavedAddressFieldController(),
        _autoRemove = controller == null,
        super(key: key);

  @override
  Widget build(BuildContext context) =>
      new GetBuilder<SavedAddressFieldController>(
        autoRemove: _autoRemove,
        init: controller,
        builder: (final controller) => new TextField(
          controller: controller._textEditingController,
          decoration: decoration.copyWith(
            labelStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 14.0,
              fontWeight: FontWeight.normal,
            ),
            suffix: new SizedBox(
              height: 25.0,
              width: 50.0,
              child: new MaterialButton(
                padding: const EdgeInsets.all(7.0),
                shape: new RoundedRectangleBorder(
                  borderRadius:
                      const BorderRadius.all(const Radius.circular(15.0)),
                  side: new BorderSide(color: Get.theme.primaryColor),
                ),
                child: new FittedBox(
                  child: new Text("Ganti"),
                ),
                textColor: Get.theme.primaryColor,
                onPressed: controller.onLoading.value
                    ? null
                    : () async => await SelectDialog.showModal<Address?>(
                          context,
                          label: label,
                          selectedValue: controller.item.value,
                          showSearchBox: showSearchBox,
                          searchBoxDecoration: searchBoxDecoration,
                          items: controller.itemList,
                          itemBuilder: (_, item, isSelected) => new ListTile(
                            title: new Text(item!.name),
                            selected: isSelected,
                          ),
                          onChange: (final item) {
                            controller.item.value = item;
                            controller.update();
                            if (onChange != null) onChange!(item);
                          },
                        ),
              ),
            ),
          ),
          readOnly: true,
          enabled: !controller.onLoading.value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
          /*
          onTap: controller.onLoading.value
              ? null
              : () async => await SelectDialog.showModal<Address?>(
                    context,
                    label: label,
                    selectedValue: controller.item.value,
                    showSearchBox: showSearchBox,
                    searchBoxDecoration: searchBoxDecoration,
                    items: controller.itemList,
                    itemBuilder: (_, item, isSelected) => new ListTile(
                      title: new Text(item!.name),
                      selected: isSelected,
                    ),
                    onChange: (final item) {
                      controller.item.value = item;
                      controller.update();
                      if (onChange != null) onChange!(item);
                    },
                  ),
                  */
        ),
      );
}

class SavedAddressFieldController extends GetxController
    with MixinControllerWorker {
  final itemList = new RxList<Address>();
  final item = new Rxn<Address>();
  final onLoading = new RxBool(false);
  late TextEditingController _textEditingController;
  bool get isLoaded => itemList.isNotEmpty;
  Future<void>? get onLoadingFuture => _onLoading;
  Future<void>? _onLoading;

  Address? get value => item.value;

  @override
  void onInit() {
    super.onInit();
    _textEditingController = new TextEditingController();
  }

  @override
  void onReady() {
    super.onReady();
    new Future.delayed(Duration.zero, loadPoldaList);
  }

  Future<void> loadPoldaList() async {
    final completer = new Completer<void>();
    _onLoading = completer.future;
    try {
      onLoading.value = true;
      itemList.assignAll(await AddressRepository.instance.find());
      item.value = itemList.first;
    } catch (error, st) {
      ErrorReporter.instance.captureException(error, st);
    } finally {
      onLoading.value = false;
      completer.complete();
      _onLoading = null;
    }
  }

  @override
  void onClose() {
    _textEditingController.dispose();
    super.onClose();
  }

  void _updateText(final Address? address) =>
      _textEditingController.text = address == null ? "" : address.name;

  @override
  List<Worker> getWorkers() => <Worker>[
        ever<Address?>(item, _updateText),
      ];
}
