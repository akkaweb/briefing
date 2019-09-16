import 'package:briefing/model/article.dart';
import 'package:briefing/model/news.dart';
import 'package:briefing/model/screen_argument.dart';
import 'package:briefing/route/navigation_service.dart';
import 'package:briefing/service/locator.dart';
import 'package:briefing/widget/article_bottom_section.dart';
import 'package:briefing/widget/article_title_section.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

class BriefingCard extends StatefulWidget {
  final Article article;

  const BriefingCard({Key key, this.article}) : super(key: key);

  @override
  BriefingCardState createState() {
    return BriefingCardState();
  }
}

class BriefingCardState extends State<BriefingCard> {
  final NavigationService _navigationService = locator<NavigationService>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 4.0),
      padding: EdgeInsets.fromLTRB(4.0, 0.0, 4.0, 4.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
                InkWell(
                  borderRadius: BorderRadius.circular(0.0),
                  child: ArticleTitleSection(article: widget.article),
                  onTap: () {
                    if (widget.article is News) {
                      final News news = widget.article as News;
                      _navigationService.navigateTo(Router.NewsDetail,
                          arguments:
                              new ScreenArgument(news.title, "${news.id}"));
                    } else
                      _launchURL(context, widget.article.url);
                  },
                ),
                ArticleBottomSection(article: widget.article),
              ]),
            ),
            ClipRRect(
              borderRadius: new BorderRadius.circular(5.0),
              child: (widget.article is News &&
                      (widget.article as News).hasImage == 1)
                  ? CachedNetworkImage(
                      imageUrl: (widget.article as News).thumbUrl,
                      width: 74,
                      height: 74,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 74,
                      height: 74,
                      color: Theme.of(context).textSelectionColor,
                    ),
            ),
          ]),
    );
  }

  void _launchURL(BuildContext context, String link) async {
    try {
      await launch(
        link,
        option: new CustomTabsOption(
          toolbarColor: Theme.of(context).primaryColor,
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: true,
          animation: CustomTabsAnimation.slideIn(),
          extraCustomTabs: <String>[
            // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
            'org.mozilla.firefox',
          ],
        ),
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
  }
}
