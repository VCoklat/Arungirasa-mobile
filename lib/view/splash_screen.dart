import 'package:arungi_rasa/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreenPage extends StatelessWidget {
  const SplashScreenPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Material(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
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
