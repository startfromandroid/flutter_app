import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/http/api_service.dart';
import 'package:flutter_app/model/article_model.dart';
import 'package:flutter_app/ui/home/HomeBanner.dart';
import 'package:flutter_app/ui/home/article_item.dart';
import 'package:flutter_app/ui/weights/listview_root.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  List<Article> _datas = new List();
  CancelToken cancelToken = new CancelToken();

  ScrollController _scrollController;

  bool showToTop = false;
  int _page = 1;
  bool loadmore = true;

  Widget bulidHomeList() {
    return ListView.builder(
      itemBuilder: _bulidRow,
      itemCount: _datas.length + 2,
      controller: _scrollController,
    );
  }

  Widget _bulidRow(BuildContext context, int index) {
    if (index == 0) {
      return Container(
        height: 200,
        child: BannerWidget(),
      );
    }
    if (index < _datas.length+1) {
      return ArticleItem(_datas[index-1]);
    }
    if (index == _datas.length+1 && loadmore) {
      return ListviewRoot();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('首页'),
        centerTitle: true,
      ),
//      body: NestedScrollView(
//        controller: _scrollController,
//        headerSliverBuilder: _sliverBuilder,
      body: new RefreshIndicator(child: bulidHomeList(), onRefresh: getData),
//        body: bulidHomeList(),
//      ),
      floatingActionButton: !showToTop
          ? null
          : FloatingActionButton(
              child: Icon(Icons.arrow_upward),
              onPressed: () {
                //返回到顶部时执行动画
                _scrollController.animateTo(.0,
                    duration: Duration(milliseconds: 400), curve: Curves.ease);
              }),
    );
  }

  List<Widget> _sliverBuilder(BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      SliverAppBar(
        expandedHeight: 200.0,
        //展开高度200
        floating: true,
        //是否随着滑动隐藏标题
        primary: false,
        //是否预留高度
        pinned: false,
        //固定在顶部
        backgroundColor: Colors.transparent,
        flexibleSpace: FlexibleSpaceBar(
//          centerTitle: true,
//          title: Text('我是一个FlexibleSpaceBar'),
          background: Container(
            height: 200,
            child: BannerWidget(),
          ),
        ),
      )
    ];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addListener();
    getData();
  }

  @override
  void dispose() {
    // TODO: implement dispose 页面销毁取消请求
    if (cancelToken != null && !cancelToken.isCancelled) {
      cancelToken.cancel("cancelled");
    }
    _scrollController.dispose();
    super.dispose();
  }

  //获取文章列表数据
  Future<Null> getData() async {
    _page = 1;
    loadmore = true;
    ApiService.getArticleList((ArticleModel _articleModel) {
      if (_articleModel.errorCode == 0) {
        //成功
        if (_articleModel.data.datas.length > 0) {
          //有数据
          setState(() {
            _datas.clear();
            _datas.addAll(_articleModel.data.datas);
          });
        } else {
          //数据为空
          showEmpty();
        }
      } else {}
    }, (DioError error) {
      //发生错误
      print(error.response);
      setState(() {
        showError();
      });
    }, _page, cancelToken);
  }

  Future<Null> _getMore() async {
    _page++;
    ApiService.getArticleList((ArticleModel _articleModel) {
      if (_articleModel.errorCode == 0) {
        //成功
        if (_articleModel.data.datas.length > 0) {
          setState(() {
            _datas.addAll(_articleModel.data.datas);
          });
        } else {
          loadmore = false;
          Fluttertoast.showToast(msg: "没有更多数据了");
        }
      } else {
        Fluttertoast.showToast(msg: _articleModel.errorMsg);
      }
    }, (DioError error) {
      //发生错误
      print(error.response);
      setState(() {
        showError();
      });
    }, _page);
  }

  void showError() {}

  void showEmpty() {}

  void addListener() {
    _scrollController = ScrollController()
      ..addListener(() {
        //滑到了底部，加载更多
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          _getMore();
        }
        //当前位置是否超过屏幕高度
        if (_scrollController.offset < 200 && showToTop) {
          setState(() {
            showToTop = false;
          });
        } else if (_scrollController.offset >= 200 && showToTop == false) {
          setState(() {
            showToTop = true;
          });
        }
      });
  }
}
