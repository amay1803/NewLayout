import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:imd_weather/widgets/MapView.dart';
import 'package:imd_weather/widgets/sidebar.dart';
import '../services/ApiCall.dart';
import 'package:intl/intl.dart';
import 'package:flutter_icons/flutter_icons.dart';
import '../values/MyBackgrounds.dart';
import '../values/MyColors.dart';
import '../widgets/Animation.dart';
import '../widgets/SearchBar.dart';
import '../widgets/forecast_table.dart';
import '../widgets/navDrawer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Marker> allMarkers = [];
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var lat = 0.0;
  var long = 0.0;
  var userlocation;
  var datalocation;

  void tp() {
    allMarkers.add(Marker(
        markerId: MarkerId('myMarker'),
        draggable: false,
        onTap: () {
          print('Marker Tapped');
        },
        position: LatLng(lat, long)));
  }

  bool internet = true;
  _checkInternet() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      setState(() {
        internet = false;
      });
    } else {
      setState(() {
        internet = true;
      });
      await SearchBar.getCities();
      setState(() {
        fetched = true;
      });
      print("done ");
      print("Fetching current location info");
    }
  }

  Forecast forecast = new Forecast();
  List days;
  void fetch() async {
    print(SearchBar.id[datalocation]);
    await forecast.getForecast(SearchBar.id[datalocation]);
    setState(() {
      days = forecast.forecasts;
      show = true;
      print('done');
    });
  }

  @override
  void initState() {
    super.initState();
    _checkInternet();
  }

  int index = 1;
  bool show = false;
  bool fetched = false;
  Map data;
  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    lat = (data['latitude']);
    long = (data['longitude']);
    datalocation = (data['datalocation']);
    userlocation = (data['userlocation']);
    tp();

    int hour = int.parse(TimeOfDay.now().toString().substring(10, 12));
    int bg = backgournd(hour);
    List images;
    Color primarycolor;
    Color secondarycolor;
    Color symbol;
    Color forText;
    if (bg == 0) {
      images = BackgroundImage.morningImages;
      primarycolor = MyColors.primaryBlack;
      secondarycolor = MyColors.primaryBlack;
      symbol = MyColors.symbol;
      forText = MyColors.primaryBlack;
    } else if (bg == 1) {
      images = BackgroundImage.nightImages;
      primarycolor = MyColors.primaryWhite;
      secondarycolor = MyColors.secondaryLightBlue;
      symbol = MyColors.symbol;
      forText = MyColors.forText;
    } else {
      images = BackgroundImage.eveningImages;
      primarycolor = MyColors.primaryWhite;
      secondarycolor = MyColors.secondaryLightBlue;
      symbol = MyColors.symbol;
      forText = MyColors.forText;
    }
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        // drawer: NavDrawer(),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image(image: AssetImage(images[index]), fit: BoxFit.cover),
            RefreshIndicator(
                child: SafeArea(
                    child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Stack(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Text("IMD Western-Zone",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: primarycolor,
                                              fontFamily: 'Roboto Light',
                                              fontSize: 23.0)),
                                    ),
                                  ),
                                ],
                              ),
                              Positioned(
                                right: 0,
                                child: IconButton(
                                  icon: Icon(Icons.search),
                                  color: forText,
                                  onPressed: () {
                                    showSearch(
                                        context: context, delegate: SearchBar());
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 80.0,
                          ),
                          child: FadeAnimation(
                            delay: 1.2,
                           // child: Padding(
                              //padding used for text mumbai
                             // padding: const EdgeInsets.only(left: 20.0),
                              child: Center(
                                child: Text(userlocation,
                                    style: TextStyle(
                                        color: primarycolor,
                                        fontFamily: 'Roboto Light',
                                        fontSize: 60.0,
                                        letterSpacing: 1.0)),
                              ),
                            ),
                          ),
                       // ),
                        SizedBox(height: 15.0),
                       // Padding(
                        //  padding: const EdgeInsets.only(left: 20.0),
                           Center(
                             child: FadeAnimation(
                              delay: 1.4,
                              child: Text(
                                  DateFormat('h:mm a E, d MMM y')
                                      .format(DateTime.now()),
                                  style: TextStyle(
                                      color: primarycolor,
                                      fontFamily: 'Roboto Light',
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold)),
                          ),
                           ),
                      //  ),
                        SizedBox(height: 50.0),
                        !internet
                            ? Text("No Internet")
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                    Center(
                                      child: Container(
                                        width: 120,
                                        child: FadeAnimation(
                                          delay: 1.6,
                                          child: Stack(
                                            children: <Widget>[
                                              Text("22",
                                                  style: TextStyle(
                                                      color: primarycolor,
                                                      fontFamily: 'Roboto Light',
                                                      fontSize: 70,
                                                      letterSpacing: 1.0)),
                                              Positioned(
                                                  left: 70.0,
                                                  bottom: 25.0,
                                                  child: Icon(
                                                      WeatherIcons.wi_celsius,
                                                      size: 65,
                                                      color: primarycolor))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  
                                  SizedBox(height: 15.0),
                                    Center(
                                      child: Container(
                                        width: 180,
                                        child: FadeAnimation(
                                              delay: 1.6,
                                              child: Center(
                                                child: Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      Feather.sun,
                                                      size: 45.0,
                                                      color: symbol,
                                                    ),
                                                    SizedBox(width: 10.0),
                                                    Text('Sunny',
                                                        style: TextStyle(
                                                            color: forText,
                                                            fontFamily: 'Roboto Light',
                                                            fontSize: 35.0,
                                                            fontWeight: FontWeight.bold,
                                                            letterSpacing: 1.0)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                      ),
                                    ),
                                  SizedBox(height: 150.0),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0, right: 0.0),
                                    child: FadeAnimation(
                                      delay: 1.8,
                                      child: Card(
                                        color: MyColors.transparent
                                            .withOpacity(0.16),
                                        elevation: 5.0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(7.0)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            children: <Widget>[
                                              WRH_Column(
                                                  value: 5,
                                                  unit: 'km/h',
                                                  parameter: 'Wind',
                                                  icon: Feather.wind),
                                              WRH_Column(
                                                  value: 70,
                                                  unit: '%',
                                                  parameter: 'Rain',
                                                  icon: Feather.cloud_drizzle),
                                              WRH_Column(
                                                  value: 60,
                                                  unit: '%',
                                                  parameter: 'Humidity',
                                                  icon:
                                                      WeatherIcons.wi_humidity)
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 90.0),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 0.0, right: 0.0),
                                    child: FadeAnimation(
                                      delay: 2.0,
                                      child: Card(
                                        color: MyColors.colorgreen,
                                        elevation: 3.0,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            children: <Widget>[
                                              Center(
                                                child: Text(
                                                  "Today's Weather Info.",
                                                  style: TextStyle(
                                                    color: secondarycolor,
                                                    fontSize: 26.0,
                                                    fontWeight: FontWeight.w800,
                                                    letterSpacing: 1.0,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 7.0),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0.0, 0.0, 0.0, 0.0),
                                                child: Divider(
                                                  height: 3.0,
                                                  color: primarycolor,
                                                  thickness: 2,
                                                ),
                                              ),
                                              SizedBox(height: 1.0),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0.0, 0.0, 0.0, 0.0),
                                                child: Divider(
                                                  height: 3.0,
                                                  color: primarycolor,
                                                  thickness: 2,
                                                ),
                                              ),
                                              SizedBox(height: 30.0),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 0.0, right: 0.0),
                                                child: Row(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 23.0),
                                                      child: Icon(
                                                        Icons.wb_sunny,
                                                        color: symbol,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 4,
                                                      child: Text(
                                                          DateFormat(
                                                                  'E, d MMM ')
                                                              .format(DateTime
                                                                  .now()),
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto Light',
                                                              fontSize: 22.0,
                                                              color:
                                                                  primarycolor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ),
                                                    Expanded(
                                                        flex: 2,
                                                        child: Text(
                                                          "22°C",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto Light',
                                                              fontSize: 22.0,
                                                              color:
                                                                  primarycolor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          textAlign:
                                                              TextAlign.center,
                                                        )),
                                                    Expanded(
                                                        flex: 2,
                                                        child: Text(
                                                          "32°C",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Roboto Light',
                                                              fontSize: 22.0,
                                                              color:
                                                                  primarycolor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                          textAlign:
                                                              TextAlign.center,
                                                        )),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 20.0),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        2.0, 0.0, 2.0, 0.0),
                                                child: Divider(
                                                  height: 10.0,
                                                  color: primarycolor,
                                                  thickness: 2,
                                                ),
                                              ),
                                              SizedBox(height: 42.0),
                                              Row(
                                                children: <Widget>[
                                                  Expanded(
                                                      flex: 4,
                                                      child: Text(
                                                        "Percipitation ",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Roboto Light',
                                                            fontSize: 18.0,
                                                            color: primarycolor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )),
                                                  Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        "70%",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Roboto Light',
                                                            fontSize: 18.0,
                                                            color: primarycolor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        textAlign:
                                                            TextAlign.start,
                                                      )),
                                                  Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        "Wind",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Roboto Light',
                                                            fontSize: 18.0,
                                                            color: primarycolor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )),
                                                  Expanded(
                                                      flex: 3,
                                                      child: Text(
                                                        "8 km/h",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Roboto Light',
                                                            fontSize: 18.0,
                                                            color: primarycolor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )),
                                                ],
                                              ),
                                              SizedBox(height: 25.0),
                                              Row(
                                                children: <Widget>[
                                                  Expanded(
                                                      flex: 4,
                                                      child: Text(
                                                        "Pressure",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Roboto Light',
                                                            fontSize: 18.0,
                                                            color: primarycolor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        textAlign:
                                                            TextAlign.start,
                                                      )),
                                                  Expanded(
                                                      flex: 3,
                                                      child: Text(
                                                        "940hPa",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Roboto Light',
                                                            fontSize: 18.0,
                                                            color: primarycolor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )),
                                                  Expanded(
                                                      flex: 4,
                                                      child: Text(
                                                        "Humidity ",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Roboto Light',
                                                            fontSize: 18.0,
                                                            color: primarycolor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )),
                                                  Expanded(
                                                      flex: 3,
                                                      child: Text(
                                                        "65%",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Roboto Light',
                                                            fontSize: 18.0,
                                                            color: primarycolor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )),
                                                ],
                                              ),
                                              SizedBox(height: 30.0),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 60.0),
                                  show && fetched
                                      ? ForecastandMap(
                                          days: days,
                                          lat: lat,
                                          long: long,
                                          allMarkers: allMarkers)
                                      : Center(child: spinner(primarycolor))
                                ],
                              ),
                      ],
                    ),
                  ),
                )),
                onRefresh: () async {
                  await Future.delayed(Duration(seconds: 0));
                  await _checkInternet();
                  if (internet) {
                    setState(() {
                      index = Random().nextInt(images.length - 1);
                    });
                  }
                }),
            SideBar()
          ],
        ));
  }

  Widget spinner(color) {
    if (fetched) fetch();
    return SpinKitCircle(
      color: color,
      size: 80.0,
    );
  }

  int backgournd(int hr) {
    if (hr >= 6 && hr < 18)
      return 0; //Morning
    else if (hr == 5 || (hr >= 18 && hr <= 19))
      return 2; //Evening
    else
      return 1; //Night
  }
}

