import 'dart:async';

import 'package:briefing/bloc/bloc_provider.dart';
import 'package:briefing/model/article.dart';
import 'package:briefing/repository/repository.dart';
import 'package:briefing/model/news.dart';
import 'package:rxdart/rxdart.dart';

class BookmarkArticleListBloc extends BlocBase {
  final _articleListSubject = BehaviorSubject<List<News>>();
  List<News> _articleList = <News>[];

  Stream<List<News>> get articleListObservable => _articleListSubject.stream;

  BookmarkArticleListBloc() {
    _articleListSubject.add(_articleList);

    _initList();
  }

  _initList() async {
    print('menu == Menu.favorites');
    await _loadBookmarkedArticlesFromDatabase();
  }

  sendToStream(List<News> articles) {
    _articleList.clear();
    _articleList.addAll(articles);
    _articleListSubject.sink.add(_articleList);
  }

  @override
  dispose() {
    _articleListSubject.close();
  }

  Future<void> _loadBookmarkedArticlesFromDatabase() async {
    try {
      var localData = await RepositoryArticle.getReadNews();
      if (localData.isNotEmpty) {
        sendToStream(localData);
      } else {
        sendErrorMessage('No bookmarked articles');
      }
    } catch (e) {
      print(e);
    }
  }

  void sendErrorMessage([String message = "Can't connect to the internet!"]) {
    print('sendErrorMessage');
    _articleListSubject.addError(BriefingError(message));
    _articleList.clear();
  }
}

class BriefingError extends Error {
  final String message;

  BriefingError(this.message);

  @override
  String toString() {
    return '$message';
  }
}
