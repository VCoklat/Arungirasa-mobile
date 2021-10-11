import 'package:arungi_rasa/common/config.dart';
import 'package:arungi_rasa/common/error_reporter.dart';
import 'package:arungi_rasa/generated/l10n.dart';
import 'package:arungi_rasa/model/notification.dart' as app;
import 'package:arungi_rasa/repository/notification_repository.dart';
import 'package:arungi_rasa/service/session_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

typedef _OnAddRemoveNotification = void Function(
    int index, app.Notification notification);

class _NotificationPageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<_NotificationPageController>(
        () => _NotificationPageController());
  }
}

class NotificationPage extends GetView<_NotificationPageController> {
  const NotificationPage({Key? key}) : super(key: key);
  static _NotificationPageBinding binding() => _NotificationPageBinding();
  @override
  Widget build(BuildContext context) => Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (_, __) => <Widget>[
            SliverAppBar(
              title: Text(S.current.notification),
            )
          ],
          body: Obx(
            () => EasyRefresh(
              onRefresh: controller.onRefresh,
              onLoad: controller.onLoad,
              firstRefresh: true,
              child: ListView.separated(
                itemCount: controller.itemList.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (_, index) => _NotificationTile(
                  index: index,
                  notification: controller.itemList[index],
                  onRemove: (final index, _) =>
                      controller.itemList.removeAt(index),
                  onReAdd: (final index, final notification) =>
                      controller.itemList.insert(index, notification),
                ),
              ),
            ),
          ),
        ),
      );
}

class _NotificationPageController extends GetxController {
  final itemList = RxList<app.Notification>();

  int page = 1;

  Future<void> onRefresh() async {
    try {
      page = 1;
      itemList.clear();
      await SessionService.instance.refreshData();
      final result = await NotificationRepository.instance.find(
        page: page,
        take: kItemPerPage,
      );
      itemList.addAll(result);
      page++;
    } catch (error, st) {
      ErrorReporter.instance.captureException(error, st);
      rethrow;
    }
  }

  Future<void> onLoad() async {
    try {
      final result = await NotificationRepository.instance.find(
        page: page,
        take: kItemPerPage,
      );
      itemList.addAll(result);
      page++;
    } catch (error, st) {
      ErrorReporter.instance.captureException(error, st);
      rethrow;
    }
  }
}

class _NotificationTile extends StatelessWidget {
  final int index;
  final app.Notification notification;
  final _OnAddRemoveNotification? onRemove, onReAdd;
  const _NotificationTile({
    Key? key,
    required this.index,
    required this.notification,
    this.onRemove,
    this.onReAdd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Dismissible(
        key: Key("notification_${notification.id}"),
        child: Container(
          constraints: BoxConstraints.tightFor(width: Get.width),
          child: Material(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    timeago.format(notification.date.toLocal(),
                        locale: Localizations.localeOf(context).languageCode),
                    style: const TextStyle(fontSize: 12.0),
                  ),
                  const SizedBox(height: 10.0),
                  Text(notification.content),
                ],
              ),
            ),
          ),
        ),
        background: Container(color: Theme.of(context).scaffoldBackgroundColor),
        onDismissed: (_) async {
          try {
            onRemove!(index, notification);
            await NotificationRepository.instance.remove(notification.id);
            SessionService.instance.refreshData();
          } catch (error, st) {
            Future.delayed(const Duration(milliseconds: 500),
                () => onReAdd!(index, notification));
            ErrorReporter.instance.captureException(error, st);
          }
        },
      );
}
