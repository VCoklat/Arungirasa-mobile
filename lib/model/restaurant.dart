import 'package:arungi_rasa/model/image_with_blur_hash.dart';
import 'package:arungi_rasa/model/interest.dart';
import 'package:arungi_rasa/model/latlng.dart';
import 'package:json_annotation/json_annotation.dart';

part 'restaurant.g.dart';

@JsonSerializable(createToJson: false)
class Restaurant {
  @JsonKey(required: true, disallowNullValue: true)
  final int id;

  @JsonKey(required: true, disallowNullValue: true)
  final String name;

  @JsonKey(required: true, disallowNullValue: true)
  final LatLng latLng;

  @JsonKey(required: true, disallowNullValue: true)
  final List<ImageWithBlurHash> imageList;

  @JsonKey(required: true, disallowNullValue: true)
  final List<Interest> interestList;

  Restaurant(
      this.id, this.name, this.latLng, this.imageList, this.interestList);
  factory Restaurant.fromJson(final Map<String, dynamic> json) =>
      _$RestaurantFromJson(json);

  RestaurantRef get ref => new RestaurantRef(id)..value = this;
}

class RestaurantRef {
  final int id;
  Restaurant? value;
  RestaurantRef(this.id);
  factory RestaurantRef.fromId(final int id) => new RestaurantRef(id);
  static RestaurantRef fromJson(final int id) => RestaurantRef.fromId(id);
  static int toJson(final RestaurantRef ref) => ref.id;
  @override
  int get hashCode => id.hashCode;
  @override
  bool operator ==(other) {
    if (other is int)
      return id == other;
    else if (other is RestaurantRef)
      return id == other.id;
    else if (other is Restaurant)
      return id == other.id;
    else
      return false;
  }
}
