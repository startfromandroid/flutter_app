import 'package:flutter_app/model/tree_model_entity.dart';
import 'package:flutter_app/model/wx_article_model_entity.dart';

class EntityFactory {
  static T generateOBJ<T>(json) {
    if (1 == 0) {
      return null;
    } else if (T.toString() == "TreeModelEntity") {
      return TreeModelEntity.fromJson(json) as T;
    } else if (T.toString() == "WxArticleModelEntity") {
      return WxArticleModelEntity.fromJson(json) as T;
    } else {
      return null;
    }
  }
}