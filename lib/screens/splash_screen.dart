// Libraries
import 'dart:async';
import "package:flutter/material.dart";
import "package:check_my_attendance/config/size_config.dart";
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // States
  static const timeout = Duration(seconds: 3);
  static const ms = const Duration(milliseconds: 1);

  @override
  void initState() {
    startTimeout();
    super.initState();
  }

  startTimeout([int milliseconds]){
    var duration = milliseconds == null ? timeout : ms * milliseconds;
    return new Timer(duration, handleTimeout);
  }

  void handleTimeout(){
    Navigator.of(context).pushNamedAndRemoveUntil("/home", (Route<dynamic> r) => false);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
      body: Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
        color: Color.fromRGBO(0, 128, 255, 1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _appTitle(),
            SizedBox(height: SizeConfig.blockSizeVertical * 5),
            _splashDetail(),
          ],
        ),
      ),
    );
  }

  Container _appTitle() {
    return Container(
      width: SizeConfig.screenWidth,
      height: SizeConfig.blockSizeVertical * 50,
      // color: Colors.red,
      child: Center(
        child: Text(
          "Check-My-Attendance",
          style: TextStyle(
            color: Colors.white,
            fontSize: SizeConfig.blockSizeHorizontal * 8,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Column _splashDetail() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          "Initializing...",
          style: TextStyle(color: Colors.white, fontSize: SizeConfig.blockSizeHorizontal * 7),
        ),
        SizedBox(height: SizeConfig.blockSizeVertical * 4),
        CircularProgressIndicator(backgroundColor: Colors.white),
        SizedBox(height: SizeConfig.blockSizeVertical * 4),
        Text("Developed by Nevir Wizurai - 4SC2", style: TextStyle(
          fontSize: SizeConfig.blockSizeHorizontal * 4,
          color: Colors.white,
        ),),
      ],
    );
  }
}
