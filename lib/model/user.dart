import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable( createToJson: false )
class User {
  @JsonKey( required: true, disallowNullValue: true )
  final String id;

  @JsonKey( required: true, disallowNullValue: true )
  final String uid;

  @JsonKey( required: false, disallowNullValue: false, defaultValue: false )
  final bool isAdmin;

  @JsonKey( required: false, disallowNullValue: false )
  final String? email;

  @JsonKey( required: false, disallowNullValue: false, defaultValue: false )
  final bool emailVerified;

  @JsonKey( required: false, disallowNullValue: false, defaultValue: "" )
  final String displayName;

  @JsonKey( required: false, disallowNullValue: false, defaultValue: "" )
  final String phoneNumber;

  @JsonKey( required: false, disallowNullValue: false )
  final String? photoURL;

  @JsonKey( required: false, disallowNullValue: false, defaultValue: false )
  final bool disabled;

  User({
    required this.id, required this.uid, required this.isAdmin, this.email,
    required this.emailVerified, required this.displayName, required this.phoneNumber,
    this.photoURL, required this.disabled,
  });

  factory User.fromJson( final Map<String, dynamic> json ) => _$UserFromJson( json );
  UserRef get ref => new UserRef( id );
}

class UserRef {
  final String id;
  User? value;
  UserRef(this.id);
  factory UserRef.fromId( final String id ) => new UserRef( id );
  static UserRef fromJson( final String id) => UserRef.fromId(id);
  static String toJson( final UserRef ref ) => ref.id;
  @override int get hashCode => id.hashCode;
  @override
  bool operator ==(other) {
    if ( other is String ) return id == other;
    else if ( other is UserRef ) return id == other.id;
    else if ( other is User ) return id == other.id;
    else return false;
  }
}

@JsonSerializable( includeIfNull: false )
class SignUp {
  @JsonKey( required: true, disallowNullValue: true )
  final String email;

  @JsonKey( required: true, disallowNullValue: true )
  final String phoneNumber;

  @JsonKey( required: true, disallowNullValue: true )
  final String displayName;

  @JsonKey( required: false, disallowNullValue: false )
  final String? photoUrl;

  @JsonKey( required: true, disallowNullValue: true )
  final String password;

  @JsonKey( required: true, disallowNullValue: true )
  final List<int> interestList;

  SignUp({
    required this.email,
    required this.phoneNumber,
    required this.displayName,
    this.photoUrl,
    required this.password,
    required this.interestList,
  });

  factory SignUp.fromJson( final Map<String, dynamic> json ) => _$SignUpFromJson( json );
  Map<String, dynamic> toJson() => _$SignUpToJson( this );
}
