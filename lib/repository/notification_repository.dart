import 'package:arungi_rasa/common/config.dart';
import 'package:arungi_rasa/model/notification.dart';
import 'package:arungi_rasa/service/session_service.dart';
import 'package:get/get.dart';
import 'package:get_connect_repo_mixin/get_connect_repo_mixin.dart';

import 'mixin_repository_config.dart';

class NotificationRepository extends GetConnect
    with
        RepositoryErrorHandlerMixin,
        RepositorySslHandlerMixin,
        RepositoryAuthHandlerMixin,
        RepositoryConfigMixin {
  static final instance = Get.find<NotificationRepository>();

  Future<List<Notification>> find(
      {final int take = 10, final int page = 1}) async {
    final response = await get(
      "$kRestUrl/notification",
      query: {"take": take.toString(), "page": page.toString()},
    );
    if (response.isOk) {
      return (response.body as List)
          .map((data) => Notification.fromJson(data as Map<String, dynamic>))
          .toList(growable: false);
    } else {
      throw getException(response);
    }
  }

  Future<NotificationUnreadCount> getUnreadCount() async {
    final response = await get(
      "$kRestUrl/notification/unread/count",
    );
    if (response.isOk) {
      return NotificationUnreadCount.fromJson(
          response.body as Map<String, dynamic>);
    } else {
      throw getException(response);
    }
  }

  Future<void> remove(final String id) async {
    final response = await delete(
      "$kRestUrl/notification/$id",
    );
    if (!response.isOk) throw getException(response);
  }

  @override
  List<int> get certificate => [];

  @override
  Future<String> get accessToken async =>
      "Bearer ${await SessionService.instance.accessToken}";
}
