import 'package:crud_api_app/locals/secure_storage.dart';
import 'package:crud_api_app/pages/home_page.dart';
import 'package:crud_api_app/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String initialRoute = '';
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    SecureStorage.getToken().then((value) {
      if (value == null) {
        setState(() {
          initialRoute = AppRoutes.loginPage;
        });
      } else {
        setState(() {
          initialRoute = AppRoutes.mainPage;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Rubik',
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      // initialRoute: initialRoute,
      home: initialRoute == AppRoutes.mainPage
          ? const MainPage()
          : const LoginPage(),
      routes: AppRoutes.routes,
      navigatorKey: _navigatorKey,
    );
  }
}
