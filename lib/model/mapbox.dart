import 'package:arungi_rasa/common/enum.dart';
import 'package:arungi_rasa/model/latlng.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mapbox.g.dart';

enum MapBoxFeaturePlaceType {
  country,
  region,
  postcode,
  district,
  place,
  locality,
  neighborhood,
  address,
  poi,
}

final _mapBoxFeaturePlaceTypeValues =
    EnumValues<String, MapBoxFeaturePlaceType>({
  "country": MapBoxFeaturePlaceType.country,
  "region": MapBoxFeaturePlaceType.region,
  "postcode": MapBoxFeaturePlaceType.postcode,
  "district": MapBoxFeaturePlaceType.district,
  "place": MapBoxFeaturePlaceType.place,
  "locality": MapBoxFeaturePlaceType.locality,
  "neighborhood": MapBoxFeaturePlaceType.neighborhood,
  "address": MapBoxFeaturePlaceType.address,
  "poi": MapBoxFeaturePlaceType.poi,
});

List<String>? _separateStringNullable(final String? value) => value?.split(",");
String? _joinStringNullable(final List<String>? value) => value?.join(",");

@JsonSerializable(createToJson: false)
class MapBoxFeatureCollection {
  @JsonKey(required: true, disallowNullValue: true)
  final String type;

  @JsonKey(required: true, disallowNullValue: true)
  final List<dynamic> query;

  @JsonKey(required: true, disallowNullValue: true)
  final List<MapBoxFeature> features;

  @JsonKey(required: true, disallowNullValue: true)
  final String attribution;

  MapBoxFeatureCollection(
    this.type,
    this.query,
    this.features,
    this.attribution,
  );

  factory MapBoxFeatureCollection.empty() => MapBoxFeatureCollection(
        "FeatureCollection",
        const [],
        const [],
        "",
      );

  factory MapBoxFeatureCollection.fromJson(final Map<String, dynamic> json) =>
      _$MapBoxFeatureCollectionFromJson(json);
}

@JsonSerializable(createToJson: false)
class MapBoxFeature {
  @JsonKey(required: true, disallowNullValue: true)
  final String id;

  @JsonKey(required: true, disallowNullValue: true)
  final String type;

  @JsonKey(
    name: "place_type",
    required: true,
    disallowNullValue: true,
    fromJson: _placeTypeListFromJson,
    toJson: _placeTypeListToJson,
  )
  final List<MapBoxFeaturePlaceType> placeTypeList;

  @JsonKey(required: true, disallowNullValue: true)
  final double relevance;

  @JsonKey(required: false, disallowNullValue: false)
  final String? address;

  @JsonKey(required: true, disallowNullValue: true)
  final MapBoxFeatureProperties properties;

  @JsonKey(required: true, disallowNullValue: true)
  final String text;

  @JsonKey(name: "place_name", required: true, disallowNullValue: true)
  final String placeName;

  @JsonKey(name: "matching_text", required: false, disallowNullValue: false)
  final String? matchingText;

  @JsonKey(
      name: "matching_place_name", required: false, disallowNullValue: false)
  final String? matchingPlaceName;

  @JsonKey(required: true, disallowNullValue: true)
  final List<double> center;

  @JsonKey(required: true, disallowNullValue: true)
  final LatLng geometry;

  @JsonKey(name: "context", required: false, disallowNullValue: false)
  final List<MapBoxFeatureContext>? contextList;

  MapBoxFeature(
    this.id,
    this.type,
    this.placeTypeList,
    this.relevance,
    this.address,
    this.properties,
    this.text,
    this.placeName,
    this.matchingText,
    this.matchingPlaceName,
    this.center,
    this.geometry,
    this.contextList,
  );

  factory MapBoxFeature.fromJson(final Map<String, dynamic> json) =>
      _$MapBoxFeatureFromJson(json);

  static MapBoxFeaturePlaceType _placeTypeFromJson(final String placeType) =>
      _mapBoxFeaturePlaceTypeValues.map[placeType]!;

  static String _placeTypeToJson(final MapBoxFeaturePlaceType placeType) =>
      _mapBoxFeaturePlaceTypeValues.reverse[placeType]!;

  static List<MapBoxFeaturePlaceType> _placeTypeListFromJson(final List list) =>
      list
          .map((final placeType) => _placeTypeFromJson(placeType))
          .toList(growable: false);

  static List<String> _placeTypeListToJson(
          final List<MapBoxFeaturePlaceType> list) =>
      list
          .map((final placeType) => _placeTypeToJson(placeType))
          .toList(growable: false);
}

@JsonSerializable(createToJson: false)
class MapBoxFeatureProperties {
  @JsonKey(required: false, disallowNullValue: false)
  final String? accuracy;

  @JsonKey(required: false, disallowNullValue: false)
  final String? address;

  @JsonKey(
    required: false,
    disallowNullValue: false,
    fromJson: _separateStringNullable,
    toJson: _joinStringNullable,
  )
  final List<String>? category;

  @JsonKey(required: false, disallowNullValue: false)
  final String? maki;

  @JsonKey(required: false, disallowNullValue: false)
  final String? wikidata;

  @JsonKey(name: "short_code", required: false, disallowNullValue: false)
  final String? shortCode;

  MapBoxFeatureProperties(this.accuracy, this.address, this.category, this.maki,
      this.wikidata, this.shortCode);

  factory MapBoxFeatureProperties.fromJson(final Map<String, dynamic> json) =>
      _$MapBoxFeaturePropertiesFromJson(json);
}

@JsonSerializable(createToJson: false)
class MapBoxFeatureContext {
  @JsonKey(required: true, disallowNullValue: true)
  final String id;

  @JsonKey(required: true, disallowNullValue: true)
  final String text;

  @JsonKey(required: false, disallowNullValue: false)
  final String? wikidata;

  @JsonKey(required: false, disallowNullValue: false)
  final String? shortCode;
  MapBoxFeatureContext(this.id, this.text, this.wikidata, this.shortCode);
  factory MapBoxFeatureContext.fromJson(final Map<String, dynamic> json) =>
      _$MapBoxFeatureContextFromJson(json);
}
