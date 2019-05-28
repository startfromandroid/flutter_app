import 'package:flutter/material.dart';
import 'package:flutter_app/style/TextStyles.dart';
import 'package:flutter_app/util/navigator_util.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebScaffold extends StatefulWidget {
  const WebScaffold({
    Key key,
    this.title,
    this.titleId,
    this.url,
  }) : super(key: key);

  final String title;
  final String titleId;
  final String url;

  @override
  State<StatefulWidget> createState() {
    return new WebScaffoldState();
  }
}

class WebScaffoldState extends State<WebScaffold> {

  void _onPopSelected(String value) {
    switch (value) {
      case "browser":
        NavigatorUtil.launchInBrowser(widget.url,
            title: widget.title ?? widget.titleId);
        break;
      case "collection":

        break;

      case "share":
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isCollect = false;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          widget.title ?? widget.titleId,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                isCollect ? Icons.favorite : Icons.favorite_border,
                color: isCollect ? Colors.red : null,
              ),
              onPressed: () {
                //处理点击事件
              }),
          new PopupMenuButton(
              padding: const EdgeInsets.all(0.0),
              onSelected: _onPopSelected,
              itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                    new PopupMenuItem<String>(
                        value: "browser",
                        child: ListTile(
                            contentPadding: EdgeInsets.all(0.0),
                            dense: false,
                            title: new Container(
                              alignment: Alignment.center,
                              child: new Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.language,
                                    color: Colors.grey,
                                    size: 22.0,
                                  ),
                                  new SizedBox(width: 10),
                                  Text(
                                    '浏览器打开',
                                    style: TextStyles.listContent,
                                  )
                                ],
                              ),
                            ))),
                    new PopupMenuItem<String>(
                        value: "share",
                        child: ListTile(
                            contentPadding: EdgeInsets.all(0.0),
                            dense: false,
                            title: new Container(
                              alignment: Alignment.center,
                              child: new Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.share,
                                    color: Colors.grey,
                                    size: 22.0,
                                  ),
                                  new SizedBox(width: 10),
                                  Text(
                                    '分享',
                                    style: TextStyles.listContent,
                                  )
                                ],
                              ),
                            ))),
                  ])
        ],
      ),
      body: new WebView(
        onWebViewCreated: (WebViewController webViewController) {},
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
