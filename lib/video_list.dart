import 'package:flutter/material.dart';

class VideoList extends StatefulWidget {
  const VideoList({Key key}) : super(key: key);

  @override
  _VideoState createState() {
    return _VideoState();
  }
}

class _VideoState extends State<VideoList> {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 64.0),
          child: Center(
            child: Text('Video is comming soon...',
                style: TextStyle(fontSize: 22)),
          ),
        )
      ]),
    );
  }
}
