import 'package:briefing/model/article.dart';
import 'package:briefing/model/live_tv.dart';
import 'package:briefing/model/screen_argument.dart';
import 'package:briefing/route/navigation_service.dart';
import 'package:briefing/service/locator.dart';
import 'package:briefing/widget/article_bottom_section.dart';
import 'package:briefing/widget/article_title_section.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class LiveTVCard extends StatefulWidget {
  final LiveTv article;

  const LiveTVCard({Key key, this.article}) : super(key: key);

  @override
  _LiveTVCardState createState() {
    return _LiveTVCardState();
  }
}

class _LiveTVCardState extends State<LiveTVCard> {
  final NavigationService _navigationService = locator<NavigationService>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: InkWell(
        borderRadius: BorderRadius.circular(0.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, mainAxisSize: MainAxisSize.max, children: <Widget>[
          Expanded(
            child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 1.0),
                  title: Text(widget.article.name ?? "",
                          softWrap: true,
                          style: Theme.of(context)
                                  .textTheme
                                  .subhead
                                  .copyWith(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ]),
          ),
          ClipRRect(
                  borderRadius: new BorderRadius.circular(5.0),
                  child: Stack(alignment: AlignmentDirectional.center, children: <Widget>[
                    (widget.article.image.isNotEmpty)
                            ? Image.network(widget.article.image,
                      width: 74,
                      height: 74,
                      fit: BoxFit.cover,
                    )
                            : Container(
                      width: 74,
                      height: 74,
                      color: Theme.of(context).textSelectionColor,
                    ),
                  ]))
        ]),
        onTap: () {
          _navigationService.navigateTo(Router.NewsVideoDetail,
                  arguments: new ScreenArgument(widget.article.name, widget.article.link));
        },
      ),
    );
  }
}
