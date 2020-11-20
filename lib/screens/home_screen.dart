// Libraries
import 'dart:convert';

import 'package:check_my_attendance/model/timestamp_model.dart';
import "package:flutter/material.dart";
import "package:check_my_attendance/config/size_config.dart";
import "package:flutter/services.dart";
import "package:device_info/device_info.dart";
import "package:http/http.dart" as http;
import "package:check_my_attendance/config/api_address.dart";
import "package:qrscan/qrscan.dart" as scanner;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // States and Variables
  String deviceId;
  String name;
  String unit;
  String userCode;
  bool loadingData = true;
  String today;
  bool todayInEmpty = true;
  bool todayOutEmpty = true;
  List<TimeStampModel> timeData = [];

  @override
  void initState() {
    super.initState();
    getToday();
  }

  void getToday() {
    DateTime now = DateTime.now();
    setState(() {
      today = "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    });
  }

  // Get Device's ID
  Future<String> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor;
    } else {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId;
    }
  }

  // getEmployeeData from Database
  void getEmployeeData() {
    getDeviceId().then((id) async {
      Map body = {"device_id": id};
      final response = await http.post(apiAddress + 'get_employee.php', body: body);
      var jsonData = json.decode(response.body);
      if (jsonData['success'] == '1') {
        setState(() {
          deviceId = jsonData['device_id'];
          name = jsonData['name'];
          unit = jsonData['unit'];
          userCode = jsonData['user_code'];
        });
      } else {
        showAlert(jsonData['message']);
      }

      checkRegisteredDate(deviceId, today, userCode);
      setState(() {
        loadingData = false;
      });
    });
  }

  void checkRegisteredDate(String deviceId, String today, String userCode) async {
    setState(() {
      loadingData = true;
    });

    Map body = {"device_id": deviceId, "date": today, "user_code": userCode};
    final response = await http.post(apiAddress + 'check_register_date.php', body: body);
    var jsonData = json.decode(response.body);
    if (jsonData['new_date'] == '1') checkRegisteredDate(deviceId, today, userCode);

    setState(() {
      jsonData['in_empty'] == '1' ? todayInEmpty = true : todayInEmpty = false;
      jsonData['out_empty'] == '1' ? todayOutEmpty = true : todayOutEmpty = false;
    });
    getTimeData(deviceId);

    setState(() {
      loadingData = false;
    });
  }

  Future<List<TimeStampModel>> getTimeData(String deviceId) async {
    setState(() {
      loadingData = true;
    });

    try {
      Map body = {"device_id": deviceId};
      final response = await http.post(apiAddress + 'get_timestamp.php', body: body);
      if (response.statusCode == 200) {
        List<TimeStampModel> list = parseTimeStampResponse(response.body);
        setState(() {
          timeData = list;
          loadingData = false;
        });
        print(list[0]);
      } else {
        setState(() {
          loadingData = false;
        });
        return List<TimeStampModel>();
      }
    } catch (e) {
      return List<TimeStampModel>();
    }

    setState(() {
      loadingData = false;
    });
  }

  List<TimeStampModel> parseTimeStampResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<TimeStampModel>((json) => TimeStampModel.fromJson(json)).toList();
  }

  void updateIn(String deviceId, String userCode, String date) async {
    DateTime now = DateTime.now();
    String thisHour = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
    //
    Map body = {"device_id": deviceId, "user_code": userCode, "date": date, "time": thisHour};
    final response = await http.post(apiAddress + "update_in.php", body: body);
    var jsonData = json.decode(response.body);
    if (jsonData['success'] == '1'){
      setState(() {
       todayInEmpty = false; 
      });
      getTimeData(deviceId);
    }
    showAlert(jsonData['message']);
  }

  void updateOut(String deviceId, String userCode, String date) async {
    DateTime now = DateTime.now();
    String thisHour = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
    //
    Map body = {"device_id": deviceId, "user_code": userCode, "date": date, "time": thisHour};
    final response = await http.post(apiAddress + "update_out.php", body: body);
    var jsonData = json.decode(response.body);
    if (jsonData['success'] == '1'){
      setState(() {
       todayOutEmpty = false; 
      });
      getTimeData(deviceId);
    }
    showAlert(jsonData['message']);
  }

  showAlert(String text) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(text),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Ok"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    if (loadingData) getEmployeeData();

    SizeConfig().init(context);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
      appBar: _appBar(),
      body: loadingData
          ? _loadingIndicator()
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _biodataColumn(),
                _buttonRow(),
                _dateTable(),
              ],
            ),
    );
  }

  //! Widget Function - - - - -
  AppBar _appBar() {
    return AppBar(
      title: Text("Employee Attendance"),
      centerTitle: true,
      actions: <Widget>[
        Container(
          // margin: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal * 1),
          child: IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      actions: <Widget>[
                        FlatButton(
                          child: Text("Close"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                      content: Text("Check-My-Attendance App\n\nCreated by: Nevir Wizurai\nfor Assignment of HCI Projects, March 2020"),
                    );
                  });
            },
            icon: Icon(Icons.info),
          ),
        ),
      ],
    );
  }

  TextStyle _biodataStyle = TextStyle(fontSize: SizeConfig.blockSizeHorizontal * 4.5);
  Container _biodataColumn() {
    return Container(
      padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 10),
      width: SizeConfig.screenWidth,
      // height: SizeConfig.blockSizeVertical * 30,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("Employee Name :\n$name", style: _biodataStyle),
          SizedBox(height: SizeConfig.blockSizeVertical * 3),
          Text("Unit :\n$unit", style: _biodataStyle),
          SizedBox(height: SizeConfig.blockSizeVertical * 3),
          Text("Device ID :\n$deviceId", style: _biodataStyle),
        ],
      ),
    );
  }

  Container _buttonRow() {
    return Container(
      width: SizeConfig.blockSizeHorizontal * 80,
      padding: EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical * 3),
      child: !todayInEmpty && !todayOutEmpty
          ? Center(
              child: Text(
                "Good Job on your work today :)",
                style: TextStyle(
                  fontSize: SizeConfig.blockSizeHorizontal * 5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.work,
                        color: Colors.white,
                      ),
                      SizedBox(width: SizeConfig.blockSizeHorizontal * 3),
                      Text(
                        "Check In",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  onPressed: !todayInEmpty
                      ? null
                      : () async {
                          final String scanCode = await scanner.scan();
                          updateIn(deviceId, scanCode, today);
                        },
                  color: Color.fromRGBO(0, 128, 255, 1),
                ),
                RaisedButton(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.home,
                        color: Colors.white,
                      ),
                      SizedBox(width: SizeConfig.blockSizeHorizontal * 3),
                      Text(
                        "Check Out",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  onPressed: todayInEmpty || !todayOutEmpty
                      ? null
                      : () async {
                          final String scanCode = await scanner.scan();
                          updateOut(deviceId, scanCode, today);
                        },
                  color: Color.fromRGBO(0, 128, 255, 1),
                ),
              ],
            ),
    );
  }

  TextStyle headerStyle = TextStyle(
    fontSize: SizeConfig.blockSizeHorizontal * 4,
    color: Color.fromRGBO(0,128,255,1),
  );
  Expanded _dateTable() {
    return Expanded(
      child: Container(
        width: SizeConfig.screenWidth,
        // color: Colors.lightBlue,
        padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
        child: Center(
          child: SingleChildScrollView(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Today: " + today,
                        style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal * 5),
                      ),
                      SizedBox(width: SizeConfig.blockSizeHorizontal * 5),
                      IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: (){getTimeData(deviceId);},
                      ),
                    ],
                  ),
                  // SizedBox(height: SizeConfig.blockSizeVertical * 3),
                  DataTable(
                    columnSpacing: SizeConfig.blockSizeHorizontal * 7,
                    columns: [
                      DataColumn(label: Text("Date", style: headerStyle)),
                      DataColumn(label: Text("Check In", style: headerStyle)),
                      DataColumn(label: Text("Check Out", style: headerStyle)),
                    ],
                    rows: timeData
                        .map((times) => DataRow(cells: [
                              DataCell(_dataCellBuilder(times.date)),
                              DataCell(_dataCellBuilder(times.checkIn == "" ? "- - - -" : times.checkIn)),
                              DataCell(_dataCellBuilder(times.checkOut == "" ? "- - - -" : times.checkOut)),
                            ]))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container _dataCellBuilder(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal * 1),
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: TextStyle(fontSize: SizeConfig.blockSizeHorizontal * 4),
      ),
    );
  }

  Container _loadingIndicator() {
    return Container(
        child: Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.blue,
      ),
    ));
  }
}
