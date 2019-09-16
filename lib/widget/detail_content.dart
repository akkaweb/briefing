import 'package:briefing/model/news.dart';
import 'package:briefing/model/screen_argument.dart';
import 'package:briefing/route/navigation_service.dart';
import 'package:briefing/service/locator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DetailContent extends StatelessWidget {
  final NewsContent content;

  DetailContent(this.content) : super();

  NavigationService _navigationService = locator<NavigationService>();

  @override
  Widget build(BuildContext context) {
    if ("video" == content.type) {
      return InkWell(
          onTap: () {
            _navigationService.navigateTo(Router.NewsVideoDetail,
                arguments: new ScreenArgument("", content.data.content));
          },
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              AspectRatio(
                aspectRatio: double.parse(content.data.width) /
                    double.parse(content.data.height),
                child: CachedNetworkImage(
                  imageUrl: content.data.image,
                  fit: BoxFit.cover,
                ),
              ),
              Center(child: Icon(Icons.play_circle_outline))
            ],
          ));
    }
    if ("image" == content.type) {
      return AspectRatio(
        aspectRatio: double.parse(content.data.width) /
            double.parse(content.data.height),
        child: CachedNetworkImage(
          imageUrl: content.data.content,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Text(
        content.data.content,
        style: Theme.of(context).textTheme.body2.copyWith(
              fontSize: 16,
            ),
      );
    }
  }
}
