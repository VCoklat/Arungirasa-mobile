import 'package:arungi_rasa/model/image_with_blur_hash.dart';
import 'package:arungi_rasa/model/interest.dart';
import 'package:arungi_rasa/model/latlng.dart';
import 'package:json_annotation/json_annotation.dart';

part 'restaurant.g.dart';

@JsonSerializable()
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

  @JsonKey(required: false, disallowNullValue: false, defaultValue: .0)
  final double rating;

  @JsonKey(required: false, disallowNullValue: false, defaultValue: 8000)
  final int transportFee;

  @JsonKey(required: false, disallowNullValue: false, defaultValue: 2000)
  final int appFee;

  Restaurant(
    this.id,
    this.name,
    this.latLng,
    this.imageList,
    this.interestList,
    this.rating,
    this.transportFee,
    this.appFee,
  );
  factory Restaurant.fromJson(final Map<String, dynamic> json) =>
      _$RestaurantFromJson(json);
  Map<String, dynamic> toJson() => _$RestaurantToJson(this);

  RestaurantRef get ref => RestaurantRef(id)..value = this;
}

class RestaurantRef {
  final int id;
  Restaurant? value;
  RestaurantRef(this.id);
  factory RestaurantRef.fromId(final int id) => RestaurantRef(id);
  static RestaurantRef fromJson(final int id) => RestaurantRef.fromId(id);
  static int toJson(final RestaurantRef ref) => ref.id;
  @override
  int get hashCode => id.hashCode;
  @override
  bool operator ==(other) {
    if (other is int) {
      return id == other;
    } else if (other is RestaurantRef) {
      return id == other.id;
    } else if (other is Restaurant) {
      return id == other.id;
    } else {
      return false;
    }
  }
}
