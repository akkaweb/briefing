import 'package:briefing/model/article.dart';
import 'package:briefing/model/news.dart';
import 'package:briefing/model/screen_argument.dart';
import 'package:briefing/route/navigation_service.dart';
import 'package:briefing/service/locator.dart';
import 'package:briefing/widget/article_bottom_section.dart';
import 'package:briefing/widget/article_title_section.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class VideoCard extends StatefulWidget {
  final News article;
  final bool isPlaying;

  const VideoCard({Key key, this.article, this.isPlaying = false}) : super(key: key);

  @override
  VideoCardState createState() {
    return VideoCardState();
  }
}

class VideoCardState extends State<VideoCard> {
  final NavigationService _navigationService = locator<NavigationService>();
  VideoPlayerController _controller;

  Future<void> _initializeVideoPlayerFutre;
  int numberRetry = 0;

  void _setupController() {
    print("setup Controller");
    _controller = VideoPlayerController.network(widget.article.videoUrl);
    _initializeVideoPlayerFutre = _controller.initialize().then((_) {
      print("Inited");
      _controller.play();
    }).catchError((error) {
      print(error);
    });
  }

  @override
  void initState() {
    print("isPlaying ${widget.isPlaying}");
    if(widget.isPlaying) {
      _setupController();
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.isPlaying && _controller == null) {
      _setupController();
    }
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
                        child: widget.isPlaying ? FutureBuilder(
                            future: _initializeVideoPlayerFutre,
                            builder: (content, snapshot) {
                              return Center( child: (snapshot.connectionState == ConnectionState.done) ?
                              AspectRatio(
                                aspectRatio: _controller.value.aspectRatio,
                                child: VideoPlayer(_controller),
                              ) :
                              CircularProgressIndicator());}): CachedNetworkImage(
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
