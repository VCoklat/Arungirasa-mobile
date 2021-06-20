import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<_MainPageController>( () => new _MainPageController() );
  }
}

class MainPage extends GetView<_MainPageController> {
  const MainPage();
  @override Widget build(BuildContext context) => new Scaffold(
    body: new Center(
      child: new Text(
        "HOME PAGE",
      ),
    ),
  );
}

class _MainPageController extends GetxController {

}