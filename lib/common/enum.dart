abstract class Enum<T> {
  final T _value;
  const Enum(this._value);
  T get value => _value;
  T toJson() => _value;
}

class EnumValues<Key, Value> {
  Map<Key, Value> map;
  Map<Value, Key> reverse;
  EnumValues(this.map) : reverse = map.map((k, v) => MapEntry(v, k));
  Value? toJson( final Key key ) => map[key];
  Key? fromJson( final Value value ) => reverse[value];
}