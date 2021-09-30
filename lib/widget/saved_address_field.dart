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
  })  : controller = controller ?? SavedAddressFieldController(),
        _autoRemove = controller == null,
        super(key: key);

  @override
  Widget build(BuildContext context) => GetBuilder<SavedAddressFieldController>(
        autoRemove: _autoRemove,
        init: controller,
        builder: (final controller) => TextField(
          controller: controller._textEditingController,
          decoration: decoration.copyWith(
            labelStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 14.0,
              fontWeight: FontWeight.normal,
            ),
            suffix: SizedBox(
              height: 25.0,
              width: 50.0,
              child: MaterialButton(
                padding: const EdgeInsets.all(7.0),
                shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                  side: BorderSide(color: Get.theme.primaryColor),
                ),
                child: const FittedBox(child: Text("Ganti")),
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
                          onFind: (final text) => Future.value(text.isEmpty
                              ? controller.itemList
                              : controller.itemList
                                  .where((p) => p.name
                                      .toLowerCase()
                                      .contains(text.toLowerCase()))
                                  .toList(growable: false)),
                          itemBuilder: (_, item, isSelected) => ListTile(
                            title: Text(item!.name),
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
        ),
      );
}

class SavedAddressFieldController extends GetxController
    with MixinControllerWorker {
  final itemList = RxList<Address>();
  final item = Rxn<Address>();
  final onLoading = RxBool(false);
  late TextEditingController _textEditingController;
  bool get isLoaded => itemList.isNotEmpty;
  Future<void>? get onLoadingFuture => _onLoading;
  Future<void>? _onLoading;

  Address? get value => item.value;

  @override
  void onInit() {
    super.onInit();
    _textEditingController = TextEditingController();
  }

  @override
  void onReady() {
    super.onReady();
    Future.delayed(Duration.zero, loadPoldaList);
  }

  Future<void> loadPoldaList() async {
    final completer = Completer<void>();
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
