import 'package:arungi_rasa/routes/routes.dart';
import 'package:arungi_rasa/service/session_service.dart';
import 'package:arungi_rasa/view/address/address_create_form.dart';
import 'package:arungi_rasa/view/address/address_list_page.dart';
import 'package:arungi_rasa/view/auth/forget_password.dart';
import 'package:arungi_rasa/view/auth/sign_in_page.dart';
import 'package:arungi_rasa/view/auth/sign_up_page.dart';
import 'package:arungi_rasa/view/cart/cart_page.dart';
import 'package:arungi_rasa/view/chat_page.dart';
import 'package:arungi_rasa/view/intro_page.dart';
import 'package:arungi_rasa/view/main_page/main_page.dart';
import 'package:arungi_rasa/view/order/create/create_order_page.dart';
import 'package:arungi_rasa/view/order/order_list_page.dart';
import 'package:arungi_rasa/view/order/page/order_page.dart';
import 'package:arungi_rasa/view/profile/change_password.dart';
import 'package:arungi_rasa/view/profile/change_profile.dart';
import 'package:arungi_rasa/view/profile/profile_page.dart';
import 'package:arungi_rasa/view/profile/wishlist_page.dart';
import 'package:arungi_rasa/view/rating/give_order_rating_page.dart';
import 'package:arungi_rasa/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageRouter {
  static final PageRouter instance = PageRouter._internal();
  PageRouter._internal();

  List<GetPage> get pages => <GetPage>[
        GetPage(
          name: Routes.initial,
          page: () => const SplashScreenPage(),
        ),
        GetPage(
          name: Routes.signIn,
          page: () => const SignInPage(),
          binding: SignInPageBindings(),
        ),
        GetPage(
          name: Routes.signUp,
          page: () => const SignUpPage(),
          binding: SignUpPageBindings(),
        ),
        GetPage(
          name: Routes.resetPassword,
          page: () => const ForgetPassword(),
          binding: ForgetPassword.binding(),
        ),
        GetPage(
          name: Routes.intro,
          page: () => const IntroPage(),
          binding: IntroPageBinding(),
        ),
        GetPage(
          name: Routes.home,
          page: () => const MainPage(),
          binding: MainPageBinding(),
          middlewares: [_AuthGuardMiddleWare()],
        ),
        GetPage(
          name: Routes.cart,
          page: () => const CartPage(),
          binding: CartPage.binding(),
          middlewares: [_AuthGuardMiddleWare()],
        ),
        GetPage(
          name: Routes.profile,
          page: () => const ProfilePage(),
          middlewares: [_AuthGuardMiddleWare()],
        ),
        GetPage(
          name: Routes.address,
          page: () => const AddressListPage(),
          middlewares: [_AuthGuardMiddleWare()],
        ),
        GetPage(
          name: Routes.addAddress,
          page: () => const AddressCreateFormPage(),
          binding: AddressCreateFormPage.binding(),
          middlewares: [_AuthGuardMiddleWare()],
        ),
        GetPage(
          name: Routes.makeOrder,
          page: () => const CreateOrderPage(),
          binding: CreateOrderPage.binding(),
          middlewares: [_AuthGuardMiddleWare()],
        ),
        GetPage(
          name: Routes.orderList,
          page: () => const OrderListPage(),
          binding: OrderListPage.binding(),
          middlewares: [_AuthGuardMiddleWare()],
        ),
        GetPage(
          name: Routes.order,
          page: () => const OrderPage(),
          binding: OrderPage.binding(),
          middlewares: [_AuthGuardMiddleWare()],
        ),
        GetPage(
          name: Routes.wishList,
          page: () => const WishListPage(),
          binding: WishListPage.binding(),
          middlewares: [_AuthGuardMiddleWare()],
        ),
        GetPage(
          name: Routes.giveOrderRatingRoute,
          page: () => const GiveOrderRatingPage(),
          binding: GiveOrderRatingPage.binding(),
          middlewares: [_AuthGuardMiddleWare()],
        ),
        GetPage(
          name: Routes.profileUpdate,
          page: () => const ChangeProfilePage(),
          binding: ChangeProfilePage.binding(),
          middlewares: [_AuthGuardMiddleWare()],
        ),
        GetPage(
          name: Routes.changePassword,
          page: () => const ChangePasswordPage(),
          binding: ChangePasswordPage.binding(),
          middlewares: [_AuthGuardMiddleWare()],
        ),
        GetPage(
          name: Routes.chat,
          page: () => const ChatPage(),
          middlewares: [_AuthGuardMiddleWare()],
        ),
      ];
}

class _AuthGuardMiddleWare extends GetMiddleware {
  @override
  RouteSettings? redirect(final String? route) {
    if (SessionService.instance.hasSession) {
      return null;
    } else {
      return const RouteSettings(
        name: Routes.signIn,
      );
    }
  }
}
