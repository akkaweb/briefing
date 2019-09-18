import 'package:briefing/model/news.dart';
import 'package:briefing/repository/repository.dart';
import 'package:briefing/viewmodels/base_model.dart';

class DetailViewModel extends BaseModel {
  final String id;

  DetailViewModel(this.id) : super() {
    getDetail();
  }

  News _news;

  News get news => _news;

  Future<void> getDetail() async {
    setBusy(true);
    _news = await RepositoryArticle.getNewsDetail(id);
    if (_news == null) {
      setErrorMessage("Có lỗi xảy ra");
    } else {
      notifyListeners();
    }
    setBusy(false);
  }
}
