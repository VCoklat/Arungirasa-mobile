import 'package:arungi_rasa/repository/auth_repository.dart';
import 'package:arungi_rasa/repository/interest_repository.dart';
import 'package:arungi_rasa/repository/restaurant_repository.dart';
import 'package:arungi_rasa/service/session_service.dart';
import 'package:get/get.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.put( new SessionService(), permanent: true );

    ///Repository
    Get.put( new AuthRepository(), permanent: true );
    Get.put( new InterestRepository(), permanent: true );
    Get.put( new RestaurantRepository(), permanent: true );
  }
}