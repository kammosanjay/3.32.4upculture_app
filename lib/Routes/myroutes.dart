import 'package:get/get.dart';
import 'package:upculture/Routes/mypagenames.dart';
import 'package:upculture/screen/common/splash_screen.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.splashPage,
      page: () => SplashScreen(),
    ),
  ];
}
