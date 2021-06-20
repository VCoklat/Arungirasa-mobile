import 'package:ant_icons/ant_icons.dart';
import 'package:arungi_rasa/common/error_reporter.dart';
import 'package:arungi_rasa/common/helper.dart';
import 'package:arungi_rasa/common/mixin_controller_worker.dart';
import 'package:arungi_rasa/generated/assets.gen.dart';
import 'package:arungi_rasa/generated/l10n.dart';
import 'package:arungi_rasa/service/session_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:gradient_loading_button/gradient_loading_button.dart';

class SignInPageBindings implements Bindings {
  @override void dependencies() {
    Get.lazyPut<_SignInPageController>( () => new _SignInPageController() );
  }
}

class SignInPage extends GetView<_SignInPageController> {
  const SignInPage();
  @override
  Widget build(BuildContext context) => new Scaffold(
    body: new SafeArea(
      child: new ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric( vertical: 10.0, horizontal: 20.0 ),
        children: [
          image, space, helloText, appAboutText, const SizedBox( height: 10.0, ),
          new Obx(
            () => new TextField(
              decoration: new InputDecoration(
                labelText: S.current.email,
                prefixIcon: new Icon( Icons.email_outlined, color: Get.theme.primaryColor, ),
                errorText: controller.emailValidator.value,
              ),
              keyboardType: TextInputType.emailAddress,
              onChanged: ( final text ) => controller.email.value = text,
            ),
          ), const SizedBox( height: 10.0, ),
          new Obx(
            () => new TextField(
              decoration: new InputDecoration(
                labelText: S.current.password,
                prefixIcon: new Icon( Icons.lock_open_outlined, color: Get.theme.primaryColor, ),
                errorText: controller.passwordValidator.value,
                suffixIcon: new InkWell(
                  child: new Obx( () => controller.obscurePassword.value ? new Icon( Icons.visibility, color: Get.theme.primaryColor, ) : new Icon( Icons.visibility_off, color: Get.theme.primaryColor, ) ),
                  onTap: controller.obscurePassword.toggle,
                ),
              ),
              obscureText: controller.obscurePassword.value,
              onChanged: ( final text ) => controller.password.value = text,
            ),
          ), const SizedBox( height: 25.0, ),
          new LoadingButton(
            child: new Text( S.current.signIn ),
            successChild: const Icon( Icons.check_sharp, size: 35, color: Colors.white, ),
            errorChild: const Icon( Icons.close_sharp, size: 35, color: Colors.white, ),
            style: new ButtonStyle(
                shape: MaterialStateProperty.all(
                  new RoundedRectangleBorder( borderRadius: const BorderRadius.all( const Radius.circular(30) ) ),
                ),
                backgroundColor: MaterialStateProperty.all( Get.theme.accentColor ),
                textStyle: MaterialStateProperty.all( const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ) )
            ),
            onPressed: controller.signIn,
          ), const SizedBox( height: 10.0, ),
          signUpLink, orText, space, signInWithText, space, googleSignInButton,
          space, facebookSignInButton,
        ],
      ),
    ),
  );

  Widget get image => new KeyboardVisibilityBuilder(
    builder: ( _, isVisible ) => isVisible ? const SizedBox() : new Center(
      child: Assets.images.logoWithText.image(
        height: Get.height * 0.3 - 10,
        fit: BoxFit.fitHeight,
      ),
    ),
  );

  Widget get space => new KeyboardVisibilityBuilder(
    builder: ( _, isVisible ) => isVisible ? const SizedBox() : const SizedBox( height: 10.0, ),
  );

  Widget get helloText => new KeyboardVisibilityBuilder(
    builder: ( _, isVisible ) => isVisible ? const SizedBox() : new Text(
      S.current.hello,
      style: const TextStyle( fontSize: 20.0, fontWeight: FontWeight.bold, ),
    ),
  );

  Widget get appAboutText => new KeyboardVisibilityBuilder(
    builder: ( _, isVisible ) => isVisible ? const SizedBox() : new Text(
      S.current.aboutShortText,
    ),
  );

  Widget get signUpLink => new KeyboardVisibilityBuilder(
    builder: ( _, isVisible ) => isVisible ? const SizedBox() : new Center(
      child: new Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          new Text( S.current.signUpText ),
          new TextButton(
            child: new Text( S.current.signUp ),
            style: new ButtonStyle(
              textStyle: MaterialStateProperty.all(
                const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              foregroundColor: MaterialStateProperty.all( const Color( 0xFFF05A28 ) ),
            ),
            onPressed: controller.signUp,
          ),
        ],
      ),
    ),
  );

  Widget get orText => new KeyboardVisibilityBuilder(
    builder: ( _, isVisible ) => isVisible ? const SizedBox() : new Center(
      child: new Text(
        S.current.or,
        style: const TextStyle( color: Colors.grey ),
      ),
    ),
  );

  Widget get signInWithText => new KeyboardVisibilityBuilder(
    builder: ( _, isVisible ) => isVisible ? const SizedBox() : new Center(
      child: new Text(
        S.current.signInWith,
      ),
    ),
  );

  Widget get googleSignInButton => new KeyboardVisibilityBuilder(
    builder: ( _, isVisible ) => isVisible ? const SizedBox() : new Center(
      child: new MaterialButton(
        color: const Color( 0xFFBE1E2D ),
        child: new Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon( AntIcons.google, color: Colors.white, ),
            const SizedBox( width: 10.0, ),
            new Text( S.current.signInWithGoogle, style: const TextStyle( color: Colors.white, fontSize: 16.0, ), ),
          ],
        ),
        shape: new RoundedRectangleBorder( borderRadius: const BorderRadius.all( const Radius.circular(30) ) ),
        onPressed: controller.signInGoogle,
      ),
    ),
  );

  Widget get facebookSignInButton => new KeyboardVisibilityBuilder(
    builder: ( _, isVisible ) => isVisible ? const SizedBox() : new Center(
      child: new MaterialButton(
        color: const Color( 0xFF3D599D ),
        child: new Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon( AntIcons.facebook, color: Colors.white, ),
            const SizedBox( width: 10.0, ),
            new Text( S.current.signInWithFacebook, style: const TextStyle( color: Colors.white, fontSize: 16.0, ), ),
          ],
        ),
        shape: new RoundedRectangleBorder( borderRadius: const BorderRadius.all( const Radius.circular(30) ) ),
        onPressed: controller.signInFacebook,
      ),
    ),
  );

}

