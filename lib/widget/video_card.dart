import 'package:briefing/model/article.dart';
import 'package:briefing/model/news.dart';
import 'package:briefing/model/screen_argument.dart';
import 'package:briefing/route/navigation_service.dart';
import 'package:briefing/service/locator.dart';
import 'package:briefing/widget/article_bottom_section.dart';
import 'package:briefing/widget/article_title_section.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class VideoCard extends StatefulWidget {
  final News article;

  const VideoCard({Key key, this.article}) : super(key: key);

  @override
  VideoCardState createState() {
    return VideoCardState();
  }
}

class VideoCardState extends State<VideoCard> {
  final NavigationService _navigationService = locator<NavigationService>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: InkWell(
        borderRadius: BorderRadius.circular(0.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ClipRRect(
                  borderRadius: new BorderRadius.circular(5.0),
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: 3 / 2.0,
                        child: CachedNetworkImage(
                          imageUrl: widget.article.thumbUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Center(
                          child: Icon(
                        Icons.play_circle_outline,
                        color: Colors.white,
                        size: 72,
                      ))
                    ],
                  )),
              ArticleTitleSection(article: widget.article),
              ArticleBottomSection(article: widget.article),
            ]),
        onTap: () {
          News news = widget.article;
          _navigationService.navigateTo(Router.NewsVideoDetail,
                  arguments: new ScreenArgument("", news.videoUrl));
        },
      ),
    );
  }
}
