import 'package:crud_api_app/pages/home_page.dart';
import 'package:crud_api_app/pages/login_page.dart';
import 'package:crud_api_app/pages/register_page.dart';
import 'package:flutter/material.dart';

import '../pages/main_page.dart';

class AppRoutes {
  AppRoutes._();

  static const homePage = '/home';
  static const loginPage = '/login';
  static const registerPage = '/register';
  static const mainPage = '/main';

  static final routes = <String, WidgetBuilder>{
    loginPage: (_) => const LoginPage(),
    registerPage: (_) => const RegisterPage(),
    homePage: (_) => const HomePage(),
    mainPage: (_) => const MainPage(),
  };
}
