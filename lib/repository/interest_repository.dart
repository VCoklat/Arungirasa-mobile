import 'package:arungi_rasa/common/config.dart';
import 'package:arungi_rasa/model/interest.dart';
import 'package:get/get.dart';
import 'package:get_connect_repo_mixin/get_connect_repo_mixin.dart';

import 'mixin_repository_config.dart';

class InterestRepository extends GetConnect
    with
        RepositoryConfigMixin,
        RepositorySslHandlerMixin,
        RepositoryErrorHandlerMixin {
  static InterestRepository get instance => Get.find<InterestRepository>();
  Future<List<Interest>> find() async {
    final response = await get("$kRestUrl/interest");
    if (response.isOk) {
      return (response.body as List)
          .map((e) => Interest.fromJson(e as Map<String, dynamic>))
          .toList(growable: false);
    } else {
      throw getException(response);
    }
  }

  @override
  List<int> get certificate => [];
}
