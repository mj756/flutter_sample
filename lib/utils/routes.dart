import 'package:flutter/material.dart';
import 'package:flutter_sample/view/home.dart';
import 'package:flutter_sample/view/login.dart';

import '../view/sign_up.dart';

class Routes
{


  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) =>  HomePage());
      case '/login':
        return MaterialPageRoute(builder: (_) =>  LoginPage());
      case '/signup':
        return MaterialPageRoute(builder: (_) =>   SignUpPage());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(
                  child: Text('No route defined for ${settings.name}')),
            ));
    }
  }

}