import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/http/api_service.dart';
import 'package:flutter_app/model/project_tree_model.dart';
import 'package:flutter_app/ui/project/ProjectListPage.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import 'package:flutter_easyrefresh/ball_pulse_footer.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProjectPage extends StatefulWidget {
  ProjectPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ProjectPageState();
  }
}

class ProjectPageState extends State<ProjectPage>
    with TickerProviderStateMixin {
  List<ProjectTreeData> _datas = new List();
  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    _tabController = TabController(
      vsync: this,
      length: _datas.length,
    );
    return new Scaffold(
        appBar: new AppBar(
            title: TabBar(
          indicatorColor: Colors.white,
          labelStyle: TextStyle(fontSize: 16),
          unselectedLabelStyle: TextStyle(fontSize: 16),
          controller: _tabController,
          tabs: _datas.map((ProjectTreeData item) {
            return Tab(text: item.name);
          }).toList(),
          isScrollable: true,
        )),
        body: TabBarView(
          controller: _tabController,
          children: _datas.map((item) {
            return ProjectListPage(item.id);
          }).toList(),
        ));
  }

  Future<Null> _getData() async {
    ApiService.getProjectTree((ProjectTreeModel _projectTreeModel) {
      if (_projectTreeModel.errorCode == 0) {
        //成功
        if (_projectTreeModel.data.length > 0) {
          //有数据
          setState(() {
            _datas = _projectTreeModel.data;
          });
        } else {
          //数据为空
          showEmpty();
        }
      } else {
        Fluttertoast.showToast(msg: _projectTreeModel.errorMsg);
      }
    }, (DioError error) {
      //发生错误
      print(error.response);
      showError();
    });
  }

  void showError() {}

  void showEmpty() {}
}
