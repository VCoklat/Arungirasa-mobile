import 'package:arungi_rasa/common/config.dart';
import 'package:arungi_rasa/model/interest.dart';
import 'package:arungi_rasa/repository/common/repository_error_handler_mixin.dart';
import 'package:arungi_rasa/repository/common/repository_ssl_handler_mixin.dart';
import 'package:get/get.dart';

class InterestRepository extends GetConnect with RepositorySslHandlerMixin, RepositoryErrorHandlerMixin {
  static InterestRepository get instance => Get.find<InterestRepository>();
  Future<List<Interest>> find() async {
    final response = await get( "$kRestUrl/interest" );
    if ( response.isOk )
      return ( response.body as List ).map( (e) => Interest.fromJson( e as Map<String, dynamic> ) ).toList( growable: false );
    else
      throw getException( response );
  }
}