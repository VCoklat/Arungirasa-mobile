import 'package:arungi_rasa/service/session_service.dart';
import 'package:get/get.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.put( new SessionService(), permanent: true );
  }
}