import 'package:arungi_rasa/common/error_reporter.dart';
import 'package:arungi_rasa/common/helper.dart';
import 'package:arungi_rasa/common/mixin_controller_worker.dart';
import 'package:arungi_rasa/generated/l10n.dart';
import 'package:arungi_rasa/service/session_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_loading_button/gradient_loading_button.dart';

class _ChangePasswordPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<_ChangePasswordPageController>(
        () => _ChangePasswordPageController());
  }
}

class ChangePasswordPage extends GetView<_ChangePasswordPageController> {
  const ChangePasswordPage({Key? key}) : super(key: key);
  static _ChangePasswordPageBinding binding() => _ChangePasswordPageBinding();
  @override
  Widget build(BuildContext context) => Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (_, __) => <Widget>[
            SliverAppBar(title: Text(S.current.changePassword)),
          ],
          body: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(10),
            children: [
              const SizedBox(height: 10),
              TextFormField(
                initialValue: controller.user.email,
                decoration: InputDecoration(
                  labelText: S.current.email,
                  prefixIcon: const Icon(Icons.mail_sharp),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 10),
              const _OldPassword(),
              const SizedBox(height: 10),
              const _NewPassword(),
              const SizedBox(height: 10),
              const _ConfirmPassword(),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: LoadingButton(
                  child: Text(S.current.changePassword),
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
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all(Get.theme.primaryColor),
                      textStyle: MaterialStateProperty.all(const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      ))),
                  onPressed: controller.changePassword,
                ),
              ),
              const SizedBox(height: 10.0),
            ],
          ),
        ),
      );
}

class _ChangePasswordPageController extends GetxController
    with MixinControllerWorker {
  final oldPassword = RxString("");
  final newPassword = RxString("");
  final confirmPassword = RxString("");
  late User user;

  final oldPasswordValidator = RxnString();
  final newPasswordValidator = RxnString();
  final confirmPasswordValidator = RxnString();

  final obscureOldPassword = RxBool(true);
  final obscureNewPassword = RxBool(true);
  final obscureConfirmPassword = RxBool(true);

  @override
  void onInit() {
    user = FirebaseAuth.instance.currentUser!;
    super.onInit();
  }

  bool get hasError =>
      oldPasswordValidator.value != null ||
      newPasswordValidator.value != null ||
      confirmPasswordValidator.value != null;

  Future<void> changePassword(final LoadingButtonController controller) async {
    _validateOldPassword(oldPassword.value);
    _validateNewPassword(newPassword.value);
    _validateConfirmPassword(confirmPassword.value);
    if (hasError) return;
    try {
      await controller.loading();
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword.value,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword.value);
      user = FirebaseAuth.instance.currentUser!;
      SessionService.instance.refresh();
      controller.success();
    } on FirebaseAuthException catch (error, st) {
      controller.error();
      if (error.code == "wrong-password") {
        oldPasswordValidator.value = S.current.errorPasswordInvalid;
      } else if (error.code == "weak-password") {
        newPasswordValidator.value = S.current.errorNewPasswordTooWeak;
      } else if (error.code == "too-many-requests") {
        Helper.showError(text: S.current.tooManyRequests);
      } else {
        ErrorReporter.instance.captureException(error, st);
        Helper.showError(text: S.current.errorOccurred);
      }
    } catch (error, st) {
      ErrorReporter.instance.captureException(error, st);
      controller.error();
    }
  }

  @override
  List<Worker> getWorkers() => <Worker>[
        ever<String>(oldPassword, _validateOldPassword),
        ever<String>(newPassword, _validateNewPassword),
        ever<String>(confirmPassword, _validateConfirmPassword),
      ];

  void _validateOldPassword(final String password) {
    if (password.isEmpty) {
      oldPasswordValidator.value = S.current.errorOldPasswordEmpty;
    } else {
      oldPasswordValidator.value = null;
    }
  }

  void _validateNewPassword(final String password) {
    if (password.isEmpty) {
      newPasswordValidator.value = S.current.errorNewPasswordEmpty;
    } else if (password != confirmPassword.value) {
      confirmPasswordValidator.value = null;
      confirmPasswordValidator.value = S.current.errorConfirmPasswordNotEqual;
    } else {
      newPasswordValidator.value = null;
    }
  }

  void _validateConfirmPassword(final String password) {
    if (password.isEmpty) {
      confirmPasswordValidator.value = S.current.errorConfirmPasswordEmpty;
    } else if (password != newPassword.value) {
      confirmPasswordValidator.value = S.current.errorConfirmPasswordNotEqual;
    } else {
      confirmPasswordValidator.value = null;
    }
  }
}

class _OldPassword extends GetView<_ChangePasswordPageController> {
  const _OldPassword();

  @override
  Widget build(BuildContext context) => Obx(
        () => TextField(
          decoration: InputDecoration(
            labelText: S.current.oldPassword,
            prefixIcon: Icon(
              Icons.lock_open_outlined,
              color: Get.theme.primaryColor,
            ),
            errorText: controller.oldPasswordValidator.value,
            suffixIcon: InkWell(
              child: Obx(() => controller.obscureOldPassword.value
                  ? Icon(
                      Icons.visibility,
                      color: Get.theme.primaryColor,
                    )
                  : Icon(
                      Icons.visibility_off,
                      color: Get.theme.primaryColor,
                    )),
              onTap: controller.obscureOldPassword.toggle,
            ),
          ),
          obscureText: controller.obscureOldPassword.value,
          onChanged: (final text) => controller.oldPassword.value = text,
        ),
      );
}

class _NewPassword extends GetView<_ChangePasswordPageController> {
  const _NewPassword();

  @override
  Widget build(BuildContext context) => Obx(
        () => TextField(
          decoration: InputDecoration(
            labelText: S.current.newPassword,
            prefixIcon: Icon(
              Icons.lock_open_outlined,
              color: Get.theme.primaryColor,
            ),
            errorText: controller.newPasswordValidator.value,
            suffixIcon: InkWell(
              child: Obx(() => controller.obscureNewPassword.value
                  ? Icon(
                      Icons.visibility,
                      color: Get.theme.primaryColor,
                    )
                  : Icon(
                      Icons.visibility_off,
                      color: Get.theme.primaryColor,
                    )),
              onTap: controller.obscureNewPassword.toggle,
            ),
          ),
          obscureText: controller.obscureNewPassword.value,
          onChanged: (final text) => controller.newPassword.value = text,
        ),
      );
}

class _ConfirmPassword extends GetView<_ChangePasswordPageController> {
  const _ConfirmPassword();

  @override
  Widget build(BuildContext context) => Obx(
        () => TextField(
          decoration: InputDecoration(
            labelText: S.current.confirmPassword,
            prefixIcon: Icon(
              Icons.lock_open_outlined,
              color: Get.theme.primaryColor,
            ),
            errorText: controller.confirmPasswordValidator.value,
            suffixIcon: InkWell(
              child: Obx(() => controller.obscureConfirmPassword.value
                  ? Icon(
                      Icons.visibility,
                      color: Get.theme.primaryColor,
                    )
                  : Icon(
                      Icons.visibility_off,
                      color: Get.theme.primaryColor,
                    )),
              onTap: controller.obscureConfirmPassword.toggle,
            ),
          ),
          obscureText: controller.obscureConfirmPassword.value,
          onChanged: (final text) => controller.confirmPassword.value = text,
        ),
      );
}
