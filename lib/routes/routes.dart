import 'package:get/get.dart';

class Routes {
  static const String initial = "/";
  static const String intro = "/intro";
  static const String signIn = "/signin";
  static const String signUp = "/signup";
  static const String resetPassword = "/resetpassword";
  static const String home = "/home";
  static const String cart = "/cart";
  static const String profile = "/profile";
  static const String profileUpdate = "/profile/update";
  static const String address = "/address";
  static const String addAddress = "/address/add";
  static const String makeOrder = "/order/make";
  static const String wishList = "/wishlist";
  static const String orderList = "/order";
  static const String order = "/order/:orderId";
  static const String giveOrderRatingRoute = "/rating/order/:orderId";
  static const String changePassword = "/changepassword";
  static const String chat = "/chat";

  static openOrder(final String id) => Get.toNamed("/order/$id");
  static giveOrderRating(final String id) => Get.toNamed("/rating/order/$id");
}
