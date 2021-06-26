import 'package:json_annotation/json_annotation.dart';

part 'interest.g.dart';

@JsonSerializable( createToJson: false )
class Interest {
  @JsonKey( required: true, disallowNullValue: true )
  final int id;
  @JsonKey( required: true, disallowNullValue: true )
  final String name;
  Interest(this.id, this.name);
  factory Interest.fromJson( final Map<String, dynamic> json ) => _$InterestFromJson( json );
}