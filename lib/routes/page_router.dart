import 'package:arungi_rasa/routes/routes.dart';
import 'package:arungi_rasa/view/auth/sign_in_page.dart';
import 'package:arungi_rasa/view/intro_page.dart';
import 'package:arungi_rasa/view/main_page/main_page.dart';
import 'package:arungi_rasa/view/splash_screen.dart';
import 'package:get/get.dart';

class PageRouter {
  static final PageRouter instance = new PageRouter._internal();
  PageRouter._internal();

  List<GetPage> get pages => <GetPage>[
    new GetPage( name: Routes.initial, page: () => const SplashScreenPage(), ),
    new GetPage( name: Routes.signIn, page: () => const SignInPage(), binding: new SignInPageBindings() ),
    new GetPage( name: Routes.intro, page: () => const IntroPage(), binding: new IntroPageBinding() ),
    new GetPage( name: Routes.home, page: () => const MainPage(), binding: new MainPageBinding() ),
  ];
}
