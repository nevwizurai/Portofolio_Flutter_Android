// Libraries
import "package:flutter/material.dart";

// Screens
import "package:check_my_attendance/screens/splash_screen.dart";
import "package:check_my_attendance/screens/home_screen.dart";

class RouteManager{
  static Route<dynamic> generateRoute(RouteSettings settings){

    // Branching the Route Name
    switch(settings.name){
      case '/':
        return MaterialPageRoute(builder: (_) => SplashScreen());

      case '/home':
        return MaterialPageRoute(builder: (_) => HomeScreen());
    }
  }
}