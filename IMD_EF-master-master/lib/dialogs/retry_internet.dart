import 'package:flutter/material.dart';
class retry_internet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildChild(context),
    );
  }

  _buildChild(BuildContext context) => Container(
    height: 350,
    decoration: BoxDecoration(
        color: Colors.redAccent,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(12))
    ),
    child: Column(
      children: <Widget>[
        Container(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset('assets/images/noconnection/wifi.gif', height: 200, width: 150,),
          ),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))
          ),
        ),
        SizedBox(height: 12,),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Center(
            child: Text('Check Your Internet Connection Again', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),),
          ),
        ),
        SizedBox(height: 10,),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RaisedButton(onPressed: (){
              Navigator.of(context).pop();
            }, child: Text('Ok',style: TextStyle(fontSize: 18.0),),textColor: Colors.white,color: Colors.red[800],),
          ],
        )
      ],
    ),
  );
}