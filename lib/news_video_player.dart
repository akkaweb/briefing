import 'package:briefing/route/navigation_service.dart';
import 'package:briefing/service/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:briefing/theme/theme.dart';

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

    return Theme(
            data: Theme.of(context).copyWith(
        // Set the transparency here
                backgroundColor: Colors.black54,
        scaffoldBackgroundColor: Colors.black54,
        dialogBackgroundColor: Colors.black54,
        canvasColor: Colors.black54, //or any other color you want. e.g Colors.blue.withOpacity(0.5)
    ), child: AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        statusBarColor: Colors.black54,
        systemNavigationBarColor: Colors.black54,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Text(
            "Video",
            style: Theme.of(context)
                .textTheme
                .subhead
                .copyWith(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              semanticLabel: 'back',
              color: Colors.white,
            ),
            onPressed: () {
              _navigationService.goBack();
            },
          ),
        ),
        backgroundColor: Colors.black54,
        body: FutureBuilder(
            future: _initializeVideoPlayerFutre,
            builder: (content, snapshot) {
              return Center( child: (snapshot.connectionState == ConnectionState.done) ?
                AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ) :
                CircularProgressIndicator());}),
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
            color: Colors.white,
          ),
        ),
      ),
    ));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
