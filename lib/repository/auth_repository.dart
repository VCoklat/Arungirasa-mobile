import 'package:arungi_rasa/common/config.dart';
import 'package:arungi_rasa/model/user.dart';
import 'package:get/get.dart';
import 'package:get_connect_repo_mixin/get_connect_repo_mixin.dart';

class AuthRepository extends GetConnect with RepositorySslHandlerMixin, RepositoryErrorHandlerMixin {
  static AuthRepository get instance => Get.find<AuthRepository>();
  Future<User> signUp( final SignUp body ) async {
    final response = await post( "$kRestUrl/user/signup", body.toJson() );
    if ( response.isOk )
      return User.fromJson( response.body as Map<String, dynamic> );
    else
      throw getException( response );
  }

  @override List<int> get certificate => const [];
}