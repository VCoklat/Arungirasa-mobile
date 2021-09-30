import 'package:arungi_rasa/repository/address_repository.dart';
import 'package:arungi_rasa/repository/auth_repository.dart';
import 'package:arungi_rasa/repository/cart_repository.dart';
import 'package:arungi_rasa/repository/interest_repository.dart';
import 'package:arungi_rasa/repository/mapbox_repository.dart';
import 'package:arungi_rasa/repository/menu_repository.dart';
import 'package:arungi_rasa/repository/order_repository.dart';
import 'package:arungi_rasa/repository/payment_repository.dart';
import 'package:arungi_rasa/repository/rating_repository.dart';
import 'package:arungi_rasa/repository/restaurant_repository.dart';
import 'package:arungi_rasa/repository/user_repository.dart';
import 'package:arungi_rasa/repository/wishlist_repository.dart';
import 'package:arungi_rasa/service/address_service.dart';
import 'package:arungi_rasa/service/cart_service.dart';
import 'package:arungi_rasa/service/order_service.dart';
import 'package:arungi_rasa/service/session_service.dart';
import 'package:arungi_rasa/service/wistlist_service.dart';
import 'package:get/get.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(SessionService(), permanent: true);
    Get.put(CartService(), permanent: true);
    Get.put(AddressService(), permanent: true);
    Get.put(OrderService(), permanent: true);
    Get.put(WishListService(), permanent: true);

    ///Repository
    Get.put(AddressRepository(), permanent: true);
    Get.put(AuthRepository(), permanent: true);
    Get.put(CartRepository(), permanent: true);
    Get.put(FoodDrinkMenuRepository(), permanent: true);
    Get.put(InterestRepository(), permanent: true);
    Get.put(MapBoxRepository(), permanent: true);
    Get.put(OrderRepository(), permanent: true);
    Get.put(PaymentRepository(), permanent: true);
    Get.put(RatingRepository(), permanent: true);
    Get.put(RestaurantRepository(), permanent: true);
    Get.put(UserRepository(), permanent: true);
    Get.put(WishListRepository(), permanent: true);
  }
}
