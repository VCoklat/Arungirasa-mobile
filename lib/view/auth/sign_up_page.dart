import 'dart:typed_data';

import 'package:arungi_rasa/common/error_reporter.dart';
import 'package:arungi_rasa/common/helper.dart';
import 'package:arungi_rasa/common/mixin_controller_worker.dart';
import 'package:arungi_rasa/generated/assets.gen.dart';
import 'package:arungi_rasa/generated/l10n.dart';
import 'package:arungi_rasa/model/interest.dart';
import 'package:arungi_rasa/model/user.dart';
import 'package:arungi_rasa/repository/auth_repository.dart';
import 'package:arungi_rasa/repository/common/exception.dart';
import 'package:arungi_rasa/repository/interest_repository.dart';
import 'package:arungi_rasa/service/session_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gradient_loading_button/gradient_loading_button.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class SignUpPageBindings implements Bindings {
  @override void dependencies() {
    Get.lazyPut<_SignUpPageController>( () => new _SignUpPageController() );
  }
}

class SignUpPage extends GetView<_SignUpPageController> {
  const SignUpPage();
  @override
  Widget build(BuildContext context) => new Scaffold(
    body: new SafeArea(
      child: new ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric( vertical: 10.0, horizontal: 20.0 ),
        children: [
          photoProfile, gap, firstName, gap, lastName, phoneNumber, gap,
          email, gap, password, gap, confirmPassword,
          const SizedBox( height: 25.0, ),
          interestText, gap, interestList,
          const SizedBox( height: 25.0, ),
          new Padding(
            padding: const EdgeInsets.symmetric( horizontal: 20.0, ),
            child: new LoadingButton(
              child: new Text( S.current.signUp ),
              successChild: const Icon( Icons.check_sharp, size: 35, color: Colors.white, ),
              errorChild: const Icon( Icons.close_sharp, size: 35, color: Colors.white, ),
              style: new ButtonStyle(
                shape: MaterialStateProperty.all(
                  new RoundedRectangleBorder( borderRadius: const BorderRadius.all( const Radius.circular(30) ) ),
                ),
                backgroundColor: MaterialStateProperty.all( Color.fromRGBO( 240, 90, 40, 10) ),
                textStyle: MaterialStateProperty.all( const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ) )
              ),
              onPressed: controller.signUp,
            ),
          ), const SizedBox( height: 10.0, ),
        ],
      ),
    ),
  );

  Widget get photoProfile => new Center(
    child: new Stack(
      children: [
        new Container(
          width: 155, height: 155,
          decoration: new BoxDecoration(
            color: Get.theme.primaryColor,
            shape: BoxShape.circle,
          ),
          child: new Center(
            child: new ClipRRect(
              borderRadius: new BorderRadius.circular( 90.0 ),
              child: new Obx(
                () => controller.photoProfile.value == null ? Assets.images.placeholderProfile.image(
                  width: 150,
                  height: 150,
                ) : new Image.memory(
                  controller.photoProfile.value!,
                  width: 150,
                  height: 150,
                ),
              ),
            ),
          ),
        ),
        new Positioned(
          left: 107.5,
          top: 107.5,
          child: new IconButton(
            icon: Assets.images.takePhoto.image( width: 45, height: 45 ),
            onPressed: controller.pickImage,
          ),
        ),
      ],
    ),
  );
  Widget get gap => const SizedBox( height: 10.0, );

  Widget get firstName => new Obx(
    () => new TextField(
      decoration: new InputDecoration(
        labelText: S.current.firstName,
        errorText: controller.firstNameValidator.value,
      ),
      keyboardType: TextInputType.name,
      onChanged: ( final text ) => controller.firstName.value = text,
    ),
  );

  Widget get lastName => new Obx(
    () => new TextField(
      decoration: new InputDecoration(
        labelText: S.current.firstName,
        errorText: controller.firstNameValidator.value,
      ),
      keyboardType: TextInputType.name,
      onChanged: ( final text ) => controller.lastName.value = text,
    ),
  );

  Widget get phoneNumber => new Obx(
    () => new TextField(
      decoration: new InputDecoration(
        labelText: S.current.phoneNumber,
        errorText: controller.phoneNumberValidator.value,
      ),
      keyboardType: TextInputType.phone,
      onChanged: ( final text ) => controller.phoneNumber.value = text,
    ),
  );

  Widget get email => new Obx(
    () => new TextField(
      decoration: new InputDecoration(
        labelText: S.current.email,
        prefixIcon: new Icon( Icons.email_outlined, color: Get.theme.primaryColor, ),
        errorText: controller.emailValidator.value,
      ),
      keyboardType: TextInputType.emailAddress,
      onChanged: ( final text ) => controller.email.value = text,
    ),
  );

  Widget get password => new Obx(
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
  );

  Widget get confirmPassword => new Obx(
    () => new TextField(
      decoration: new InputDecoration(
        labelText: S.current.confirmPassword,
        prefixIcon: new Icon( Icons.lock_open_outlined, color: Get.theme.primaryColor, ),
        errorText: controller.confirmPasswordValidator.value,
        suffixIcon: new InkWell(
          child: new Obx( () => controller.obscureConfirmPassword.value ? new Icon( Icons.visibility, color: Get.theme.primaryColor, ) : new Icon( Icons.visibility_off, color: Get.theme.primaryColor, ) ),
          onTap: controller.obscureConfirmPassword.toggle,
        ),
      ),
      obscureText: controller.obscureConfirmPassword.value,
      onChanged: ( final text ) => controller.confirmPassword.value = text,
    ),
  );

  Widget get interestText => new Padding(
    padding: const EdgeInsets.symmetric( horizontal: 30.0, ),
    child: new Text(
      S.current.signUpInterest,
      textAlign: TextAlign.center,
      style: new TextStyle(
        color: Get.theme.primaryColor,
        fontWeight: FontWeight.bold,
        fontSize: 21.0,
      ),
    ),
  );

  Widget get interestList => new Padding(
    padding: const EdgeInsets.symmetric( horizontal: 10.0, ),
    child: new Obx(
      () => controller.onLoadInterest.value ? new Center(
        child: new CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>( Get.theme.primaryColor ),
        ),
      ) : new Wrap(
        runSpacing: 10.0, spacing: 10.0,
        children: controller.interestList.map( ( e ) => new _InterestWidget(
          interest: e,
          selected: controller.selectedInterestList.contains( e ),
          onPressed: () {
            if ( controller.selectedInterestList.contains( e ) )
              controller.selectedInterestList.remove( e );
            else
              controller.selectedInterestList.add( e );
          },
        ) ).toList( growable: false ),
      ),
    ),
  );

}

