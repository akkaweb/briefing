import 'package:briefing/model/article.dart';
import 'package:briefing/model/news.dart';
import 'package:briefing/widget/article_menu.dart';
import 'package:flutter/material.dart';
import 'package:briefing/widget/news_widget.dart';
import 'package:briefing/route/navigation_service.dart';
import 'package:briefing/service/locator.dart';

class ArticleBottomSection extends StatelessWidget {
  final Article article;

  ArticleBottomSection({Key key, @required this.article}) : super(key: key);

  final NavigationService _navigationService = locator<NavigationService>();

  @override
  Widget build(BuildContext context) {
    void _modalBottomSheetMenu() {
      showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return BottomSheetArticleMenu(article: article);
        },
      );
    }

    return Container(
      padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(children: <Widget>[
                InkWell(
                child: TextBackgroundRadius(
                  Text(
                    ((article is News) ? (article as News).categoryNews.name : article.source) ?? "",
                    maxLines: 1,
                    style: Theme.of(context).textTheme.subtitle.copyWith(color: Colors.white, fontSize: 10),
                  ),
                  radius: 20,
                  color: Theme.of(context).accentColor,
                ),
                onTap: () {
                  _navigationService.navigateTo(Router.NewsByCategory, arguments: (article as News).categoryNews);
                },),
              ]),
              Container(
                  margin: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        ((article is News) ? (article as News).publisher?.name : "") ?? "",
                        style: Theme.of(context)
                            .textTheme
                            .subtitle
                            .copyWith(fontSize: 12, color: Theme.of(context).accentColor),
                      )
                    ],
                  )),
              Container(
                  margin: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                  child: Row(
                    children: <Widget>[
                      Text(article.timeAgo, style: Theme.of(context).textTheme.subtitle.copyWith(fontSize: 12))
                    ],
                  )),
            ],
          )
        ],
      ),
    );
  }
}
