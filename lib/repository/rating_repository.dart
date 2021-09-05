import 'package:arungi_rasa/common/config.dart';
import 'package:arungi_rasa/model/order.dart';
import 'package:arungi_rasa/model/rating.dart';
import 'package:arungi_rasa/repository/mixin_repository_config.dart';
import 'package:arungi_rasa/service/session_service.dart';
import 'package:get/get.dart';
import 'package:get_connect_repo_mixin/get_connect_repo_mixin.dart';

class RatingRepository extends GetConnect
    with
        RepositoryConfigMixin,
        RepositorySslHandlerMixin,
        RepositoryAuthHandlerMixin,
        RepositoryErrorHandlerMixin {
  static RatingRepository get instance => Get.find<RatingRepository>();
  Future<Rating> create({
    required final Order order,
    required final double rating,
  }) async {
    final response = await post(
      "$kRestUrl/rating",
      {
        "orderId": order.id.toString(),
        "rating": rating,
      },
    );
    if (response.isOk) {
      return Rating.fromJson(response.body as Map<String, dynamic>);
    } else {
      throw getException(response);
    }
  }

  Future<Rating?> findOne(final Order order) async {
    final response = await get(
      "$kRestUrl/rating",
      query: {
        "orderId": order.id.toString(),
      },
    );
    if (response.isOk) {
      final list = (response.body as List)
          .map((e) => Rating.fromJson(e as Map<String, dynamic>))
          .toList(growable: false);
      if (list.isNotEmpty) {
        return list.first;
      } else {
        return null;
      }
    } else {
      throw getException(response);
    }
  }

  Future<bool> hasGiveRating(final Order order) async {
    final response = await get(
      "$kRestUrl/rating",
      query: {
        "orderId": order.id.toString(),
      },
    );
    if (response.isOk) {
      return (response.body as List).isNotEmpty;
    } else {
      throw getException(response);
    }
  }

  @override
  Future<String> get accessToken async =>
      "Bearer ${await SessionService.instance.accessToken}";

  @override
  List<int> get certificate => const [];
}