class _InterestWidget extends StatelessWidget {
  final Interest interest;
  final bool selected;
  final VoidCallback onPressed;

  const _InterestWidget({Key? key, required this.interest, required this.selected, required this.onPressed, }) : super(key: key);

  @override
  Widget build(BuildContext context) => new MaterialButton(
    color: selected ? Get.theme.primaryColor : Colors.white,
    shape: new RoundedRectangleBorder(
      borderRadius: const BorderRadius.all( const Radius.circular( 30.0 ) ),
      side: selected ? BorderSide.none : new BorderSide(
        color: Get.theme.primaryColor,
        width: 1.5,
      )
    ),
    child: new Padding(
      padding: const EdgeInsets.all( 10.0 ),
      child: new Text(
        interest.name,
        style: new TextStyle(
          fontWeight: FontWeight.w500,
          color: selected ? Colors.white : Get.theme.primaryColor,
        ),
      ),
    ),
    onPressed: onPressed,
  );
}

class _SignUpPageController extends GetxController with MixinControllerWorker {
  final firstName = new RxString("");
  final lastName = new RxString("");
  final phoneNumber = new RxString("");
  final email = new RxString("");
  final password = new RxString("");
  final confirmPassword = new RxString("");
  final photoProfile = new Rxn<Uint8List>();

  final obscurePassword = new RxBool( true );
  final obscureConfirmPassword = new RxBool( true );

  final firstNameValidator = new RxnString();
  final lastNameValidator = new RxnString();
  final phoneNumberValidator = new RxnString();
  final emailValidator = new RxnString();
  final passwordValidator = new RxnString();
  final confirmPasswordValidator = new RxnString();

  final onLoadInterest = new RxBool( false );
  final interestList = new RxList<Interest>();
  final selectedInterestList = new RxList<Interest>();

  @override
  void onReady() {
    super.onReady();
    new Future.delayed( Duration.zero, loadInterestList );
  }

