import 'package:briefing/viewmodels/base_model.dart';
import 'package:briefing/model/news.dart';
import 'package:briefing/repository/repository.dart';

class VideoViewModel extends BaseModel {
  
  VideoViewModel(): super() {
    getVideos();
  }
  
  int _page = 1;

  List<News> _listVideos;

  List<News> get listVideos => _listVideos;

  Future<void> getVideos({bool isRefresh = false, bool isLoadmore = false}) async {
    setBusy(true);
    if(isLoadmore) {
      _page += 1;
    } else {
      _page = 1;
    }
    _listVideos = await RepositoryArticle.getVideos(page: _page);
    notifyListeners();
    setBusy(false);
  }
}
