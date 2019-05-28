import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ListviewRoot extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ListviewRootState();
  }
}

class ListviewRootState extends State<ListviewRoot> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 14.0, 0.0, 14.0),
        child: new Opacity(
            opacity: 1.0,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new SpinKitChasingDots(color: Colors.blueAccent, size: 26.0),
                new Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                    child: new Text('正在加载中...'))
              ],
            )));
  }
}
