import 'package:arungi_rasa/model/order.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rating.g.dart';

@JsonSerializable(createToJson: false)
class Rating {
  @JsonKey(required: true, disallowNullValue: true)
  final Order order;

  @JsonKey(required: true, disallowNullValue: true)
  final double rating;
  Rating(this.order, this.rating);
  factory Rating.fromJson(final Map<String, dynamic> json) =>
      _$RatingFromJson(json);
}
