import 'package:flutter/material.dart';
import 'package:imd_weather/values/MyColors.dart';

import '../values/MyColors.dart';

class Launcher extends StatefulWidget {
  @override
  _LauncherState createState() => _LauncherState();
}

class _LauncherState extends State<Launcher> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    animation.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        await Future.delayed(Duration(seconds: 1));
        Navigator.pushReplacementNamed(context, '/loading');
      }
    });
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffD1D9FF),
      body: Center(
        child: FadeTransition(
          opacity: animation,
          child: Column(
            children: <Widget>[
              SizedBox(height: 150.0),
              Center(
                child: Container(
                    width: 120,
                    height: 200,
                    child: Image.asset('assets/images/imd_logo.png',)),
              ),
              SizedBox(height: 9.0),
              Padding(
                padding: const EdgeInsets.all(27.0),
                child: Divider(
                  height: 1.0,
                 color: MyColors.text1,
                thickness: 2,
               ),
              ),
              SizedBox(height: 9.0),
              Expanded(
                  child: Text('Indian Meteorological Department',
                      textAlign: TextAlign.center,
                      style: TextStyle( color: MyColors.main_black,
                          fontFamily: 'Roboto Light', fontSize: 30.0)))
            ],
          ),
        ),
      ),
    );
  }
}
