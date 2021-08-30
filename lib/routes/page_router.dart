import 'package:arungi_rasa/routes/routes.dart';
import 'package:arungi_rasa/service/session_service.dart';
import 'package:arungi_rasa/view/address/address_create_form.dart';
import 'package:arungi_rasa/view/address/address_list_page.dart';
import 'package:arungi_rasa/view/auth/sign_in_page.dart';
import 'package:arungi_rasa/view/auth/sign_up_page.dart';
import 'package:arungi_rasa/view/cart/cart_page.dart';
import 'package:arungi_rasa/view/intro_page.dart';
import 'package:arungi_rasa/view/main_page/main_page.dart';
import 'package:arungi_rasa/view/order/make_order_page.dart';
import 'package:arungi_rasa/view/order/page/order_page.dart';
import 'package:arungi_rasa/view/profile/profile_page.dart';
import 'package:arungi_rasa/view/profile/wishlist_page.dart';
import 'package:arungi_rasa/view/rating/give_order_rating_page.dart';
import 'package:arungi_rasa/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageRouter {
  static final PageRouter instance = new PageRouter._internal();
  PageRouter._internal();

  List<GetPage> get pages => <GetPage>[
        new GetPage(
          name: Routes.initial,
          page: () => const SplashScreenPage(),
        ),
        new GetPage(
          name: Routes.signIn,
          page: () => const SignInPage(),
          binding: new SignInPageBindings(),
        ),
        new GetPage(
          name: Routes.signUp,
          page: () => const SignUpPage(),
          binding: new SignUpPageBindings(),
        ),
        new GetPage(
          name: Routes.intro,
          page: () => const IntroPage(),
          binding: new IntroPageBinding(),
        ),
        new GetPage(
          name: Routes.home,
          page: () => const MainPage(),
          binding: new MainPageBinding(),
          middlewares: [
            new _AuthGuardMiddleWare(),
          ],
        ),
        new GetPage(
          name: Routes.cart,
          page: () => const CartPage(),
          binding: CartPage.binding(),
          middlewares: [
            new _AuthGuardMiddleWare(),
          ],
        ),
        new GetPage(
          name: Routes.profile,
          page: () => const ProfilePage(),
          middlewares: [
            new _AuthGuardMiddleWare(),
          ],
        ),
        new GetPage(
          name: Routes.address,
          page: () => const AddressListPage(),
          middlewares: [
            new _AuthGuardMiddleWare(),
          ],
        ),
        new GetPage(
          name: Routes.addAddress,
          page: () => const AddressCreateFormPage(),
          binding: AddressCreateFormPage.binding(),
          middlewares: [
            new _AuthGuardMiddleWare(),
          ],
        ),
        new GetPage(
          name: Routes.makeOrder,
          page: () => const MakeOrderPage(),
          binding: MakeOrderPage.binding(),
          middlewares: [
            new _AuthGuardMiddleWare(),
          ],
        ),
        new GetPage(
          name: Routes.order,
          page: () => const OrderPage(),
          binding: OrderPage.binding(),
          middlewares: [
            new _AuthGuardMiddleWare(),
          ],
        ),
        new GetPage(
          name: Routes.wishList,
          page: () => const WishListPage(),
          binding: WishListPage.binding(),
          middlewares: [
            new _AuthGuardMiddleWare(),
          ],
        ),
        new GetPage(
          name: Routes.giveOrderRatingRoute,
          page: () => const GiveOrderRatingPage(),
          binding: GiveOrderRatingPage.binding(),
          middlewares: [
            new _AuthGuardMiddleWare(),
          ],
        ),
      ];
}

class _AuthGuardMiddleWare extends GetMiddleware {
  @override
  RouteSettings? redirect(final String? route) {
    if (SessionService.instance.hasSession) {
      return null;
    } else
      return new RouteSettings(
        name: Routes.signIn,
      );
  }
}
