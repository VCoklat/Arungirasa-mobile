import 'package:arungi_rasa/generated/l10n.dart';
import 'package:arungi_rasa/model/latlng.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

extension DateTimeToJson on DateTime {
  String toJson() => DateFormat("yyyy-MM-dd").format(this);
}

class Helper {
  static String formatMoney(double amount) =>
      "Rp. " +
      NumberFormat("#,###", Localizations.localeOf(Get.context!).languageCode)
          .format(amount.round())
          .replaceAll(",", ".");

  static void showLoading([final String? message]) => EasyLoading.show(
        status: message ?? S.current.pleaseWait,
        dismissOnTap: false,
        maskType: EasyLoadingMaskType.clear,
      );

  static Future<void> showError({
    final String? text,
    final Duration? showDuration,
    final VoidCallback? onDismissed,
  }) async {
    await EasyLoading.showError(
      text ?? S.current.errorOccurred,
      duration: showDuration,
      maskType: EasyLoadingMaskType.clear,
    );
    if (onDismissed != null) onDismissed();
  }

  static Future<void> showSuccess({
    final String? text,
    final Duration? showDuration,
    final VoidCallback? onDismissed,
  }) async {
    await EasyLoading.showSuccess(
      text ?? "",
      duration: showDuration,
      maskType: EasyLoadingMaskType.clear,
    );
    if (onDismissed != null) onDismissed();
  }

  static Future<void> hideLoading() async => await EasyLoading.dismiss();

  static Future<void> hideLoadingWithError({final String? text}) async {
    await EasyLoading.dismiss();
    await EasyLoading.showError(text ?? S.current.errorOccurred);
  }

  static Future<void> hideLoadingWithSuccess({final String? text}) async {
    await EasyLoading.dismiss();
    await EasyLoading.showSuccess(text ?? "");
  }

  static SnackBar get doubleBackPressedToExitAppSnackBar => SnackBar(
        content: Text(S.current.doubleBackPressedToExit),
        backgroundColor: Get.theme.primaryColor,
      );

  static String getAvatarName(final String name) {
    if (name.isEmpty) return "AR";
    final names = name.trim().split(" ");
    if (names.length == 1 || names.last.isEmpty) {
      return names.first.substring(0, 2);
    } else {
      return names.first.substring(0, 1) + names.last.substring(0, 1);
    }
  }

  static Future<String> latLngToString(final LatLng latLng) async {
    final placemarks = await placemarkFromCoordinates(latLng.lat, latLng.lng);
    if (placemarks.isEmpty) {
      return "";
    } else {
      return "${placemarks.first.name == null || placemarks.first.name!.isEmpty ? "" : "${placemarks.first.name}, "}${placemarks.first.street ?? ""}";
    }
  }
}
