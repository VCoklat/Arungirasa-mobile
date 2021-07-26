import 'package:arungi_rasa/model/food_drink_menu.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cart.g.dart';

@JsonSerializable(createToJson: false)
class Cart {
  @JsonKey(required: true, disallowNullValue: true)
  final String uuid;

  @JsonKey(
    name: "menu",
    required: true,
    disallowNullValue: true,
  )
  final FoodDrinkMenu menu;

  @JsonKey(required: true, disallowNullValue: true)
  final int qty;

  @JsonKey(required: true, disallowNullValue: true)
  final int price;

  Cart(this.uuid, this.menu, this.qty, this.price);

  factory Cart.fromJson(final Map<String, dynamic> json) =>
      _$CartFromJson(json);

  Cart updateQty(final int qty) =>
      new Cart(this.uuid, this.menu, qty, this.price);
}
