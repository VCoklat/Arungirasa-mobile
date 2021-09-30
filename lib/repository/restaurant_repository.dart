import 'package:arungi_rasa/common/config.dart';
import 'package:arungi_rasa/model/latlng.dart';
import 'package:arungi_rasa/model/restaurant.dart';
import 'package:get/get.dart';
import 'package:get_connect_repo_mixin/get_connect_repo_mixin.dart';

import 'mixin_repository_config.dart';

class RestaurantRepository extends GetConnect
    with
        RepositoryConfigMixin,
        RepositorySslHandlerMixin,
        RepositoryErrorHandlerMixin {
  static RestaurantRepository get instance => Get.find<RestaurantRepository>();

  Future<List<Restaurant>> find() async {
    final response = await get("$kRestUrl/restaurant");
    if (response.isOk) {
      return (response.body as List)
          .map((e) => Restaurant.fromJson(e as Map<String, dynamic>))
          .toList(growable: false);
    } else {
      throw getException(response);
    }
  }

  Future<Restaurant> findOneNearest(final LatLng latLng) async {
    final response = await get(
        "$kRestUrl/restaurant/nearest/one?lat=${latLng.lat}&lng=${latLng.lng}");
    if (response.isOk) {
      return Restaurant.fromJson(response.body as Map<String, dynamic>);
    } else {
      throw getException(response);
    }
  }

  Future<double> distance({
    required final RestaurantRef ref,
    required final LatLng latLng,
  }) async {
    final response = await get(
      "$kRestUrl/restaurant/${ref.id}/distance",
      query: {
        "lat": latLng.lat.toString(),
        "lng": latLng.lng.toString(),
      },
    );
    if (response.isOk) {
      return double.tryParse(response.bodyString ?? "0") ?? 0;
    } else {
      throw getException(response);
    }
  }

  Future<double> rating(final RestaurantRef ref) async {
    final response = await get(
      "$kRestUrl/restaurant/${ref.id}/rating",
    );
    if (response.isOk) {
      return double.tryParse(response.bodyString ?? "0") ?? 0;
    } else {
      throw getException(response);
    }
  }

  @override
  List<int> get certificate => [];
}
