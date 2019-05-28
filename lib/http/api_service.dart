import 'package:dio/dio.dart';
import 'package:flutter_app/model/article_model.dart';
import 'package:flutter_app/model/banner_model.dart';
import 'package:flutter_app/model/project_tree_model.dart';
import 'package:flutter_app/model/projectlist_model.dart';
import 'package:flutter_app/model/tree_model_entity.dart';
import 'package:flutter_app/model/wx_article_content_model.dart';
import 'package:flutter_app/model/wx_article_model_entity.dart';

import 'api.dart';
import 'dio_manager.dart';

class ApiService {
  static void getArticleList(Function callback, Function errorback, int _page,
      [CancelToken token]) async {
    return DioManager.singleton.dio
        .get(Api.HOME_ARTICLE_LIST + "$_page/json", cancelToken: token)
        .then((response) {
      callback(ArticleModel(response.data));
    }).catchError((e) {
      errorback(e);
    });
  }

  static void getBanner(Function callback, Function errorback,
      [CancelToken token]) async {
    return DioManager.singleton.dio
        .get(Api.HOME_BANNER, cancelToken: token)
        .then((response) {
      callback(BannerModel(response.data));
    }).catchError((e) {
      errorback(e);
    });
  }

  static void getSystemTree(Function callback, Function errorback,
      [CancelToken token]) async {
    DioManager.singleton.dio
        .get(Api.SYSTEM_TREE, cancelToken: token)
        .then((response) {
      callback(TreeModelEntity(response.data));
    }).catchError((e) {
      errorback(e);
    });
  }

  static void getWxTitleList(Function callback, Function errorback,
      [CancelToken token]) async {
    DioManager.singleton.dio
        .get(Api.WX_LIST, cancelToken: token)
        .then((response) {
      callback(WxArticleModelEntity(response.data));
    }).catchError((e) {
      errorback(e);
    });
  }

  static void getWxArticleList(Function callback, int _id, int _page,
      [CancelToken token]) async {
    DioManager.singleton.dio
        .get(Api.WX_ARTICLE_LIST + "$_id/$_page/json", cancelToken: token)
        .then((response) {
      callback(WxArticleContentModel(response.data));
    });
  }

  /// 获取项目分类
  static void getProjectTree(Function callback, Function errorback,
      [CancelToken token]) async {
    DioManager.singleton.dio
        .get(Api.PROJECT_TREE, cancelToken: token)
        .then((response) {
      callback(ProjectTreeModel(response.data));
    }).catchError((e) {
      errorback(e);
    });
  }

  static void getProjectList(Function callback, int _page, int _id) async {
    DioManager.singleton.dio
        .get(Api.PROJECT_LIST + "$_page/json?cid=$_id")
        .then((response) {
      callback(ProjectTreeListModel(response.data));
    });
  }
}
