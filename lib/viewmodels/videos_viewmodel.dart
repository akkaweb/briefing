import 'package:briefing/viewmodels/base_model.dart';
import 'package:briefing/model/news.dart';
import 'package:briefing/repository/repository.dart';
import 'package:briefing/model/response.dart';

class VideoViewModel extends BaseModel {
  
  VideoViewModel(): super() {
    getVideos();
  }
  
  String _nextPage;

  List<News> _listVideos;

  List<News> get listVideos => _listVideos;

  bool get canLoadmore => _nextPage?.isNotEmpty == true;

  Future<void> getVideos({bool isRefresh = false, bool isLoadmore = false}) async {
    setBusy(true);
    Response<List<News>> news;
    if(isLoadmore && _nextPage?.isNotEmpty == true && _listVideos?.isNotEmpty == true) {
      news = await RepositoryArticle.getNewsFromNextPage(_nextPage);
      if(news.data?.isNotEmpty == true) {
        this._listVideos?.addAll(news.data);
      }
    } else {
      _nextPage = null;
      news = await RepositoryArticle.getVideos();
      this._listVideos = news.data;
    }
    _nextPage = news?.meta?.nextPage;
    notifyListeners();
    setBusy(false);
  }
}
