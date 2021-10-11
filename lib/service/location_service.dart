import 'dart:async';

import 'package:arungi_rasa/common/config.dart';
import 'package:arungi_rasa/common/error_reporter.dart';
import 'package:arungi_rasa/model/latlng.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

class LocationService extends GetxService {
  static LocationService get instance => Get.find<LocationService>();
  final location =
      Rx<LatLng>(const LatLng(lat: kDefaultLatitude, lng: kDefaultLongitude));

  Future<void> fetchLocation() async {
    try {
      final locator = Location();

      bool serviceEnabled = await locator.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await locator.requestService();
        if (!serviceEnabled) return;
      }

      PermissionStatus permission = await locator.hasPermission();
      if (permission == PermissionStatus.denied) {
        permission = await locator.requestPermission();
        if (permission != PermissionStatus.granted) {
          return;
        }
      }

      final locationData = await locator.getLocation();
      location.value = LatLng(
        lat: locationData.latitude ?? kDefaultLatitude,
        lng: locationData.longitude ?? kDefaultLongitude,
      );
    } catch (error, st) {
      ErrorReporter.instance.captureException(error, st);
    }
  }
}
