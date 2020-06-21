import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:imd_weather/values/MyColors.dart';
import 'package:imd_weather/values/MyTextStyles.dart';
import 'package:imd_weather/dialogs/retry_internet.dart';
import 'package:permission_handler/permission_handler.dart';

class NoInternet extends StatefulWidget {
  @override
  _NoInternetState createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {
  bool internet = true;
//  PermissionStatus _status;

//  @override
//  void initState() {
//    super.initState();
////    PermissionHandler().checkPermissionStatus(PermissionGroup.locationWhenInUse).then(_updateStatus);
//  }
//
//  void _updateStatus(PermissionStatus status)
//  {
//    if(status != _status)
//    {
//      setState(() {
//        _status = status;
//      });
//    }
//  }
//
//  void _askpermission(){
//    PermissionHandler().requestPermissions([PermissionGroup.locationWhenInUse]).then(_onStatusRequested);
//  }
//
//  void _onStatusRequested(Map<PermissionGroup, PermissionStatus> statuses){
//    final status = statuses[PermissionGroup.locationWhenInUse];
//    _updateStatus(status);
//  }
  _checkInternet() async {
//    _askpermission();
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
//      showAlertDialog(context);
      setState(() {
        internet = false;
      });
    } else {
      setState(() {
        internet = true;
      });
      for(int i=0;i<2;i++)
      {
        print("Popping Context");
        Navigator.pop(context);
      }
      Navigator.pushNamed(context, '/loading');

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 130),
            Container(
              width: 200,
              height: 250,
              child: Image(
                image: AssetImage("assets/images/noconnection/nointernet.jpg"),
              ),
            ),
            SizedBox(height: 17),
            Text(
              "Oh-Oh!",
              style: MyTextStyles.Whoops,
            ),
            SizedBox(height: 15),
            Text(
              "No internet connection found.",
              style: MyTextStyles.noInternetText,
            ), SizedBox(
              height: 5,
            ),
            Text(
              "Check your connection and try again",
              style: MyTextStyles.noInternetText,
            ),
            SizedBox(
              height: 45,
            ),
            Container(
              width: 170,
              child: RaisedButton(
                color: MyColors.noInternetbutton,
                onPressed: () async {
                  await Future.delayed(Duration(seconds: 1));
                  await _checkInternet();
                  if (!internet) {
                    showDialog(context: context,
                        builder: (context) => retry_internet());
                  }
                },
                child: Text(
                  "RETRY",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}