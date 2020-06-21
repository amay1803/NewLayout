import 'package:flutter/material.dart';
import 'package:imd_weather/values/MyColors.dart';
import 'package:imd_weather/values/MyTextStyles.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class NoGps extends StatefulWidget {
  @override
  _NoGpsState createState() => _NoGpsState();
}

class _NoGpsState extends State<NoGps> {
  bool isLocationEnabled = true;
//  PermissionStatus _status;
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

  _checkGps() async {
//   print("Check gps caaled");
//    _askpermission();
    isLocationEnabled = await Geolocator().isLocationServiceEnabled();
    if (isLocationEnabled) {
      setState(() {
        isLocationEnabled = true;
      });
      for(int i=0;i<2;i++)
      {
        print("Popping Context");
        Navigator.pop(context);
      }
      Navigator.pushNamed(context, '/loading');
    }
    else {
      setState(() {
        isLocationEnabled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 130),
            Container(
              width: 120,
              height: 180,
              child: Image(
                image: AssetImage("assets/images/noconnection/compass.png"),
              ),
            ),
            SizedBox(height: 17),
            Text(
              "Oh-NO!",
              style: MyTextStyles.Whoops,
            ),
            SizedBox(height: 15),
            Text(
              "You Decline our request.",
              style: MyTextStyles.noInternetText,
            ), SizedBox(
              height: 5,
            ),
            Text(
              "Please enable GPS Location and try again",
              style: MyTextStyles.noInternetText,
            ),
            SizedBox(
              height: 45,
            ),
            Container(
              width: 170,
              child: RaisedButton(
                color: MyColors.noInternetbutton,
                onPressed: ()async {
                  await Future.delayed(Duration(seconds: 1));
                  await _checkGps();
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
