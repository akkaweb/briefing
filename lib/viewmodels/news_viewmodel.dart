import 'package:briefing/viewmodels/base_model.dart';
import 'package:briefing/model/news.dart';
import 'package:briefing/repository/repository.dart';

class NewsViewModel extends BaseModel {

  NewsViewModel(): super() {
    fetchCategory();
  }

  int _cateSelected = 0;
  List<Category> _listCategories = List();
  List<News> _listNews;

  int get cateSelected => _cateSelected;

  List<Category> get listCategories => _listCategories;

  List<News> get listNews => _listNews;

  bool get canLoadmore => _getCurrentCate()?.nextPage?.isNotEmpty == true;

  Future<void> fetchCategory() async {
    setBusy(true);
    var cates = await RepositoryArticle.getAllCategory();
    _listCategories.clear();
    if (cates?.isNotEmpty == true) {
      _listCategories.addAll(cates);
      _cateSelected = _listCategories[0].id;
      await getNews(_cateSelected);
    } else {
      notifyListeners();
      setBusy(false);
    }
  }

  Future<void> getNews(id, {bool isRefresh = false, bool isLoadmore = false}) async {
    setBusy(true);
    _cateSelected = id;
    if(_getCurrentCate()?.listNews?.isNotEmpty != true || isRefresh) {
      await _getCurrentCate()?.getNews();
    } else if(isLoadmore) {
      await _getCurrentCate()?.getNews(isLoadmore: true);
    }
    _listNews = _getCurrentCate()?.listNews;
    notifyListeners();
    setBusy(false);
  }

  Category _getCurrentCate() {
    if (_listCategories == null) return null;
    for (int i = 0; i < _listCategories.length; i++) {
      if (_listCategories[i].id == _cateSelected) {
        return _listCategories[i];
      }
    }
    return null;
  }
}
