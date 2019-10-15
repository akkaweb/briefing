import 'package:briefing/viewmodels/base_model.dart';
import 'package:briefing/model/news.dart';
import 'package:briefing/model/live_tv.dart';
import 'package:briefing/repository/repository.dart';
import 'package:briefing/model/response.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class TVViewModel extends BaseModel {

  TVViewModel(): super() {
    getTV();
  }
  
  String _nextPage;

  List<LiveTv> _listVideos;

  List<LiveTv> get listVideos => _listVideos;

  bool get canLoadmore => _nextPage?.isNotEmpty == true;
  
  Future<void> getTV() async {
    setBusy(true);
    _listVideos = List();
    try {
      final response = await http.get("https://raw.githubusercontent.com/iptv-org/iptv/master/categories/sport.m3u");
      final splits = response.body.split("\n");
      print('=== API::getTV::Success ${response.body}');
      String name = "";
      String image = "";
      for (String split in splits) {
        if (split.startsWith("#EXTM3U")) continue;
        if (split.startsWith("#EXTINF")) {
          print('=== API::getTV::Split ${split}');
          final splits2 = split.split(",");
          if (splits2.length >= 2) {
            name = splits2[1];
            print('=== API::getTV::Name ${name}');
            final split3 = split.split("tvg-logo=\"");
            if (split3.length == 2) {
              image = split3[1].split("\"")[0];
              print('=== API::getTV::Image ${image}');
            }
          } else {
            image = "";
            name = "Unknown";
          }
        } else {
          if (split.endsWith("m3u8")) {
            print('=== API::getTV::Link ${split}');
            _listVideos.add(LiveTv(name, split, image: image));
          }
          name = "";
          image = "";
        }
      }
    }catch(error) {
      print('=== API::getTV::Error ${error.toString()}');
    }
    print('=== API::getTV::Length ${_listVideos.length}');
    notifyListeners();
    setBusy(false);
  }
}
