import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/model/article_model.dart';
import 'package:flutter_app/model/tree_model_entity.dart';
import 'package:flutter_app/util/navigator_util.dart';

class KnowledgeItem extends StatelessWidget {
  TreeModelData itemData;
  static const List colors = [
    Colors.blue,
    Colors.amber,
    Colors.green,
    Colors.pink,
    Colors.cyan
  ];

  KnowledgeItem(var itemData) {
    this.itemData = itemData;
  }

  @override
  Widget build(BuildContext context) {
    Container container = new Container(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: new Text(
                    itemData.name,
                    softWrap: true,
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                ),
                buildChildren(itemData.children),
              ],
            ),
          ),
          Icon(Icons.chevron_right)
        ],
      ),
    );
    return Card(

      elevation: 4.0,
      child: InkWell(
        child: container,
        onTap: () {
//          NavigatorUtil.pushWeb(context,
//              url: itemData.link, title: itemData.title);
        },
      ),
    );
  }

  Widget buildChildren(List<TreeModelDatachild> children) {
    List<Widget> titles = [];
    Random random = new Random(colors.length);
    for (var item in children) {
      titles.add(
        Container(
            padding: new EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            //给最外层添加padding,
            decoration: BoxDecoration(
                color: colors[random.nextInt(colors.length)],
                borderRadius: BorderRadius.circular(20.0)),
            child: Text(
              item.name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            )),
      );
    }
    return Wrap(
        spacing: 12,
        runSpacing: 12,
        alignment: WrapAlignment.start,
        children: titles);
  }
}
