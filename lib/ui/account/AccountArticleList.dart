import 'package:flutter/material.dart';
import 'package:flutter_app/http/api_service.dart';
import 'package:flutter_app/model/wx_article_content_model.dart';
import 'package:flutter_app/ui/weights/listview_root.dart';
import 'package:flutter_app/util/navigator_util.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AccountArticleList extends StatefulWidget {
  final int id;

  AccountArticleList(this.id);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AccountArticleListState();
  }
}

class AccountArticleListState extends State<AccountArticleList>
    with AutomaticKeepAliveClientMixin {
  List<WxArticleContentDatas> _datas = new List();
  ScrollController _scrollController = ScrollController();
  int _page = 1;
  bool loadmore = true;
  bool showToTopBtn = false; //是否显示“返回到顶部”按钮

  Future<Null> _getData() async {
    _page = 1;
    loadmore = true;
    int _id = widget.id;
    ApiService.getWxArticleList((WxArticleContentModel _wxArticleContentModel) {
      setState(() {
        _datas.clear();
        _datas = _wxArticleContentModel.data.datas;
      });
    }, _id, _page);
  }

  Future<Null> _getMore() async {
    int _id = widget.id;
    ApiService.getWxArticleList((WxArticleContentModel _articleContentModel) {
      setState(() {
        if (_articleContentModel.data.datas.length > 0) {
          _page = _articleContentModel.data.curPage + 1;
          _datas.addAll(_articleContentModel.data.datas);
        } else {
          loadmore = false;
          Fluttertoast.showToast(msg: "没有更多数据了");
        }
      });
    }, _id, _page);
  }

  @override
  void initState() {
    super.initState();
    _getData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMore();
      }
    });

    _scrollController.addListener(() {
      //当前位置是否超过屏幕高度
      if (_scrollController.offset < 200 && showToTopBtn) {
        setState(() {
          showToTopBtn = false;
        });
      } else if (_scrollController.offset >= 200 && showToTopBtn == false) {
        setState(() {
          showToTopBtn = true;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        displacement: 15,
        onRefresh: _getData,
        child: ListView.builder(
            physics: new AlwaysScrollableScrollPhysics(),
            itemBuilder: _renderRow,
            controller: _scrollController,
            //包含加载更多
            itemCount: _datas.length + 1),
      ),
      floatingActionButton: !showToTopBtn
          ? null
          : FloatingActionButton(
              child: Icon(Icons.arrow_upward),
              onPressed: () {
                //返回到顶部时执行动画
                _scrollController.animateTo(.0,
                    duration: Duration(milliseconds: 200), curve: Curves.ease);
              }),
    );
  }

  Widget _renderRow(BuildContext context, int index) {
    if (index == _datas.length && loadmore) {
      return ListviewRoot();
    }
    if (index < _datas.length) {
      bool isCollect = _datas[index].collect;
      return Card(
        elevation: 4.0,
        child: new InkWell(
          onTap: () {
            NavigatorUtil.pushWeb(context,
                url: _datas[index].link, title: _datas[index].title);
          },
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: <Widget>[
                    Text(
                      _datas[index].author,
                      style: TextStyle(fontSize: 12),
                      textAlign: TextAlign.left,
                    ),
                    Expanded(
                      child: Text(
                        _datas[index].niceDate,
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
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
                color: Colors.white,
                padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        _datas[index].superChapterName,
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isCollect ? Icons.favorite : Icons.favorite_border,
                        color: isCollect ? Colors.red : null,
                      ),
                      onPressed: () {
                        //处理点击事件
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    return null;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
