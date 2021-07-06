class LatLng {
  final double lat;
  final double lng;
  const LatLng({ required this.lat, required this.lng });
  factory LatLng.fromJson( final Map<String, dynamic> json ) {
    ArgumentError.checkNotNull( json, "LatLng json map" );
    if ( json.containsKey("type") && json["type"] == "Point" ) {
      if ( json.containsKey("coordinates") && json["coordinates"] is List ) {
        return new LatLng(
            lat: json["coordinates"][1] is String ? num.parse( json["coordinates"][1] ).toDouble() : ( json["coordinates"][1] as num ).toDouble(),
            lng: json["coordinates"][0] is String ? num.parse( json["coordinates"][0] ).toDouble() : ( json["coordinates"][0] as num ).toDouble() );
      } else throw new ArgumentError( "Type point missing field coordinates or is not array!" );
    } else throw new ArgumentError( "GeoJson is not point!" );
  }

  Map<String, dynamic> toJson() {
    return {
      "type": "Point",
      "coordinates": [ lng, lat, ],
    };
  }
}