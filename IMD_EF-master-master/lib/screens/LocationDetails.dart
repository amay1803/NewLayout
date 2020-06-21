import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../services/ApiCall.dart';
import '../widgets/Animation.dart';
import 'package:connectivity/connectivity.dart';
import '../values/MyTextStyles.dart';
import '../values/MyColors.dart';

class LocationDetails extends StatefulWidget {
  @override
  _LocationDetailsState createState() => _LocationDetailsState();
}

class _LocationDetailsState extends State<LocationDetails> {
  bool flag = false;
  bool internet = true;
  ForecastMain forecast = new ForecastMain();

  _checkInternet() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      setState(() {
        internet = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map data = ModalRoute.of(context).settings.arguments;
    final String location = data['location'];

    Widget grid() {
      return ListView.builder(
          itemCount: forecast.regions.length,
          itemBuilder: (context, index) {
            return FadeAnimation(
              delay: 1.0,
              child: Card(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/region', arguments: {
                      'days': forecast.forecasts[index],
                      'region': forecast.regions[index]
                    });
                  },
                  child: ListTile(
                      title: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Text(
                      '${forecast.regions[index]}',
                      style: MyTextStyles.bodyText,
                    ),
                  )),
                ),
                color:Color(0xffabc6e5), //[200 + (index * 100)]
              ),
            );
          });
    }

    void fetch() async {
      await _checkInternet();
      if (internet) {
        await forecast.getForecast(location);
        setState(() {
          flag = true;
        });
      }
    }

    Widget spinner() {
      fetch();
      return SpinKitCircle(
        color: MyColors.main_black,
        size: 80.0,
      );
    }

    Widget mainScreen() {
      return flag ? grid() : spinner();
    }

    //_checkInternet();
    return Scaffold(
        body: Stack(fit: StackFit.expand, children: <Widget>[
      Image(
        image: AssetImage('assets/images/morning/day-1.jpg'),
        fit: BoxFit.cover,
      ),
      Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 50.0),
        child: Text('Mumbai', style: MyTextStyles.title),
      ),
      Padding(
          padding: const EdgeInsets.only(top: 120.0),
          child: internet
              ? mainScreen()
              : Center(
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Feather.wifi_off, size: 50.0),
                    SizedBox(width: 10.0),
                    Text("No Internet", style: MyTextStyles.bodyText),
                  ],
                )))
    ]));
  }
}
