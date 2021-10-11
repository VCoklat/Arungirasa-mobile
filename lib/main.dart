import 'package:arungi_rasa/generated/fonts.gen.dart';
import 'package:arungi_rasa/generated/l10n.dart';
import 'package:arungi_rasa/initial_binding.dart';
import 'package:arungi_rasa/routes/page_router.dart';
import 'package:arungi_rasa/routes/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

part 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  runApp(const ArungiRasaApp());
}

class ArungiRasaApp extends StatelessWidget {
  const ArungiRasaApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => GetMaterialApp(
        title: "Arungi Rasa",
        localizationsDelegates: const [
          GlobalWidgetsLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          S.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        locale: const Locale("id", ""),
        theme: _themeData,
        initialBinding: InitialBinding(),
        getPages: PageRouter.instance.pages,
        initialRoute: Routes.initial,
        builder: EasyLoading.init(),
        debugShowCheckedModeBanner: false,
      );
}
