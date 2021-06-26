import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

mixin RepositorySslHandlerMixin on GetConnect {
  @mustCallSuper
  @override
  void onInit() {
    super.onInit();
    if ( !kReleaseMode ) allowAutoSignedCert = true;
  }
}