import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gedu_bilibli/model/bilibli_recommend.dart';
import 'package:gedu_bilibli/model/bilibli_recommend_banner.dart';
import 'package:gedu_bilibli/net/http_provider.dart';
import 'package:banner/banner.dart';

class RecommendListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RecommendListPageState();
}

class RecommendListPageState extends State<RecommendListPage> {
  BiliBliProvider biliBliProvider;
  List<RecommendInfo> _recommendInfos = List();
  List<RecommendBanner> _recommendBanner = List();
  @override
  void initState() {
    biliBliProvider = BiliBliProvider();
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = List();
    if (_recommendBanner.length > 0) {
      widgets.add(SliverToBoxAdapter(
        child: new BannerView(
          height: 120.0,
          data: _recommendBanner,
          buildShowView: (index, data) {
            return new Image.network(
              data.image,
              fit: BoxFit.cover,
            );
          },
          onBannerClickListener: (index, data) {
            print(index);
          },
        ),
      ));
    }
    for (int i = 0; i < _recommendInfos.length; i++) {
      widgets.add(new SliverToBoxAdapter(
          child: new _headView(
        headBean: _recommendInfos[i].head,
      )));
      widgets.add(SliverGrid.count(
        crossAxisCount: 2,
        children: _recommendInfos[i]
            .body
            .map((BodyBean body) => Card(
                  margin: new EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 15.0),
                  elevation: 2.0,
                  child: InkWell(
                    onTap: () {},
                    child: Column(
                      children: <Widget>[
                        FadeInImage.assetNetwork(
                          fadeInDuration: Duration(milliseconds: 300),
                          fadeOutDuration: Duration(milliseconds: 100),
                          image: body.cover,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 110.0,
                          placeholder: 'images/placeholder.jpg',
                        ),
                        new Container(
                          height: 70.0,
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                child: new Text(
                                  body.title == null ? "" : body.title,
                                  maxLines: 2,
                                ),
                                padding:
                                    EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                              ),
                              new Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  new Padding(
                                    padding: new EdgeInsets.fromLTRB(
                                        10.0, 0.0, 10.0, 0.0),
                                    child: new Image.asset(
                                      _recommendInfos[i].type == 'live'
                                          ? "images/ic_play_circle_outline_black_24dp.png"
                                          : "images/ic_play_circle_outline_black_24dp.png",
                                      width: 20.0,
                                      height: 20.0,
                                    ),
                                  ),
                                  new Text(_recommendInfos[i].type == 'live'
                                      ? body.up
                                      : body.play == null ? "" : body.play),
                                  new Padding(
                                    padding: new EdgeInsets.fromLTRB(
                                        20.0, 0.0, 10.0, 0.0),
                                    child: new Image.asset(
                                      _recommendInfos[i].type == 'live'
                                          ? "images/ic_watching.png"
                                          : "images/ic_subtitles_black_24dp.png",
                                      width: 20.0,
                                      height: 20.0,
                                    ),
                                  ),
                                  new Text(_recommendInfos[i].type == 'live'
                                      ? body.online.toString()
                                      : body.danmaku == null
                                          ? ""
                                          : body.danmaku),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ))
            .toList(),
      ));
    }
    return new CustomScrollView(
      shrinkWrap: true,
      slivers: widgets,
    );
  }

  void _loadData() async {
    var infos = await biliBliProvider.fetchRecommendInfoListModel();
     var banners = await biliBliProvider.fetchRecommendBannerListModel();

    banners.map((RecommendBanner banner) {
      print(banner.title);
    }).toList();
    setState(() {
      _recommendInfos.addAll(infos);
      _recommendBanner.addAll(banners);
    });
  }

}

class _headView extends StatelessWidget {
  final HeadBean headBean;

  const _headView({
    Key key,
    @required this.headBean,
  })  : assert(headBean != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: new EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            headBean.title,
            textAlign: TextAlign.center,
          ),
          GestureDetector(
            child: const Text('更多'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class RecommendInfoItem extends StatefulWidget {
  final List<BodyBean> bodyBeanList;

  const RecommendInfoItem({
    Key key,
    @required this.bodyBeanList,
  })  : assert(bodyBeanList != null),
        super(key: key);
  @override
  State<StatefulWidget> createState() {
    return new RecommendInfoItemState();
  }
}

class RecommendInfoItemState extends State<RecommendInfoItem> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      children: widget.bodyBeanList.map((BodyBean body) {
        return new Text(body.title);
      }).toList(),
    );
  }
}
