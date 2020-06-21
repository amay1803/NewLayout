import 'dart:async';

import 'package:flutter/material.dart';
import 'package:imd_weather/values/MyColors.dart';
import 'package:rxdart/rxdart.dart';

import 'navDrawer.dart';

class SideBar extends StatefulWidget {
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar>
    with SingleTickerProviderStateMixin<SideBar> {
  AnimationController _animationController;
  StreamController<bool> _isSidebarOpenStreamController;
  Stream<bool> _isSidebarOpenStream;
  StreamSink<bool> _isSidebarOpenStreamSink;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _isSidebarOpenStreamController = PublishSubject<bool>();
    _isSidebarOpenStream = _isSidebarOpenStreamController.stream;
    _isSidebarOpenStreamSink = _isSidebarOpenStreamController.sink;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _isSidebarOpenStreamController.close();
    _isSidebarOpenStreamSink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalWidth = MediaQuery.of(context).size.width;
    return StreamBuilder<bool>(
        initialData: false,
        stream: _isSidebarOpenStream,
        builder: (context, status) {
          return AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            top: 0,
            bottom: 0,
            left: status.data ? 0 : -totalWidth,
            right: status.data ? 0 : totalWidth - 35,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    // padding: const EdgeInsets.only(left: 20),
                    color: Colors.blueGrey[700],
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20),
                        Container(
                            height: 200,
                            width: 100,
                            child: Image.asset('assets/images/imd_logo.png')),
                        Text('Indian Meteorological department',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Roboto Light',
                                fontSize: 25.0)),
                        Divider(
                          color: Colors.white,
                          indent: 10,
                          endIndent: 10,
                          thickness: 1,
                          height: 50,
                        ),
                        drawerItem(
                            context: context,
                            title: 'Mumbai',
                            route: '/location',
                            args: {'location': 'Mumbai'}),
                        drawerItem(
                            context: context,
                            title: 'Warnings',
                            route: '/warnings'),
                        drawerItem(
                            context: context,
                            title: 'Stations',
                            route: '/stations_data')
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (_animationController.status ==
                        AnimationStatus.completed) {
                      _isSidebarOpenStreamSink.add(false);
                      _animationController.reverse();
                    } else {
                      _isSidebarOpenStreamSink.add(true);
                      _animationController.forward();
                    }
                  },
                  child: Align(
                    alignment: Alignment(0, -0.97),
                    child: ClipPath(
                      clipper: CustomMenuClipper(),
                      child: Container(
                        color: Colors.blueGrey[700],
                        width: 50,
                        height: 110,
                        alignment: Alignment.center,
                        child: AnimatedIcon(
                          progress: _animationController.view,
                          icon: AnimatedIcons.menu_close,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  Widget drawerItem(
      {BuildContext context, String title, String route, Map args}) {
    return Card(
      color: Colors.blueGrey[700],
      child: ListTile(
        title: Text(title,
            style: TextStyle(
                color: MyColors.main_black,
                fontFamily: 'Roboto',
                fontSize: 20.0)),
        trailing: Icon(Icons.arrow_forward, color: Color(0xfee6579e0),),
        onTap: () async{
          _isSidebarOpenStreamSink.add(false);
          _animationController.reverse();
          Navigator.pushNamed(context, route, arguments: args);
        },
      ),
    );
  }
}

class CustomMenuClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    paint.color = Colors.transparent;
    final w = size.width;
    final h = size.height;
    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(0, 8, 10, 16);
    path.quadraticBezierTo(w - 1, h / 2 - 20, w, h / 2);
    path.quadraticBezierTo(w + 1, h / 2 + 20, 10, h - 16);
    path.quadraticBezierTo(0, h - 8, 0, h);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
