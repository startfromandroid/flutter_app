import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/http/api_service.dart';
import 'package:flutter_app/http/dio_manager.dart';
import 'package:flutter_app/model/projectlist_model.dart';
import 'package:flutter_app/util/navigator_util.dart';
import 'package:flutter_easyrefresh/ball_pulse_footer.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProjectListPage extends StatefulWidget {
  final int id;

  ProjectListPage(this.id);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ProjectListPageStage();
  }
}

class ProjectListPageStage extends State<ProjectListPage>
    with AutomaticKeepAliveClientMixin {
  List<ProjectTreeListDatas> _datas = new List();
  int _page = 1;
  GlobalKey<EasyRefreshState> _easyRefreshKey =
      new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshHeaderState> _headerKey =
      new GlobalKey<RefreshHeaderState>();
  GlobalKey<RefreshFooterState> _footerKey =
      new GlobalKey<RefreshFooterState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData(true);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: new EasyRefresh(
      key: _easyRefreshKey,
      autoLoad: true,
      loadMore: () async {
        return _getData(false);
      },
      onRefresh: () {
        _page = 1;
        return _getData(true);
      },
      behavior: ScrollOverBehavior(),
      refreshHeader: ClassicsHeader(
        key: _headerKey,
        refreshText: "下拉刷新",
        refreshReadyText: "放开刷新",
        refreshingText: "正在刷新",
        refreshedText: "数据加载完成",
        bgColor: Colors.transparent,
        textColor: Colors.black87,
        moreInfoColor: Colors.black54,
        showMore: true,
      ),
      refreshFooter: BallPulseFooter(
        key: _footerKey,
      ),
      child: new ListView.builder(
        itemCount: _datas.length,
        itemBuilder: _renderRow,
      ),
    ));
  }

  Future<void> _getData(bool refresh) async {
    int _id = widget.id;
    ApiService.getProjectList((ProjectTreeListModel projectTreeListModel) {
      setState(() {
        if (projectTreeListModel.data.datas.length == 0) {
          _page = projectTreeListModel.data.curPage;
          Fluttertoast.showToast(msg: "没有更多数据了");
          return;
        }
        if (refresh) {
          _datas = projectTreeListModel.data.datas;
          _easyRefreshKey.currentState.callRefreshFinish();
        } else {
          _page = projectTreeListModel.data.curPage + 1;
          _datas.addAll(projectTreeListModel.data.datas);
          _easyRefreshKey.currentState.callLoadMoreFinish();
        }
      });
    }, _page, _id);
  }

  Widget _renderRow(BuildContext context, int index) {
    if (index < _datas.length) {
      return Card(
          elevation: 4.0,
          child: new InkWell(
            onTap: () {
              NavigatorUtil.pushWeb(context,
                  url: _datas[index].link, title: _datas[index].title);
            },
            child: Container(
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  _datas[index].title,
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF3D4E5F),
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  _datas[index].desc,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                  textAlign: TextAlign.left,
                                  maxLines: 3,
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                _datas[index].author,
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              Text(
                                _datas[index].niceDate,
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.fromLTRB(8, 16, 8, 8),
                      child: Image.network(
                        isWeb
                            ? _datas[index].envelopePic.replaceAll(
                                "https://www.wanandroid.com",
                                "http://localhost:4040")
                            : _datas[index].envelopePic,
                        width: 80,
                        height: 120,
                        fit: BoxFit.fill,
                      )),
                ],
              ),
            ),
          ));
    }
    return null;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
