// Libraries
import "package:flutter/material.dart";
import "package:check_my_attendance/config/route_manager.dart";

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Check-Your-App",
      onGenerateRoute: RouteManager.generateRoute,
      initialRoute: "/",
      debugShowCheckedModeBanner: false,
    );
  }
}