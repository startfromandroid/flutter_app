import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/http/api_service.dart';
import 'package:flutter_app/http/dio_manager.dart';
import 'package:flutter_app/model/banner_model.dart';
import 'package:flutter_app/util/navigator_util.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class BannerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BannerWidgetState();
  }
}

class BannerWidgetState extends State<BannerWidget> {
  List<BannerData> _bannerList = new List();

  @override
  void initState() {
    _bannerList.add(null);
    _getBanner();
  }

  Future<Null> _getBanner() {
    ApiService.getBanner((BannerModel _bannerModel) {
      if (_bannerModel.data.length > 0) {
        setState(() {
          _bannerList = _bannerModel.data;
        });
      }
    }, (DioError error) {
      print(error.response);
    });
  }

  Widget buildItemImageWidget(BuildContext context, int index) {
    return new InkWell(
      onTap: () {
        NavigatorUtil.pushWeb(context,
            url: _bannerList[index].url, title: _bannerList[index].title);
      },
      child: new Container(
        child: new Image.network(
          isWeb
              ? _bannerList[index].imagePath.replaceAll(
                  "https://www.wanandroid.com", "http://localhost:4040")
              : _bannerList[index].imagePath,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Swiper(
      itemBuilder: (BuildContext context, int index) {
        if (_bannerList[index] == null ||
            _bannerList[index].imagePath == null) {
          return new Container(
            color: Colors.blueGrey,
          );
        } else {
          return buildItemImageWidget(context, index);
        }
      },
      itemCount: _bannerList.length,
      autoplay: true,
      pagination: new SwiperPagination(),
      viewportFraction: 0.8,
      scale: 0.9,
    );
    ;
  }
}
