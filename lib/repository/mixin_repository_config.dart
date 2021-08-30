import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin RepositoryConfigMixin on GetConnect {
  @mustCallSuper
  @override
  void onInit() {
    timeout = const Duration(minutes: 1);
    super.onInit();
  }
}
