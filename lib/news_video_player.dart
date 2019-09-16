import 'package:briefing/route/navigation_service.dart';
import 'package:briefing/service/locator.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class NewsVideoPlayer extends StatefulWidget {
  final String link;

  NewsVideoPlayer(this.link);

  @override
  _NewsVideoPlayerState createState() => _NewsVideoPlayerState(this.link);
}

class _NewsVideoPlayerState extends State<NewsVideoPlayer> {
  VideoPlayerController _controller;

  final String link;

  _NewsVideoPlayerState(this.link);

  Future<void> _initializeVideoPlayerFutre;
  NavigationService _navigationService = locator<NavigationService>();
  int numberRetry = 0;

  @override
  void initState() {
    super.initState();
    _setupController();
  }

  void _setupController() {
    _controller = VideoPlayerController.network(link);
    _initializeVideoPlayerFutre = _controller.initialize().then((_) {
      // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      setState(() {
        _controller.play();
      });
    }).catchError((_) {
      numberRetry++;
      if (numberRetry < 4) {
        _setupController();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video',
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Video",
            style: Theme.of(context)
                .textTheme
                .subhead
                .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
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
        body: FutureBuilder(
            future: _initializeVideoPlayerFutre,
            builder: (content, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Icon(
            _controller.value.isPlaying
                ? Icons.pause
                : Icons.play_circle_outline,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
