import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:upculture/resources/language.dart';
import 'package:upculture/resources/my_color.dart';
import 'package:upculture/resources/my_string.dart';
import 'package:upculture/screen/artist/select_language.dart';
import 'package:upculture/screen/common/select_role_screen.dart';
import 'package:upculture/screen/common/splash_screen.dart';

void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

// to save the locale in shared preference

  // final locale = await MySharedPreference().getSavedLocale();
  // print("startingLang--->" + locale.languageCode);
  // runApp(MyApp(locale: locale));

  // without shared preference
  runApp(MyApp(locale: Locale('hi', 'IN'))); // or any default locale you want
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  final Locale locale;

  MyApp({super.key, required this.locale});

  Future<void> _firebaseMessagingOnBackgroundMessage(
      RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
  }

  Map<int, Color> color = {
    50: const Color.fromRGBO(237, 125, 49, 1.0),
    100: const Color.fromRGBO(237, 125, 49, .2),
    200: const Color.fromRGBO(237, 125, 49, .3),
    300: const Color.fromRGBO(237, 125, 49, .4),
    400: const Color.fromRGBO(237, 125, 49, .5),
    500: const Color.fromRGBO(237, 125, 49, .6),
    600: const Color.fromRGBO(237, 125, 49, .7),
    700: const Color.fromRGBO(237, 125, 49, .8),
    800: const Color.fromRGBO(237, 125, 49, .9),
    900: const Color.fromRGBO(237, 125, 49, 1.0),
  };

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    MaterialColor colorCustom = MaterialColor(0xFFED7D31, color);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: MyString.appText,
      locale: locale,
      translations: LocalString(),
      theme: ThemeData(
        // primaryColor: MyColor.appColor,
        // primaryColorDark: MyColor.appColor,
        primarySwatch: colorCustom,
        // brightness: Brightness.light,
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: MyColor.appColor,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.light,
          ),
        ),
      ),
      home: SplashScreen(),
      // home: SelectLangWithoutLogin(),
      defaultTransition: Transition.rightToLeft,
    );
  }
}
