import 'package:briefing/model/article.dart';
import 'package:briefing/model/news.dart';
import 'package:briefing/widget/article_thumbnail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

class ArticleTitleSection extends StatelessWidget {
  final Article article;

  const ArticleTitleSection({Key key, @required this.article})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 1.0),
                  title: Text(article.title ?? "",
                      softWrap: true,
                      style: Theme.of(context)
                          .textTheme
                          .subhead
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
//        if (article.imageUrl != null) ArticleThumbnail(article: article),
      ],
    );
  }
}
