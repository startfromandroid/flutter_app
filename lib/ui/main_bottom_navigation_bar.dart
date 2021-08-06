import 'package:flutter/material.dart';
import 'package:flutter_app/style/TextStyles.dart';
import 'package:flutter_app/ui/account/PubliccAccountPage.dart';
import 'package:flutter_app/ui/home/HomePage.dart';
import 'package:flutter_app/ui/knowledge/KnowledgePage.dart';
import 'package:flutter_app/ui/project/ProjectPage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyStatefulWidget extends StatefulWidget {
  MyStatefulWidget({Key key}) : super(key: key);

  @override
  _MyStatefulWidgetState createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  DateTime _lastPressedAt; //上次点击时间
  var _widgetOptions = <Widget>[
    HomePage(),
    KnowledgePage(),
    PubliccAccountPage(),
    ProjectPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          body: new IndexedStack(
            children: _widgetOptions,
            index: _selectedIndex,
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: '首页',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bubble_chart),
                label: '知识体系',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.assessment),
                label: '公众号',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.book),
                label: '项目',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            type: BottomNavigationBarType.fixed,
          ),
        ),
        onWillPop: _onWillPop);
  }

  Future<bool> _onWillPop() async {
    if (_lastPressedAt == null ||
        DateTime.now().difference(_lastPressedAt) > Duration(seconds: 1)) {
      //两次点击间隔超过1秒则重新计时
      _lastPressedAt = DateTime.now();
      Fluttertoast.showToast(
          msg: "再按一次退出",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return false;
    }
    return true;
  }
}
