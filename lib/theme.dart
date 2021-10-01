part of 'main.dart';

final _themeData = ThemeData(
  fontFamily: FontFamily.gothamHTF,
  scaffoldBackgroundColor: const Color(0XFFEEEEEE),
  primaryColor: const Color(0XFF12676D),
  primaryColorDark: const Color(0XFF12676D),
  primaryColorLight: const Color(0XFF12676D),
  primaryIconTheme: const IconThemeData(
    color: Colors.white,
  ),
  iconTheme: const IconThemeData(color: Color(0XFF4DB6AC)),
  primaryTextTheme: const TextTheme(
    headline6: TextStyle(color: Colors.white),
    button: TextStyle(color: Colors.white),
  ),
  textTheme: const TextTheme(
    headline6: TextStyle(fontSize: 24),
    bodyText2: TextStyle(fontSize: 18.0),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0XFF12676D),
  ),
  accentColor: const Color(0XFF12676D),
  accentIconTheme: const IconThemeData(color: Colors.white),
  bottomAppBarColor: const Color(0XFF45A39A),
  indicatorColor: Colors.white,
  tabBarTheme: const TabBarTheme(labelColor: Colors.white),
  primaryColorBrightness: Brightness.dark,
  inputDecorationTheme: const InputDecorationTheme(
    focusedBorder:
        UnderlineInputBorder(borderSide: BorderSide(color: Color(0XFF12676D))),
    border:
        UnderlineInputBorder(borderSide: BorderSide(color: Color(0XFF12676D))),
    labelStyle: TextStyle(color: Color(0XFF12676D)),
    prefixStyle: TextStyle(color: Color(0XFF12676D)),
    suffixStyle: TextStyle(color: Color(0XFF12676D)),
  ),
  chipTheme: ChipThemeData(
    backgroundColor: const Color(0XFF4DB6AC),
    labelStyle: const TextStyle(
      color: Colors.white,
    ),
    brightness: Brightness.dark,
    shape: const StadiumBorder(),
    selectedColor: const Color(0XFF357F78),
    disabledColor: (const Color(0XFF4DB6AC)).withAlpha(150),
    padding: const EdgeInsets.all(4.0),
    labelPadding: const EdgeInsets.symmetric(horizontal: 8.0),
    deleteIconColor: Colors.redAccent,
    secondaryLabelStyle: const TextStyle(
      color: Colors.white70,
    ),
    secondarySelectedColor: const Color(0XFF1E4844),
  ),
  cardColor: Colors.white,
);
