import 'dart:async';

import 'package:arungi_rasa/common/error_reporter.dart';
import 'package:arungi_rasa/common/helper.dart';
import 'package:arungi_rasa/repository/user_repository.dart';
import 'package:arungi_rasa/service/address_service.dart';
import 'package:arungi_rasa/service/cart_service.dart';
import 'package:arungi_rasa/routes/routes.dart';
import 'package:arungi_rasa/service/location_service.dart';
import 'package:arungi_rasa/service/notification_service.dart';
import 'package:arungi_rasa/service/order_service.dart';
import 'package:arungi_rasa/service/wistlist_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:get_connect_repo_mixin/get_connect_repo_mixin.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _hasViewIntroKey = "has-view-intro";

class NoSessionFoundException implements Exception {
  const NoSessionFoundException();
  String get message => "No Session was found";
  @override
  String toString() => message;
}

class InvalidAccessTokenException implements Exception {
  final String accessToken;
  const InvalidAccessTokenException(this.accessToken);
  String get message => "Access Token : $accessToken was invalid";
  @override
  String toString() => message;
}

class InvalidRefreshTokenException implements Exception {
  final String refreshToken;
  const InvalidRefreshTokenException(this.refreshToken);
  String get message => "Refresh Token : $refreshToken was invalid";
  @override
  String toString() => message;
}

class SessionService extends GetxService {
  static SessionService get instance => Get.find<SessionService>();
  final user = Rxn<User>();

  late StreamSubscription<User?> sessionSubscription;

  bool get hasSession => user.value != null;
  Future<String> get accessToken => user.value!.getIdToken();
  Future<String> get refreshAccessToken => user.value!.getIdToken(true);

  @override
  void onInit() {
    super.onInit();
    sessionSubscription =
        FirebaseAuth.instance.authStateChanges().listen(_onAuthStateChange);
  }

  @override
  void onReady() {
    super.onReady();
    Future.delayed(Duration.zero, _initSession);
  }

  @override
  void onClose() {
    sessionSubscription.cancel();
    super.onClose();
  }

  void refresh() => user.value = FirebaseAuth.instance.currentUser;

  void _initSession() async {
    await Future.delayed(const Duration(seconds: 1));
    user.value = FirebaseAuth.instance.currentUser;
    if (user.value == null) {
      Get.offAllNamed(Routes.signIn);
    } else if (!await hasViewIntro) {
      viewIntro();
    } else {
      navigate();
    }
    if (kDebugMode) debugPrint("Access Token: ${(await accessToken)}");
  }

  void navigate() {
    refreshData().then(_navigateRoute).timeout(
          const Duration(seconds: 10),
          onTimeout: _navigateRoute,
        );
  }

  void _navigateRoute([_]) async {
    if (!await hasViewIntro) {
      viewIntro();
    } else {
      Get.offAllNamed(Routes.home);
    }
  }

  Future<void> refreshData() async => Future.wait([
        LocationService.instance.fetchLocation(),
        NotificationService().refreshUnreadCount(),
      ]);

  Future<void> signOut() async {
    final preference = await SharedPreferences.getInstance();
    await preference.clear();
    await FirebaseAuth.instance.signOut();
    NotificationService.instance.refreshUnreadCount(0);
  }

  void _onAuthStateChange(final User? user) {
    this.user.value = user;
    if (user == null) {
      CartService.instance.clear();
      AddressService.instance.clear();
      OrderService.instance.clear();
      WishListService.instance.clear();
    } else {
      CartService.instance.load();
      AddressService.instance.load();
      OrderService.instance.load();
      WishListService.instance.load();
    }
    NotificationService.instance.registerNotification();
  }

  Future<bool> get hasViewIntro async {
    final preference = await SharedPreferences.getInstance();
    return preference.containsKey(_hasViewIntroKey)
        ? (preference.getBool(_hasViewIntroKey) ?? false)
        : false;
  }

  void setHasViewIntro([final bool hasViewIntro = true]) async {
    final preference = await SharedPreferences.getInstance();
    preference.setBool(_hasViewIntroKey, hasViewIntro);
  }

  Future<void> viewIntro() async => await Get.offAllNamed(Routes.intro);

  Future<bool> signInGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return false;
    try {
      Helper.showLoading();
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      user.value = userCredential.user;
      try {
        await UserRepository.instance.findMe();
      } on HttpNotFoundException {
        try {
          await UserRepository.instance.activate();
        } catch (error, st) {
          ErrorReporter.instance.captureException(error, st);
        }
      } catch (error, st) {
        ErrorReporter.instance.captureException(error, st);
      }
      Helper.hideLoadingWithSuccess();
      return true;
    } catch (error, st) {
      Helper.hideLoadingWithError();
      ErrorReporter.instance.captureException(error, st);
    }
    return false;
  }

  Future<bool> signInFacebook() async {
    final result = await FacebookAuth.instance.login();
    final accessToken = result.accessToken?.token;
    if (accessToken == null) {
      return false;
    }
    try {
      Helper.showLoading();
      final credential = FacebookAuthProvider.credential(accessToken);
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      user.value = userCredential.user;
      try {
        await UserRepository.instance.findMe();
      } on HttpNotFoundException {
        try {
          await UserRepository.instance.activate();
        } catch (error, st) {
          ErrorReporter.instance.captureException(error, st);
        }
      } catch (error, st) {
        ErrorReporter.instance.captureException(error, st);
      }
      Helper.hideLoadingWithSuccess();
      return true;
    } catch (error, st) {
      Helper.hideLoadingWithError();
      ErrorReporter.instance.captureException(error, st);
    }
    return false;
  }
}
