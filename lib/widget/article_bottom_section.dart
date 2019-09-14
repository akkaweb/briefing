import 'package:briefing/model/article.dart';
import 'package:briefing/model/news.dart';
import 'package:briefing/widget/article_menu.dart';
import 'package:flutter/material.dart';

class ArticleBottomSection extends StatelessWidget {
  final Article article;

  const ArticleBottomSection({Key key, @required this.article})
      : super(key: key);

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
                ChoiceChip(
                    selectedColor: Theme.of(context).accentColor,
                    label: Text(
                      ((article is News)
                              ? (article as News).categoryNews.name
                              : article.source) ??
                          "",
                      maxLines: 1,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle
                          .copyWith(color: Colors.white, fontSize: 12),
                    ),
                    selected: true,
                    onSelected: (val) {}),
              ]),
              Container(
                margin: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
                  child: Row(
                children: <Widget>[
                  Text(article.timeAgo,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle
                          .copyWith(fontSize: 12))
                ],
              )),
            ],
          )
        ],
      ),
    );
  }
}
