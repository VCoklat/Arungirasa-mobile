import 'package:arungi_rasa/common/config.dart';
import 'package:arungi_rasa/model/user.dart';
import 'package:arungi_rasa/repository/common/repository_error_handler_mixin.dart';
import 'package:arungi_rasa/repository/common/repository_ssl_handler_mixin.dart';
import 'package:get/get.dart';

class AuthRepository extends GetConnect with RepositorySslHandlerMixin, RepositoryErrorHandlerMixin {
  static AuthRepository get instance => Get.find<AuthRepository>();
  Future<User> signUp( final SignUp body ) async {
    final response = await post( "$kRestUrl/user/signup", body.toJson() );
    if ( response.isOk )
      return User.fromJson( response.body as Map<String, dynamic> );
    else
      throw getException( response );
  }
}