  Future<void> signUp( final LoadingButtonController controller ) async {
    final currentFocus = FocusScope.of( Get.focusScope!.context! );
    if ( !currentFocus.hasPrimaryFocus ) currentFocus.unfocus();
    _validateEmail( email.value );
    _validatePassword( password.value );
    _validatePhoneNumber( phoneNumber.value );
    _validateConfirmPassword( confirmPassword.value );
    _validateFirstName( firstName.value );
    _validateLastName( lastName.value );
    if ( _hasErrors ) return;

    try {
      await controller.loading();

      String? photoUrl;
      if ( photoProfile.value != null ) {
        final instance = FirebaseStorage.instance;
        final fileName = "${new Uuid().v4()}.png";
        final ref = instance.ref().child("user").child("profile").child(fileName);
        final task = ref.putData(
          photoProfile.value!,
          new SettableMetadata(
            contentDisposition: "attachment; filename=\"$firstName\"",
            cacheControl: "public, max-age=604800, immutable",
            contentType: "image/png",
          ),
        );
        await task;
        photoUrl = await ref.getDownloadURL();
      }

      final phoneNumber = _transformPhoneNumber( this.phoneNumber.value );
      await AuthRepository.instance.signUp(
        new SignUp(
          email: email.value, displayName: "${firstName.value} ${ lastName.value }",
          phoneNumber: phoneNumber, photoUrl: photoUrl, password: password.value,
          interestList: selectedInterestList.map( ( e ) => e.id ).toList( growable: false ),
        ),
      );
      await FirebaseAuth.instance.signInWithEmailAndPassword( email: email.value, password: password.value );
      await controller.success();
      await new Future.delayed( const Duration( milliseconds: 500 ) );
      SessionService.instance.navigate();
    } on HttpConflictException {
      controller.error();
      Helper.showError(
        text: S.current.errorEmailAlreadyExists + "\n" + S.current.or + "\n" + S.current.errorPhoneNumberAlreadyExists,
      );
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

  Future<void> loadInterestList() async {
    try {
      onLoadInterest.value = true;
      interestList.assignAll( await InterestRepository.instance.find() );
    } catch ( error, st ) {
      ErrorReporter.instance.captureException( error, st );
      Helper.showError();
    } finally {
      onLoadInterest.value = false;
    }
  }

  Future<void> pickImage() async {
    final source = await Get.bottomSheet<ImageSource>(
      new SizedBox(
        width: Get.width,
        child: new Material(
          child: new Padding(
            padding: const EdgeInsets.all( 10.0 ),
            child: new ListView(
              shrinkWrap: true,
              children: <Widget?>[
                new ListTile(
                  title: new Text("close".tr),
                  leading: const Icon( Icons.close ),
                  onTap: () => Get.back( result: null ),
                ),
                new ListTile(
                  title: new Text("camera".tr),
                  leading: const Icon( Icons.camera ),
                  onTap: () => Get.back( result: ImageSource.camera ),
                ),
                new ListTile(
                  title: new Text("gallery".tr),
                  leading: const Icon( Icons.camera_alt ),
                  onTap: () => Get.back( result: ImageSource.gallery ),
                ),
              ].where( ( e ) => e != null ).cast<Widget>().toList( growable: false ),
            ),
          ),
        ),
      ),
    );
    if ( source == null ) return;
    final image = await new ImagePicker().getImage(source: source);
    if ( image == null ) return;
    final croppedFile = await ImageCropper.cropImage(
        sourcePath: image.path,
        cropStyle: CropStyle.circle,
        aspectRatioPresets: [ CropAspectRatioPreset.square ],
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: S.current.signUp,
          toolbarColor: Get.theme.primaryColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true,
        ),
        iosUiSettings: IOSUiSettings( minimumAspectRatio: 1.0 ),
    );
    if ( croppedFile == null ) return;
    photoProfile.value = await croppedFile.readAsBytes();
  }

  @override List<Worker> getWorkers() => <Worker>[
    ever<String>( email, _validateEmail ),
    ever<String>( password, _validatePassword ),
    ever<String>( firstName, _validateFirstName ),
    ever<String>( lastName, _validateLastName ),
    ever<String>( phoneNumber, _validatePhoneNumber ),
    ever<String>( confirmPassword, _validateConfirmPassword ),
  ];

  bool get _hasErrors => emailValidator.value != null
      || passwordValidator.value != null || confirmPasswordValidator.value != null
      || emailValidator.value != null || phoneNumberValidator.value != null
      || firstNameValidator.value != null || lastNameValidator.value != null;

  void _validateEmail( final String email ) {
    if ( email.isEmpty )
      emailValidator.value = S.current.errorEmailEmpty;
    else if ( !email.isEmail )
      emailValidator.value = S.current.errorEmailInvalid;
    else
      emailValidator.value = null;
  }

  void _validateFirstName( final String firstName ) => firstNameValidator.value = firstName.isEmpty ? S.current.errorFirstNameEmpty : null;
  void _validateLastName( final String lastName ) => lastNameValidator.value = lastName.isEmpty ? S.current.errorLastNameEmpty : null;
  void _validatePhoneNumber( final String phoneNumber ) {
    if ( phoneNumber.isEmpty )
      phoneNumberValidator.value = S.current.errorPhoneNumberEmpty;
    else if ( !phoneNumber.isPhoneNumber )
      phoneNumberValidator.value = S.current.errorPhoneNumberInvalid;
    else if ( _transformPhoneNumber( phoneNumber ).length > 15 )
      phoneNumberValidator.value = S.current.errorPhoneNumberTooLong;
    else
      phoneNumberValidator.value = null;
  }

  void _validatePassword( final String password ) {
    if ( password.isEmpty )
      passwordValidator.value = S.current.errorPasswordEmpty;
    else if ( password != confirmPassword.value ) {
      passwordValidator.value = null;
      confirmPasswordValidator.value = S.current.errorConfirmPasswordNotEqual;
    }
    else
      passwordValidator.value = null;
  }

  void _validateConfirmPassword( final String confirmPassword ) {
    if ( confirmPassword.isEmpty )
      confirmPasswordValidator.value = S.current.errorConfirmPasswordEmpty;
    else if ( confirmPassword != password.value )
      confirmPasswordValidator.value = S.current.errorConfirmPasswordNotEqual;
    else
      confirmPasswordValidator.value = null;
  }

  String _transformPhoneNumber( final String phoneNumber ) => phoneNumber.startsWith("0") ? phoneNumber.replaceFirst("0", "+62" ) : phoneNumber;

}