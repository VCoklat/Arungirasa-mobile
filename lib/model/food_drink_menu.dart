import 'package:arungi_rasa/model/restaurant.dart';
import 'package:json_annotation/json_annotation.dart';

import 'image_with_blur_hash.dart';

part 'food_drink_menu.g.dart';

@JsonSerializable()
class FoodDrinkMenu {
  @JsonKey(required: true, disallowNullValue: true)
  final int id;

  @JsonKey(required: true, disallowNullValue: true)
  final String name;

  @JsonKey(required: false, disallowNullValue: false, defaultValue: "")
  final String description;

  @JsonKey(required: true, disallowNullValue: true)
  final int price;

  @JsonKey(required: true, disallowNullValue: true)
  final List<ImageWithBlurHash> imageList;

  @JsonKey(required: true, disallowNullValue: true)
  final Restaurant restaurant;

  FoodDrinkMenu({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageList,
    required this.restaurant,
  });

  factory FoodDrinkMenu.fromJson(final Map<String, dynamic> json) =>
      _$FoodDrinkMenuFromJson(json);

  Map<String, dynamic> toJson() => _$FoodDrinkMenuToJson(this);

  @override
  bool operator ==(final other) {
    if (other is int)
      return id == other;
    else if (other is FoodDrinkMenu)
      return id == other.id;
    else
      return false;
  }

  @override
  int get hashCode => id.hashCode;
  FoodDrinkMenuRef get ref => new FoodDrinkMenuRef(id)..value = this;
}

class FoodDrinkMenuRef {
  final int id;
  FoodDrinkMenu? value;
  FoodDrinkMenuRef(this.id);
  factory FoodDrinkMenuRef.fromId(final int id) => new FoodDrinkMenuRef(id);
  static FoodDrinkMenuRef fromJson(final int id) => FoodDrinkMenuRef.fromId(id);
  static int toJson(final FoodDrinkMenuRef ref) => ref.id;
  @override
  int get hashCode => id.hashCode;
  @override
  bool operator ==(other) {
    if (other is int)
      return id == other;
    else if (other is FoodDrinkMenuRef)
      return id == other.id;
    else if (other is FoodDrinkMenu)
      return id == other.id;
    else
      return false;
  }
}
