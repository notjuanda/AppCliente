import 'package:airbnbcliente/middlewares/auth.middleware.dart';
import 'package:airbnbcliente/pages/login.page.dart';
import 'package:airbnbcliente/pages/register.page.dart';
import 'package:airbnbcliente/pages/welcome.page.dart';
import 'package:airbnbcliente/pages/main_navigation.page.dart'; // Importa la página del menú inferior
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Airbnb Cliente',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => AuthMiddleware(
              homePage: MainNavigationPage(),
              loginPage: WelcomePage(),
            ),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => MainNavigationPage(),
        '/welcome': (context) => WelcomePage(),
      },
    );
  }
}
