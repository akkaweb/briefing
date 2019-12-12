import 'package:briefing/base/base_stateless.dart';
import 'package:briefing/briefing_card.dart';
import 'package:briefing/model/news.dart';
import 'package:briefing/news_list.dart' as list;
import 'package:briefing/route/navigation_service.dart';
import 'package:briefing/service/locator.dart';
import 'package:briefing/theme/theme.dart';
import 'package:briefing/viewmodels/detail_viewmodel.dart';
import 'package:briefing/widget/article_bottom_section.dart';
import 'package:briefing/widget/detail_content.dart';
import 'package:briefing/widget/news_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(Detail());
}

class Detail extends BaseStateless {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Báo đây',
      theme: buildAppTheme(),
      home: DetailPage(title: 'Báo đây'),
    );
  }
}

class DetailPage extends StatefulWidget {
  DetailPage({Key key, this.title, this.id}) : super(key: key);
  final String title;
  final String id;

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final NavigationService _navigationService = locator<NavigationService>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      builder: (context) => DetailViewModel(widget.id),
      child: Consumer<DetailViewModel>(
        builder: (context, model, child) => AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light,
              statusBarColor: Theme.of(context).primaryColor,
              systemNavigationBarColor: Colors.white,
              systemNavigationBarIconBrightness: Brightness.dark,
            ),
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  widget.title,
                  style: Theme.of(context).textTheme.subhead.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    semanticLabel: 'back',
                  ),
                  onPressed: () {
                    _navigationService.goBack();
                  },
                ),
              ),
              key: _scaffoldKey,
              body: SingleChildScrollView(
                  padding: new EdgeInsets.all(16),
                  child: model.busy
                      ? LoadingView()
                      : (model.hasErrorMessage && model.news == null
                          ? new Center(
                              child: GestureDetector(
                                child: list.ErrorWidget(message: ['${model.errorMessage}']),
                              ),
                            )
                          : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 1.0),
                                    title: Text(model.news?.title ?? "",
                                        softWrap: true,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subhead
                                            .copyWith(fontWeight: FontWeight.bold, fontSize: 16)),
                                  ),
                                ),
                                ArticleBottomSection(article: model.news),
                                ListView.separated(
                                  padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 16.0),
                                  physics: ScrollPhysics(),
                                  separatorBuilder: (BuildContext context, int index) {
                                    return Divider(
                                      color: Colors.white,
                                    );
                                  },
                                  shrinkWrap: true,
                                  itemCount: model.news.newContent.length +
                                      1 +
                                      (model.isLoadRelate ? 1 : (model.listRelateNews?.length ?? 0)),
                                  itemBuilder: (BuildContext context, int index) {
                                    int contentLength = model.news.newContent.length;
                                    if (index == contentLength) {
                                      return TitleRelate("Tin liên quan");
                                    } else
                                    if (model.isLoadRelate && index == contentLength + 1) {
                                      return LoadingView();
                                    } else if (index > contentLength) {
                                      News news = model.listRelateNews?.elementAt(index - contentLength - 1) ?? News();
                                      return BriefingCard(
                                        article: news,
                                      );
                                    } else
                                      return DetailContent(model.news.newContent[index]);
                                  },
                                )
                              ],
                            ))),
            )),
      ),
    );
  }
}

class TitleRelate extends StatelessWidget {

  final String title;

  TitleRelate(this.title);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Text(
          title,
          style: Theme.of(context).textTheme.title.copyWith(color: Theme.of(context).accentColor),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(bottom: 6),
            height: 4,
            color: Theme.of(context).accentColor,
          ),
        )
      ],
    );
  }
}
