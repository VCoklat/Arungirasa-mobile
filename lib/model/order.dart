import 'package:arungi_rasa/common/enum.dart';
import 'package:arungi_rasa/model/address.dart';
import 'package:arungi_rasa/model/food_drink_menu.dart';
import 'package:arungi_rasa/model/payment.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order.g.dart';

enum OrderStatus {
  unpaid,
  awaitingConfirmation,
  onProcess,
  sent,
  arrived,
  complained,
  cancelled,
}

final orderStatusValues = EnumValues<String, OrderStatus>({
  "Unpaid": OrderStatus.unpaid,
  "Confirm": OrderStatus.awaitingConfirmation,
  "Process": OrderStatus.onProcess,
  "Sent": OrderStatus.sent,
  "Arrived": OrderStatus.arrived,
  "Complained": OrderStatus.complained,
  "Cancelled": OrderStatus.cancelled,
});

OrderStatus _orderStatusFromJson(final String type) =>
    orderStatusValues.map[type]!;
String _orderStatusToJson(final OrderStatus type) =>
    orderStatusValues.reverse[type]!;

@JsonSerializable(createToJson: false)
class OrderMenu {
  final String note;
  final FoodDrinkMenu menu;
  OrderMenu(this.note, this.menu);
  factory OrderMenu.fromJson(final Map<String, dynamic> json) =>
      _$OrderMenuFromJson(json);
}

@JsonSerializable(createToJson: false)
class Order {
  @JsonKey(required: true, disallowNullValue: true)
  final String id;

  @JsonKey(required: true, disallowNullValue: true)
  final String reference;

  @JsonKey(required: true, disallowNullValue: true)
  final List<OrderMenu> menuList;

  @JsonKey(
    required: true,
    disallowNullValue: true,
    fromJson: _orderStatusFromJson,
    toJson: _orderStatusToJson,
  )
  final OrderStatus status;

  @JsonKey(required: true, disallowNullValue: true)
  final int transportFee;

  @JsonKey(required: true, disallowNullValue: true)
  final int appFee;

  @JsonKey(required: true, disallowNullValue: true)
  final int discount;

  @JsonKey(required: true, disallowNullValue: true)
  final Address address;

  @JsonKey(required: true, disallowNullValue: true)
  final List<Payment> paymentList;
  Order(this.id, this.reference, this.menuList, this.status, this.transportFee,
      this.appFee, this.discount, this.address, this.paymentList);
  factory Order.fromJson(final Map<String, dynamic> json) =>
      _$OrderFromJson(json);
}
