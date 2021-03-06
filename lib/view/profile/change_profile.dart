import 'dart:typed_data';

import 'package:arungi_rasa/common/error_reporter.dart';
import 'package:arungi_rasa/common/helper.dart';
import 'package:arungi_rasa/common/mixin_controller_worker.dart';
import 'package:arungi_rasa/generated/assets.gen.dart';
import 'package:arungi_rasa/generated/l10n.dart';
import 'package:arungi_rasa/service/session_service.dart';
import 'package:arungi_rasa/util/image_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';

class _ChangeProfilePageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<_ChangeProfilePageController>(
        () => _ChangeProfilePageController());
  }
}

class ChangeProfilePage extends GetView<_ChangeProfilePageController> {
  const ChangeProfilePage({Key? key}) : super(key: key);
  static _ChangeProfilePageBinding binding() => _ChangeProfilePageBinding();
  @override
  Widget build(BuildContext context) => Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (_, __) => <Widget>[
            SliverAppBar(title: Text(S.current.editProfile)),
          ],
          body: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(10),
            children: [
              photoProfile,
              const SizedBox(height: 10),
              Obx(
                () => TextFormField(
                  initialValue: controller.user.displayName,
                  decoration: InputDecoration(
                    labelText: S.current.fullName,
                    prefixIcon: const Icon(Icons.account_circle_sharp),
                    errorText: controller.fullNameValidator.value,
                  ),
                  onChanged: (text) => controller.fullName.value = text,
                  onEditingComplete: controller.updateFullName,
                ),
              ),
              const SizedBox(height: 10),
              Obx(
                () => TextFormField(
                  initialValue: controller.user.email,
                  decoration: InputDecoration(
                    labelText: S.current.email,
                    prefixIcon: const Icon(Icons.mail_sharp),
                    errorText: controller.emailValidator.value,
                  ),
                  onChanged: (text) => controller.email.value = text,
                  onEditingComplete: controller.updateEmail,
                ),
              ),
            ],
          ),
        ),
      );

  Widget get photoProfile => Center(
        child: Stack(
          children: [
            Container(
              width: 155,
              height: 155,
              decoration: BoxDecoration(
                color: Get.theme.primaryColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(90.0),
                  child: Obx(
                    () {
                      final photoProfile = controller.photoProfile.value;
                      final photoUrl = controller.user.photoURL;
                      if (photoProfile != null) {
                        return Image.memory(
                          controller.photoProfile.value!,
                          width: 150,
                          height: 150,
                        );
                      } else if (photoUrl != null) {
                        return CachedNetworkImage(
                          imageUrl: photoUrl,
                          width: 150,
                          height: 150,
                        );
                      } else {
                        return Assets.images.placeholderProfile.image(
                          width: 150,
                          height: 150,
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              left: 107.5,
              top: 107.5,
              child: IconButton(
                icon: Assets.images.takePhoto.image(width: 45, height: 45),
                onPressed: controller.pickImage,
              ),
            ),
          ],
        ),
      );
}

class _ChangeProfilePageController extends GetxController
    with MixinControllerWorker {
  final email = RxString("");
  final phoneNumber = RxString("");
  final fullName = RxString("");
  final photoProfile = Rxn<Uint8List>();
  late User user;

  final emailValidator = RxnString();
  final phoneNumberValidator = RxnString();
  final fullNameValidator = RxnString();

  @override
  void onInit() {
    user = FirebaseAuth.instance.currentUser!;
    super.onInit();
  }

  Future<void> updateFullName() async {
    _validateFullName(fullName.value);
    if (fullNameValidator.value != null) return;
    try {
      Helper.showLoading();
      await user.updateDisplayName(fullName.value);
      await Helper.hideLoadingWithSuccess();
      user = FirebaseAuth.instance.currentUser!;
      SessionService.instance.refresh();
    } catch (error, st) {
      ErrorReporter.instance.captureException(error, st);
      Helper.hideLoadingWithError();
    }
  }

  Future<void> updateEmail() async {
    _validateEmail(email.value);
    if (emailValidator.value != null) {
      return;
    }
    try {
      Helper.showLoading();
      await user.updateEmail(email.value);
      await user.sendEmailVerification();
      await Helper.hideLoadingWithSuccess();
      user = FirebaseAuth.instance.currentUser!;
      SessionService.instance.refresh();
    } catch (error, st) {
      ErrorReporter.instance.captureException(error, st);
      Helper.hideLoadingWithError();
    }
  }

  @override
  List<Worker> getWorkers() => <Worker>[
        ever<String>(fullName, _validateFullName),
        ever<String>(email, _validateEmail),
        ever<String>(phoneNumber, _validatePhoneNumber),
      ];

  void _validateFullName(final String fullName) => fullNameValidator.value =
      fullName.isEmpty ? S.current.errorFullNameEmpty : null;

  void _validateEmail(final String email) {
    if (email.isEmpty) {
      emailValidator.value = S.current.errorEmailEmpty;
    } else if (!email.isEmail) {
      emailValidator.value = S.current.errorEmailInvalid;
    } else {
      emailValidator.value = null;
    }
  }

  void _validatePhoneNumber(final String phoneNumber) {
    if (phoneNumber.isEmpty) {
      phoneNumberValidator.value = S.current.errorPhoneNumberEmpty;
    } else if (!phoneNumber.isPhoneNumber) {
      phoneNumberValidator.value = S.current.errorPhoneNumberInvalid;
    } else {
      phoneNumberValidator.value = null;
    }
  }

  Future<void> pickImage() async {
    final imageUtil = ImageUtil();
    try {
      await imageUtil.pickImage();
      Helper.showLoading();
      await imageUtil.crop(
        cropStyle: CropStyle.circle,
        aspectRatioPresets: [CropAspectRatioPreset.square],
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: S.current.editProfile,
          toolbarColor: Get.theme.primaryColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true,
        ),
        iosUiSettings: const IOSUiSettings(minimumAspectRatio: 1.0),
      );
      final photoUrl = await imageUtil.uploadToFirebase();
      await user.updatePhotoURL(photoUrl);
      user = FirebaseAuth.instance.currentUser!;
      photoProfile.value = null;
      SessionService.instance.refresh();
      Helper.hideLoadingWithSuccess();
    } catch (error, st) {
      ErrorReporter.instance.captureException(error, st);
      Helper.hideLoadingWithError();
    }
  }
}
