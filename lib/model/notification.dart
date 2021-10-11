import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

@JsonSerializable(createToJson: false)
class Notification {
  @JsonKey(required: true, disallowNullValue: true)
  final String id;

  @JsonKey(required: true, disallowNullValue: true)
  final String title;

  @JsonKey(required: true, disallowNullValue: true)
  final String content;

  @JsonKey(required: true, disallowNullValue: true)
  final DateTime date;

  const Notification(this.id, this.title, this.content, this.date);
  factory Notification.fromJson(final Map<String, dynamic> json) =>
      _$NotificationFromJson(json);
}

@JsonSerializable(createToJson: false)
class NotificationUnreadCount {
  @JsonKey(required: false, disallowNullValue: false, defaultValue: 0)
  final int? count;
  const NotificationUnreadCount([this.count = 0]);
  factory NotificationUnreadCount.fromJson(final Map<String, dynamic> json) =>
      _$NotificationUnreadCountFromJson(json);
}
