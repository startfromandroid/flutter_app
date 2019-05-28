import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/http/api_service.dart';
import 'package:flutter_app/model/wx_article_model_entity.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'AccountArticleList.dart';

class PubliccAccountPage extends StatefulWidget {
  PubliccAccountPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new PubliccAccountPageState();
  }
}

class PubliccAccountPageState extends State<PubliccAccountPage>
    with TickerProviderStateMixin {
  List<WxArticleModelData> _datas = new List();
  TabController _tabController;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    _tabController = new TabController(
      vsync: this,
      length: _datas.length,
    );
    return Scaffold(
        appBar: new AppBar(
            title: TabBar(
          indicatorColor: Colors.white,
          labelStyle: TextStyle(fontSize: 16),
          unselectedLabelStyle: TextStyle(fontSize: 16),
          controller: _tabController,
          tabs: _datas.map((WxArticleModelData item) {
            return Tab(text: item.name);
          }).toList(),
          isScrollable: true,
        )),
        body: TabBarView(
          controller: _tabController,
          children: _datas.map((item) {
            return AccountArticleList(item.id);
          }).toList(),
        ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getData();
  }

  Future<Null> _getData() async {
    ApiService.getWxTitleList((WxArticleModelEntity _wxArticleEntity) {
      if (_wxArticleEntity.errorCode == 0) {
        //成功
        if (_wxArticleEntity.data.length > 0) {
          setState(() {
            _datas = _wxArticleEntity.data;
          });
        } else {
          //数据为空
          showEmpty();
        }
      } else {
        Fluttertoast.showToast(msg: _wxArticleEntity.errorMsg);
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
