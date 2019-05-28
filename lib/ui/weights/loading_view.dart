import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class LoadingView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoadingViewState();
  }
}

class LoadingViewState extends State<LoadingView> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Center(
      child: new Card(
          child: new Stack(children: <Widget>[
        new Padding(
            padding: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 35.0),
            child: new Center(
                child: SpinKitFadingCircle(
              color: Colors.blueAccent,
              size: 30.0,
            ))),
        new Padding(
            padding: new EdgeInsets.fromLTRB(0.0, 35.0, 0.0, 0.0),
            child: new Center(
              child: new Text('正在加载中，莫着急哦~'),
            ))
      ])),
    );
    ;
  }
}
