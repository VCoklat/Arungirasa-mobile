import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

mixin MixinControllerWorker on GetxController {
  final _workers = <Worker>[];

  List<Worker> getWorkers();

  @mustCallSuper
  void onInitWorker() => _workers.addAll(getWorkers());

  @mustCallSuper
  @override
  void onInit() {
    onInitWorker();
    super.onInit();
  }

  @mustCallSuper
  @override
  void onClose() {
    for (final worker in _workers) {
      worker.dispose();
    }
    super.onClose();
  }
}
