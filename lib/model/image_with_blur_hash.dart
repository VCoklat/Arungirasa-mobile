import 'package:json_annotation/json_annotation.dart';

part 'image_with_blur_hash.g.dart';

@JsonSerializable()
class ImageWithBlurHash {

  @JsonKey( required: true, disallowNullValue: true )
  final String url;

  @JsonKey( required: true, disallowNullValue: true )
  final String blurhash;

  ImageWithBlurHash(this.url, this.blurhash);

  factory ImageWithBlurHash.fromJson( final Map<String, dynamic> json ) => _$ImageWithBlurHashFromJson( json );
  Map<String, dynamic> toJson() => _$ImageWithBlurHashToJson(this);
}