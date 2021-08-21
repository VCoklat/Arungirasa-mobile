import 'package:arungi_rasa/model/latlng.dart';
import 'package:json_annotation/json_annotation.dart';

part 'address.g.dart';

@JsonSerializable(includeIfNull: false)
class CreateUpdateAddress {
  @JsonKey(required: true, disallowNullValue: true)
  final String name;

  @JsonKey(required: true, disallowNullValue: true)
  final double latitude;

  @JsonKey(required: true, disallowNullValue: true)
  final double longitude;

  @JsonKey(required: true, disallowNullValue: false)
  final String? detail;

  @JsonKey(required: true, disallowNullValue: false)
  final String? note;

  @JsonKey(required: true, disallowNullValue: false)
  final String? contactName;

  @JsonKey(required: true, disallowNullValue: false)
  final String? contactNumber;

  CreateUpdateAddress({
    required this.name,
    required this.latitude,
    required this.longitude,
    this.detail = "",
    this.note = "",
    this.contactName = "",
    this.contactNumber = "",
  });

  factory CreateUpdateAddress.fromJson(final Map<String, dynamic> json) =>
      _$CreateUpdateAddressFromJson(json);

  Map<String, dynamic> toJson() => _$CreateUpdateAddressToJson(this);
}

@JsonSerializable()
class Address {
  @JsonKey(required: true, disallowNullValue: true)
  final String id;

  @JsonKey(required: true, disallowNullValue: true)
  final String name;

  @JsonKey(required: true, disallowNullValue: true)
  final LatLng latLng;

  @JsonKey(required: true, disallowNullValue: false)
  final String? detail;

  @JsonKey(required: true, disallowNullValue: false)
  final String? note;

  @JsonKey(required: true, disallowNullValue: false)
  final String? contactName;

  @JsonKey(required: true, disallowNullValue: false)
  final String? contactNumber;

  Address(this.id, this.name, this.latLng, this.detail, this.note,
      this.contactName, this.contactNumber);

  factory Address.fromJson(final Map<String, dynamic> json) =>
      _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);
}
