import 'package:arungi_rasa/common/config.dart';
import 'package:arungi_rasa/model/user.dart';
import 'package:arungi_rasa/service/session_service.dart';
import 'package:get/get.dart';
import 'package:get_connect_repo_mixin/get_connect_repo_mixin.dart';

import 'mixin_repository_config.dart';

class UserRepository extends GetConnect
    with
        RepositoryConfigMixin,
        RepositorySslHandlerMixin,
        RepositoryAuthHandlerMixin,
        RepositoryErrorHandlerMixin {
  static UserRepository get instance => Get.find<UserRepository>();

  Future<User> findMe() async {
    final response = await get("$kRestUrl/user/me");
    if (response.isOk) {
      return User.fromJson(response.body as Map<String, dynamic>);
    } else {
      throw getException(response);
    }
  }

  Future<User> activate() async {
    final response = await post("$kRestUrl/user/activate", {});
    if (response.isOk) {
      return User.fromJson(response.body as Map<String, dynamic>);
    } else {
      throw getException(response);
    }
  }

  @override
  List<int> get certificate => const [];

  @override
  Future<String> get accessToken async =>
      "Bearer ${await SessionService.instance.accessToken}";
}
