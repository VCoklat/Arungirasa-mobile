import 'package:json_annotation/json_annotation.dart';

import 'image_with_blur_hash.dart';

part 'food_drink_menu.g.dart';

@JsonSerializable()
class FoodDrinkMenu {
  @JsonKey( required: true, disallowNullValue: true )
  final String id;

  @JsonKey( required: true, disallowNullValue: true )
  final String name;

  @JsonKey( required: false, disallowNullValue: false, defaultValue: "" )
  final String description;

  @JsonKey( required: true, disallowNullValue: true )
  final int price;

  @JsonKey( required: true, disallowNullValue: true )
  final List<ImageWithBlurHash> imageList;

  FoodDrinkMenu({
    required this.id, required this.name, required this.description,
    required this.price, required this.imageList,
  });

  factory FoodDrinkMenu.fromJson( final Map<String, dynamic> json ) => _$FoodDrinkMenuFromJson( json );

  @override
  bool operator==( final other ) {
    if ( other is String ) return id == other;
    else if ( other is FoodDrinkMenu ) return id == other.id;
    else return false;
  }

  @override int get hashCode => id.hashCode;

}