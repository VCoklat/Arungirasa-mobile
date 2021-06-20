import 'package:arungi_rasa/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreenPage extends StatelessWidget {
  const SplashScreenPage();
  @override Widget build(BuildContext context) => new Material(
    child: new Center(
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          new Center(
            child: Assets.images.logoWithText.image(
              height: Get.height * 0.3 - 10,
              fit: BoxFit.fitHeight,
            ),
          ),
        ],
      ),
    ),
  );
}