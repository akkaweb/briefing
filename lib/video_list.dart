import 'dart:async';

import 'package:briefing/bloc/bloc_article.dart';
import 'package:briefing/briefing_card.dart';
import 'package:briefing/model/article.dart';
import 'package:flutter/material.dart';

class VideoList extends StatefulWidget {
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
