import 'package:arungi_rasa/model/image_with_blur_hash.dart';
import 'package:arungi_rasa/model/interest.dart';
import 'package:arungi_rasa/model/latlng.dart';
import 'package:json_annotation/json_annotation.dart';

part 'restaurant.g.dart';

@JsonSerializable( createToJson: false )
class Restaurant {
  @JsonKey( required: true, disallowNullValue: true )
  final int id;

  @JsonKey( required: true, disallowNullValue: true )
  final String name;

  @JsonKey( required: true, disallowNullValue: true )
  final LatLng latLng;

  @JsonKey( required: true, disallowNullValue: true )
  final List<ImageWithBlurHash> imageList;

  @JsonKey( required: true, disallowNullValue: true )
  final List<Interest> interestList;

  Restaurant(this.id, this.name, this.latLng, this.imageList, this.interestList);
  factory Restaurant.fromJson( final Map<String, dynamic> json ) => _$RestaurantFromJson( json );
}