import 'dart:convert';

import 'package:arungi_rasa/env/env.dart';
import 'package:arungi_rasa/model/mapbox.dart';
import 'package:get/get.dart';
import 'package:get_connect_repo_mixin/get_connect_repo_mixin.dart';

class MapBoxRepository extends GetConnect with RepositoryErrorHandlerMixin {
  static MapBoxRepository get instance => Get.find<MapBoxRepository>();

  Future<MapBoxFeatureCollection> find(final String query) async {
    final response = await get(
        "https://api.mapbox.com/geocoding/v5/mapbox.places/${Uri.encodeComponent(query)}.json",
        query: {
          "access_token": env.mapBoxAccessToken,
          "country": "ID",
          "limit": "10",
        });
    if (response.isOk) {
      return MapBoxFeatureCollection.fromJson(
          json.decode(response.body as String));
    } else {
      throw getException(response);
    }
  }

  Future<MapBoxFeatureCollection> findByLatLng(
      final double latitude, final double longitude) async {
    final response = await get(
        "https://api.mapbox.com/geocoding/v5/mapbox.places/$longitude,$latitude.json",
        query: {
          "access_token": env.mapBoxAccessToken,
          "country": "ID",
        });
    if (response.isOk) {
      return MapBoxFeatureCollection.fromJson(
          json.decode(response.body as String));
    } else {
      throw getException(response);
    }
  }
}