class ForecastandMap extends StatelessWidget {
  const ForecastandMap({
    Key key,
    @required this.days,
    @required this.lat,
    @required this.long,
    @required this.allMarkers,
  }) : super(key: key);

  final List days;
  final double lat;
  final double long;
  final List<Marker> allMarkers;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ForecastTable(days: days),
        GoogleMapView(lat: lat, long: long, allMarkers: allMarkers)
      ],
    );
  }
}

class WRH_Column extends StatelessWidget {
  final IconData icon;
  final int value;
  final String unit;
  final String parameter;
  const WRH_Column({Key key, this.icon, this.value, this.unit, this.parameter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int hour = int.parse(TimeOfDay.now().toString().substring(10, 12));
    int bg = backgournd(hour);
    List images;
    Color primarycolor;
    Color secondarycolor;
    Color symbol;
    Color forText;
    if (bg == 0) {
      images = BackgroundImage.morningImages;
      primarycolor = MyColors.primaryBlack;
      secondarycolor = MyColors.primaryBlack;
      symbol = MyColors.symbol;
      forText = MyColors.forText;
    } else if (bg == 1) {
      images = BackgroundImage.nightImages;
      primarycolor = MyColors.primaryWhite;
      secondarycolor = MyColors.secondaryLightBlue;
      symbol = MyColors.symbol;
      forText = MyColors.forText;
    } else {
      images = BackgroundImage.eveningImages;
      primarycolor = MyColors.primaryWhite;
      secondarycolor = MyColors.secondaryLightBlue;
      symbol = MyColors.symbol;
      forText = MyColors.forText;
    }
    return Expanded(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: 30.0,
              color: primarycolor,
            ),
            SizedBox(height: 20),
            RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: '$value',
                  style: TextStyle(
                      fontSize: 30.0,
                      color: primarycolor,
                      fontWeight: FontWeight.w700),
                  children: [
                    TextSpan(
                        text: ' $unit',
                        style: TextStyle(
                            fontSize: 18.0,
                            color: primarycolor,
                            fontWeight: FontWeight.w700))
                  ],
                )),
            SizedBox(height: 20),
            FittedBox(
              child: Text('$parameter',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 23.0,
                      color: primarycolor,
                      fontWeight: FontWeight.w800)),
            )
          ]),
    );
  }

  int backgournd(int hr) {
    if (hr >= 6 && hr < 18)
      return 0; //Morning
    else if (hr == 5 || (hr >= 18 && hr <= 19))
      return 2; //Evening
    else
      return 1; //Night
  }
}
