import 'package:json_annotation/json_annotation.dart';

part 'env.g.dart';

// ignore: invalid_annotation_target
@JsonLiteral("env.json", asConst: true)
final Map<String, dynamic> _env = _$_envJsonLiteral;

@JsonSerializable(createToJson: false)
class Env {
  @JsonKey(required: true, disallowNullValue: true)
  final String mapBoxAccessToken;
  @JsonKey(required: true, disallowNullValue: true)
  final String directChatLink;
  Env(this.mapBoxAccessToken, this.directChatLink);
  factory Env.fromJson(final Map<String, dynamic> json) => _$EnvFromJson(json);
}

final Env env = Env.fromJson(_env);
