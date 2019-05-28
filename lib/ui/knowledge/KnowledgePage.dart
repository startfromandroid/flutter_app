
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/http/api_service.dart';
import 'package:flutter_app/model/tree_model_entity.dart';
import 'package:flutter_app/ui/knowledge/knowledge_item.dart';
import 'package:fluttertoast/fluttertoast.dart';

class KnowledgePage extends StatefulWidget {
  KnowledgePage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return KnowledgePageState();
  }
}

class KnowledgePageState extends State<KnowledgePage> {
  List<TreeModelData> _datas = new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: AppBar(
          title: const Text('知识体系'),
          centerTitle: true,
        ),
        body: RefreshIndicator(child: bulidList(), onRefresh: _getData));
  }

  Future<Null> _getData() async {
    ApiService.getSystemTree((TreeModelEntity _treeModelEntity) {
      if (_treeModelEntity.errorCode == 0) {
        //成功
        if (_treeModelEntity.data.length > 0) {
          //有数据
          setState(() {
            _datas.clear();
            _datas.addAll(_treeModelEntity.data);
          });
        } else {
          //数据为空
          showEmpty();
        }
      } else {
        Fluttertoast.showToast(msg: _treeModelEntity.errorMsg);
      }
    }, (DioError error) {
      //发生错误
      print(error.response);
      showError();
    });
  }

  Widget bulidList() {
    return ListView.builder(
      itemBuilder: _bulidRow,
      itemCount: _datas.length,
    );
  }

  void showEmpty() {}

  void showError() {}

  Widget _bulidRow(BuildContext context, int index) {
    if (index < _datas.length) {
      return KnowledgeItem(_datas[index]);
    }
    return null;
  }
}
