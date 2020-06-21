import 'package:flutter/material.dart';
import 'package:imd_weather/values/MyColors.dart';
import '../values/MyTextStyles.dart';
import 'package:intl/intl.dart';

class ForecastTable extends StatelessWidget {
  final List days;
  ForecastTable({@required this.days});
  @override
  Widget build(BuildContext context) {
    var i = -1;
    return Padding(
      padding: const EdgeInsets.only(bottom: 23.0),
      child: Column(
        children: <Widget>[
          SizedBox(height: 20),
          Center(
            child: Text(
              'Weekly Forecast',
              style: MyTextStyles.Weakly,
            ),
          ),
          SizedBox(height: 15.0),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Divider(
              height: 3.0,
              color: MyColors.tp3,
              thickness: 2,
            ),
          ),
          SizedBox(height: 2),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Divider(
              height: 3.0,
              color: MyColors.tp3,
              thickness: 2,
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Text('Date', style: MyTextStyles.DWTHeader)),
                Expanded(
                    flex: 3,
                    child: Text(
                      'Weather',
                      style: MyTextStyles.DWTHeader,
                      textAlign: TextAlign.center,
                    )),
                SizedBox(width: 5.0),
                Expanded(
                    flex: 2,
                    child: FittedBox(
                        child: Text('Temperature',
                            style: MyTextStyles.DWTHeader,
                            textAlign: TextAlign.start))),
              ],
            ),
          ),
          Column(
              children: days.map((index) {
            i++;
            return LimitedBox(
              maxHeight: 200.0,
              child: Card(
                  color: MyColors.secondaryLightBlue,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: <Widget>[
                        // Text(
                        //     DateFormat.E()
                        //         .format(DateTime.now().add(Duration(days: i)))
                        //         .substring(0, 3),
                        //     style: MyTextStyles.bodyText2),
                        // SizedBox(width: 5.0),
                        Expanded(
                            child: Text(days[i]['date'],
                                style: MyTextStyles.bodyText2)),
                        Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Text(days[i]['weather'],
                                  textAlign: TextAlign.center,
                                  style: MyTextStyles.bodyText2),
                            )),
                        SizedBox(width: 5.0),
                        Expanded(
                            flex: 2,
                            child: FittedBox(
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.arrow_upward),
                                  Text(' ${days[i]['maxTemp']}°C',
                                      style: MyTextStyles.bodyText2),
                                  SizedBox(width: 5),
                                  Icon(Icons.arrow_downward),
                                  Text(' ${days[i]['minTemp']}°C',
                                      style: MyTextStyles.bodyText2)
                                ],
                              ),
                            )),
                      ],
                    ),
                  )),
            );
          }).toList()),
          SizedBox(height: 50),
          Text(
            'Maps',
            style: TextStyle(
                color: MyColors.tp6,
                fontFamily: 'Roboto Light',
                fontSize: 30.0,
                letterSpacing: 1.0),
            textAlign: TextAlign.center,
          ),SizedBox(height:10),Padding(
            padding: const EdgeInsets.only(left:8.0,right:8.0),
            child: Divider(
              height: 3.0,
              color: MyColors.tp6,
              thickness: 2,),
          ),
          SizedBox(height:2),
            Padding(
              padding: const EdgeInsets.only(left:8.0,right:8.0),
              child: Divider(
              height: 3.0,
              color: MyColors.tp6,
              thickness: 2),
            ),
        ],
      ),
    );
  }
}
