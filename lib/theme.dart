part of 'main.dart';

final _themeData = new ThemeData(
  fontFamily: FontFamily.gothamHTF,
  scaffoldBackgroundColor: const Color(0XFFEEEEEE),
  primaryColor: const Color(0XFF12676D),
  primaryColorDark: const Color(0XFF12676D),
  primaryColorLight: const Color(0XFF12676D),
  primaryIconTheme: const IconThemeData(
    color: Colors.white,
  ),
  iconTheme: const IconThemeData(
    color: const Color(0XFF4DB6AC),
  ),
  primaryTextTheme: const TextTheme(
    headline6: const TextStyle(
      color: Colors.white,
    ),
    button: const TextStyle(
      color: Colors.white,
    ),
  ),
  textTheme: const TextTheme(
    headline6: const TextStyle(
      fontSize: 24,
    ),
    bodyText2: const TextStyle(
      fontSize: 18.0,
    ),
  ),
  accentColor: const Color(0XFF12676D),
  accentIconTheme: IconThemeData(
    color: Colors.white,
  ),
  bottomAppBarColor: const Color(0XFF45A39A),
  indicatorColor: Colors.white,
  tabBarTheme: const TabBarTheme(
    labelColor: Colors.white,
  ),
  primaryColorBrightness: Brightness.dark,
  inputDecorationTheme: const InputDecorationTheme(
    focusedBorder: const UnderlineInputBorder( borderSide: const BorderSide( color: const Color(0XFF12676D) ) ),
    border: const UnderlineInputBorder( borderSide: const BorderSide( color: const Color(0XFF12676D) ) ),
    labelStyle: const TextStyle(
      color: const Color(0XFF12676D),
    ),
    prefixStyle: const TextStyle(
      color: const Color(0XFF12676D),
    ),
    suffixStyle: const TextStyle(
      color: const Color(0XFF12676D),
    ),
  ),
  chipTheme: new ChipThemeData(
    backgroundColor: const Color(0XFF4DB6AC),
    labelStyle: const TextStyle(
      color: Colors.white,
    ),
    brightness: Brightness.dark,
    shape: StadiumBorder(),
    selectedColor: const Color(0XFF357F78),
    disabledColor: (const Color(0XFF4DB6AC)).withAlpha(150),
    padding: const EdgeInsets.all(4.0),
    labelPadding: EdgeInsets.symmetric(horizontal: 8.0),
    deleteIconColor: Colors.redAccent,
    secondaryLabelStyle: const TextStyle(
      color: Colors.white70,
    ),
    secondarySelectedColor: const Color(0XFF1E4844),
  ),
  cardColor: Colors.white,
);