import 'package:arungi_rasa/common/error_reporter.dart';
import 'package:arungi_rasa/common/helper.dart';
import 'package:arungi_rasa/common/mixin_controller_worker.dart';
import 'package:arungi_rasa/generated/l10n.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gradient_loading_button/gradient_loading_button.dart';

class _ForgetPasswordBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<_ForgetPasswordPageController>(
        () => _ForgetPasswordPageController());
  }
}

class ForgetPassword extends GetView<_ForgetPasswordPageController> {
  const ForgetPassword({Key? key}) : super(key: key);
  static _ForgetPasswordBinding binding() => _ForgetPasswordBinding();
  @override
  Widget build(final BuildContext context) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        S.of(context).resetPassword,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Get.theme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                        ),
                        child: Text(
                          S.of(context).resetPasswordDescription,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Get.theme.primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Obx(
                        () => TextField(
                          decoration: InputDecoration(
                            labelText: S.of(context).email,
                            prefixIcon: Icon(
                              Icons.email,
                              color: Get.theme.primaryColor,
                            ),
                            errorText: controller.emailValidator.value,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (final String text) =>
                              controller.email.value = text,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                        height: 50,
                        child: LoadingButton(
                          child: Text(S.current.resetPassword),
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
                              backgroundColor: MaterialStateProperty.all(
                                  Get.theme.accentColor),
                              textStyle:
                                  MaterialStateProperty.all(const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24.0,
                              ))),
                          onPressed: controller.resetPassword,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
              Center(
                child: TextButton.icon(
                  icon: const Icon(Icons.arrow_back),
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all(Get.theme.primaryColor),
                  ),
                  label: Text(S.current.back),
                  onPressed: Get.back,
                ),
              ),
              const SizedBox(height: 10.0),
            ],
          ),
        ),
      );
}

class _ForgetPasswordPageController extends GetxController
    with MixinControllerWorker {
  final email = RxString("");
  final emailValidator = RxnString();

  void _verifyEmail(final String email) {
    if (email.isEmpty) {
      emailValidator.value = S.current.errorEmailEmpty;
    } else if (!GetUtils.isEmail(email)) {
      emailValidator.value = S.current.errorEmailInvalid;
    } else {
      emailValidator.value = null;
    }
  }

  Future<void> resetPassword(final LoadingButtonController controller) async {
    _verifyEmail(email.value);
    if (emailValidator.value != null) return;
    try {
      controller.loading();
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.value);
      await controller.success();
      Helper.showSuccess(
        text: S.current.resetPasswordLinkHasBeenSent,
      );
    } on FirebaseAuthException catch (error, st) {
      controller.error();
      if (error.code == "invalid-email") {
        emailValidator.value = S.current.errorEmailInvalid;
      } else if (error.code == "user-not-found") {
        emailValidator.value = S.current.errorEmailNotFound;
      } else {
        ErrorReporter.instance.captureException(error, st);
      }
    } on PlatformException catch (error, st) {
      controller.error();
      if (error.code == "ERROR_INVALID_EMAIL") {
        emailValidator.value = S.current.errorEmailInvalid;
      } else if (error.code == "ERROR_USER_NOT_FOUND") {
        emailValidator.value = S.current.errorEmailNotFound;
      } else {
        ErrorReporter.instance.captureException(error, st);
      }
    } catch (error, st) {
      controller.error();
      ErrorReporter.instance.captureException(error, st);
    }
  }

  @override
  List<Worker> getWorkers() => <Worker>[
        ever<String>(email, _verifyEmail),
      ];
}
