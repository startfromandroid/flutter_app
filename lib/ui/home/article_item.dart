import 'package:flutter/material.dart';
import 'package:flutter_app/model/article_model.dart';
import 'package:flutter_app/util/navigator_util.dart';

class ArticleItem extends StatelessWidget {
  Article itemData;

  ArticleItem(var itemData) {
    this.itemData = itemData;
  }

  @override
  Widget build(BuildContext context) {
    bool isCollect = itemData.collect;

    Row author = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Expanded(
            child: Row(
          children: <Widget>[
            Text('作者:  '),
            Text(
              itemData.author,
              style: TextStyle(color: Theme.of(context).accentColor),
            ),
          ],
        )),
        Text(
          itemData.niceDate,
          style: TextStyle(color: Theme.of(context).accentColor),
        )
      ],
    );

    Row title = Row(
      children: <Widget>[
        Expanded(
          child: Text.rich(
            TextSpan(text: itemData.title),
            softWrap: true,
            style: TextStyle(fontSize: 16.0, color: Colors.black),
            textAlign: TextAlign.left,
          ),
        )
      ],
    );

    Row chapterName = Row(
//      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: Text(
            itemData.chapterName,
            softWrap: true,
            style: TextStyle(color: Theme.of(context).accentColor),
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
    );

    Column column = Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
          child: author,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 0.0),
          child: title,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
          child: chapterName,
        ),
      ],
    );

    return Card(
      elevation: 4.0,
      child: InkWell(
        child: column,
        onTap: () {
          NavigatorUtil.pushWeb(context,
              url: itemData.link, title: itemData.title);
        },
      ),
    );
  }
}
