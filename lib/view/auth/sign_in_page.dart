import 'package:ant_icons/ant_icons.dart';
import 'package:arungi_rasa/common/error_reporter.dart';
import 'package:arungi_rasa/common/helper.dart';
import 'package:arungi_rasa/common/mixin_controller_worker.dart';
import 'package:arungi_rasa/generated/assets.gen.dart';
import 'package:arungi_rasa/generated/l10n.dart';
import 'package:arungi_rasa/routes/routes.dart';
import 'package:arungi_rasa/service/session_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:gradient_loading_button/gradient_loading_button.dart';

class SignInPageBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<_SignInPageController>(() => _SignInPageController());
  }
}

class SignInPage extends GetView<_SignInPageController> {
  const SignInPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 40.0),
            children: [
              image,
              space,
              helloText,
              appAboutText,
              Obx(
                () => TextField(
                  decoration: InputDecoration(
                    labelText: S.current.email,
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: Get.theme.primaryColor,
                    ),
                    errorText: controller.emailValidator.value,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (final text) => controller.email.value = text,
                ),
              ),
              Obx(
                () => TextField(
                  decoration: InputDecoration(
                    labelText: S.current.password,
                    prefixIcon: Icon(
                      Icons.lock_open_outlined,
                      color: Get.theme.primaryColor,
                    ),
                    errorText: controller.passwordValidator.value,
                    suffixIcon: InkWell(
                      child: Obx(() => controller.obscurePassword.value
                          ? Icon(
                              Icons.visibility,
                              color: Get.theme.primaryColor,
                            )
                          : Icon(
                              Icons.visibility_off,
                              color: Get.theme.primaryColor,
                            )),
                      onTap: controller.obscurePassword.toggle,
                    ),
                  ),
                  obscureText: controller.obscurePassword.value,
                  onChanged: (final text) => controller.password.value = text,
                ),
              ),
              const SizedBox(height: 2.5),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  child: Text(
                    S.current.forgotPassword,
                    style: TextStyle(
                      color: Get.theme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () => Get.toNamed(Routes.resetPassword),
                ),
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                height: 50,
                child: LoadingButton(
                  child: Text(S.current.signIn),
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
                  onPressed: controller.signIn,
                ),
              ),
              const SizedBox(height: 10.0),
              signUpLink,
              space,
              orText,
              space,
              signInWithText,
              space,
              googleSignInButton,
              space,
              facebookSignInButton,
            ],
          ),
        ),
      );

  Widget get image => KeyboardVisibilityBuilder(
        builder: (_, isVisible) => isVisible
            ? const SizedBox()
            : Center(
                child: Assets.images.logoWithText.image(
                  height: Get.height * 0.25 - 10,
                  fit: BoxFit.fitHeight,
                ),
              ),
      );

  Widget get space => KeyboardVisibilityBuilder(
        builder: (_, isVisible) =>
            isVisible ? const SizedBox() : const SizedBox(height: 5.0),
      );

  Widget get helloText => KeyboardVisibilityBuilder(
        builder: (_, isVisible) => isVisible
            ? const SizedBox()
            : Text(
                S.current.hello + ",",
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
      );

  Widget get appAboutText => KeyboardVisibilityBuilder(
        builder: (_, isVisible) => isVisible
            ? const SizedBox()
            : Text(S.current.aboutShortText,
                style: const TextStyle(height: 1.5, color: Colors.grey)),
      );

  Widget get signUpLink => KeyboardVisibilityBuilder(
        builder: (_, isVisible) => isVisible
            ? const SizedBox()
            : Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(S.current.signUpText),
                    InkWell(
                      child: Text(
                        S.current.signUp,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFF05A28),
                        ),
                      ),
                      onTap: controller.signUp,
                    ),
                  ],
                ),
              ),
      );

  Widget get orText => KeyboardVisibilityBuilder(
        builder: (_, isVisible) => isVisible
            ? const SizedBox()
            : Center(
                child: Text(
                  S.current.or,
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
      );

  Widget get signInWithText => KeyboardVisibilityBuilder(
        builder: (_, isVisible) => isVisible
            ? const SizedBox()
            : Center(
                child: Text(S.current.signInWith),
              ),
      );

  Widget get googleSignInButton => KeyboardVisibilityBuilder(
        builder: (_, isVisible) => isVisible
            ? const SizedBox()
            : Center(
                child: MaterialButton(
                  color: const Color(0xFFBE1E2D),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        AntIcons.google,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 10.0),
                      Text(
                        S.current.signInWithGoogle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  onPressed: controller.signInGoogle,
                ),
              ),
      );

  Widget get facebookSignInButton => KeyboardVisibilityBuilder(
        builder: (_, isVisible) => isVisible
            ? const SizedBox()
            : Center(
                child: MaterialButton(
                  color: const Color(0xFF3D599D),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        AntIcons.facebook,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 10.0),
                      Text(
                        S.current.signInWithFacebook,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  onPressed: controller.signInFacebook,
                ),
              ),
      );
}

class _SignInPageController extends GetxController with MixinControllerWorker {
  final email = RxString("");
  final password = RxString("");
  final obscurePassword = RxBool(true);

  final emailValidator = RxnString();
  final passwordValidator = RxnString();

  Future<void> signIn(final LoadingButtonController controller) async {
    final currentFocus = FocusScope.of(Get.focusScope!.context!);
    if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
    _validateEmail(email.value);
    _validatePassword(password.value);
    if (_hasErrors) return;

    try {
      await controller.loading();

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.value,
        password: password.value,
      );

      await controller.success();
      await Future.delayed(const Duration(milliseconds: 500));
      SessionService.instance.navigate();
    } on FirebaseAuthException catch (e, st) {
      controller.error();
      if (e.code == "user-not-found") {
        emailValidator.value = S.current.errorEmailNotFound;
      } else if (e.code == "wrong-password") {
        passwordValidator.value = S.current.errorPasswordInvalid;
      } else {
        ErrorReporter.instance.captureException(e, st);
        Helper.showError(text: S.current.errorOccurred);
      }
    } catch (e, st) {
      ErrorReporter.instance.captureException(e, st);
      await controller.error();
      Helper.showError(text: S.current.errorOccurred);
    }
  }

  void signUp() => Get.toNamed(Routes.signUp);

  Future<void> signInGoogle() async {
    final result = await SessionService.instance.signInGoogle();
    if (result) SessionService.instance.navigate();
  }

  Future<void> signInFacebook() async {
    final result = await SessionService.instance.signInFacebook();
    if (result) SessionService.instance.navigate();
  }

  @override
  List<Worker> getWorkers() => <Worker>[
        ever<String>(email, _validateEmail),
        ever<String>(password, _validatePassword),
      ];

  bool get _hasErrors =>
      emailValidator.value != null || passwordValidator.value != null;

  void _validateEmail(final String email) {
    if (email.isEmpty) {
      emailValidator.value = S.current.errorEmailEmpty;
    } else if (!email.isEmail) {
      emailValidator.value = S.current.errorEmailInvalid;
    } else {
      emailValidator.value = null;
    }
  }

  void _validatePassword(final String password) => passwordValidator.value =
      password.isEmpty ? S.current.errorPasswordEmpty : null;
}
