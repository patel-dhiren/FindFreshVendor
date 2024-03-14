import 'package:flutter/material.dart';
import 'package:fresh_find_vendor/views/signup/signup_view.dart';


import '../constants/constants.dart';
import '../model/item.dart';
import '../views/home/home_view.dart';
import '../views/login/login_view.dart';
import '../views/product/item_view.dart';
import '../views/product_list/product_list_view.dart';
import '../views/splash/splash_view.dart';

class AppRoute {

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppConstant.splashView:
        return MaterialPageRoute(
          builder: (context) => SplashView(),
        );
      case AppConstant.loginView:
        return MaterialPageRoute(
          builder: (context) => LoginView(),
        );
      case AppConstant.homeView:
        return MaterialPageRoute(
          builder: (context) => HomeView(),
        );
      case AppConstant.signupView:
        return MaterialPageRoute(
          builder: (context) => SignupView(),
        );
      case AppConstant.productListView:
        return MaterialPageRoute(
          builder: (context) => ItemListView(),
        );
      case AppConstant.productView:

        Item? item =
        settings.arguments != null ? settings.arguments as Item : null;

        return MaterialPageRoute(
          builder: (context) => ItemView(item: item,),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => SplashView(),
        );
    }
  }
}
