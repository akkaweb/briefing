import 'package:briefing/model/news.dart';
import 'package:briefing/repository/repository.dart';
import 'package:briefing/viewmodels/base_model.dart';

class DetailViewModel extends BaseModel {
  final String id;

  DetailViewModel(this.id) : super() {
    getDetailOffline();
    getDetail();
    getListRelate();
  }

  News _news;

  News get news => _news;

  List<News> _listRelateNews;

  List<News> get listRelateNews => _listRelateNews;

  Future<void> getDetailOffline() async {
    News offlineNews = await RepositoryArticle.getNewsOffline(id);
    if(offlineNews != null && busy) {
      _news = offlineNews;
      setBusy(false);
      notifyListeners();
    }
  }

  Future<void> getDetail() async {
    setBusy(true);
    _news = await RepositoryArticle.getNewsDetail(id);
    if (_news == null) {
      setErrorMessage("Có lỗi xảy ra");
    } else {
      notifyListeners();
    }
    setBusy(false);
    await readNews();
  }

  bool _isLoadRelate = false;

  bool get isLoadRelate => _isLoadRelate;

  Future<void> getListRelate() async {
    _isLoadRelate = true;
    _listRelateNews = await RepositoryArticle.getRelateNews(this.id);
    _isLoadRelate = false;
    notifyListeners();
  }

  Future<void> readNews() async {
    if(news != null) {
      await RepositoryArticle.readNews(news);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
