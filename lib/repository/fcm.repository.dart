import 'package:arungi_rasa/common/config.dart';
import 'package:arungi_rasa/service/session_service.dart';
import 'package:get/get.dart';
import 'package:get_connect_repo_mixin/get_connect_repo_mixin.dart';

import 'mixin_repository_config.dart';

class FcmRepository extends GetConnect
    with
        RepositoryErrorHandlerMixin,
        RepositorySslHandlerMixin,
        RepositoryAuthHandlerMixin,
        RepositoryConfigMixin {
  static final instance = Get.find<FcmRepository>();
  Future<void> register(final String token) async {
    final response = await post(
      "$kRestUrl/fcm",
      {
        "token": token,
      },
    );
    if (!response.isOk) throw getException(response);
  }

  @override
  List<int> get certificate => [];

  @override
  Future<String> get accessToken async =>
      "Bearer ${await SessionService.instance.accessToken}";
}