class _SignInPageController extends GetxController with MixinControllerWorker {
  final email = new RxString("");
  final password = new RxString("");
  final obscurePassword = new RxBool( true );

  final emailValidator = new RxnString();
  final passwordValidator = new RxnString();

  Future<void> signIn( final LoadingButtonController controller ) async {
    final currentFocus = FocusScope.of( Get.focusScope!.context! );
    if ( !currentFocus.hasPrimaryFocus ) currentFocus.unfocus();
    _validateEmail( email.value );
    _validatePassword( password.value );
    if ( _hasErrors ) return;

    try {
      await controller.loading();

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.value, password: password.value,
      );

      await controller.success();
      await new Future.delayed( const Duration( milliseconds: 500 ) );
      SessionService.instance.navigate();
    } on FirebaseAuthException catch ( e, st ) {
      controller.error();
      if ( e.code == "user-not-found" )
        emailValidator.value = S.current.errorEmailNotFound;
      else if ( e.code == "wrong-password" )
        passwordValidator.value = S.current.errorPasswordInvalid;
      else {
        ErrorReporter.instance.captureException( e, st );
        Helper.showError( text: S.current.errorOccurred );
      }
    } catch ( e, st ) {
      ErrorReporter.instance.captureException( e, st );
      await controller.error();
      Helper.showError( text: S.current.errorOccurred );
    }
  }

  void signUp() {}

  Future<void> signInGoogle() async {
    final result = await SessionService.instance.signInGoogle();
    if ( result ) SessionService.instance.navigate();
  }

  Future<void> signInFacebook() async {
    final result = await SessionService.instance.signInFacebook();
    if ( result ) SessionService.instance.navigate();
  }

  @override List<Worker> getWorkers() => <Worker>[
    ever<String>( email, _validateEmail ),
    ever<String>( password, _validatePassword ),
  ];

  bool get _hasErrors => emailValidator.value != null || passwordValidator.value != null;

  void _validateEmail( final String email ) {
    if ( email.isEmpty )
      emailValidator.value = S.current.errorEmailEmpty;
    else if ( !email.isEmail )
      emailValidator.value = S.current.errorEmailInvalid;
    else
      emailValidator.value = null;
  }

  void _validatePassword( final String password ) => passwordValidator.value = password.isEmpty ? S.current.errorPasswordEmpty : null;

}