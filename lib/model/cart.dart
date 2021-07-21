import 'package:arungi_rasa/model/food_drink_menu.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cart.g.dart';

@JsonSerializable(createToJson: false)
class Cart {
  @JsonKey(required: true, disallowNullValue: true)
  final String uuid;

  @JsonKey(
      name: "menuId",
      required: true,
      disallowNullValue: true,
      fromJson: FoodDrinkMenuRef.fromJson,
      toJson: FoodDrinkMenuRef.toJson)
  final FoodDrinkMenuRef menuRef;

  @JsonKey(required: true, disallowNullValue: true)
  final int qty;

  Cart(this.uuid, this.menuRef, this.qty);

  factory Cart.fromJson(final Map<String, dynamic> json) =>
      _$CartFromJson(json);
}
