import 'dart:async';

import 'package:briefing/bloc/bloc_provider.dart';
import 'package:briefing/model/article.dart';
import 'package:briefing/model/news.dart';
import 'package:briefing/repository/repository.dart';
import 'package:briefing/util/rate_limiter.dart';
import 'package:rxdart/rxdart.dart';

class ArticleListBloc extends BlocBase {
  final menuSubject = BehaviorSubject.seeded(Menu.local);
  final _newsListSubject = BehaviorSubject<List<News>>();
  final _categoryListSubject = BehaviorSubject<List<Category>>();
  final _categorySubject = BehaviorSubject.seeded(0);

  List<News> _newsList = <News>[];

  List<Category> _categoryList = <Category>[];

  int categorySelected = 0;

  Stream<List<News>> get newsListObservable => _newsListSubject.stream;

  Stream<List<Category>> get categoryListObservable => _categoryListSubject.stream;

  Stream<int> get categoryObservable => _categorySubject.stream;

  Sink<int> get categorySink => _categorySubject.sink;

  ArticleListBloc() {
    _newsListSubject.add(_newsList);
    _categoryListSubject.add(_categoryList);
    categoryListener();
  }

  categoryListener() {
    categoryObservable.listen((category) async {
      print('categoryObservable.listen($category)');
      categorySelected = category;
      await _fetchDataAndPushToStream(category: categorySelected);
    });
  }

  getCategory() {
    _fetchCategory();
  }

  refresh() async {
    print(':::refresh:::');
    await _fetchDataAndPushToStream(category: categorySelected);
  }

  Future<void> _fetchDataAndPushToStream({category}) async {
    await _fetchFromNetwork(category: category);
  }

  sendNewsToStream(List<News> news, [bool isLoadMore = true]) {
    if(!isLoadMore) {
      _newsList.clear();
    }
    _newsList.addAll(news);
    _newsListSubject.sink.add(_newsList);
  }

  @override
  dispose() {
    _categorySubject.close();
    _newsListSubject.close();
    _categoryListSubject.close();
    menuSubject.close();
  }

  Future<void> _fetchFromNetwork({country = 'us', category}) async {
    var articles =
        await RepositoryArticle.getLocalNewsFromNetwork(category);
    sendNewsToStream(articles);
  }

  Future<void> _fetchCategory() async {
    var cates = await RepositoryArticle.getAllCategory();
    _categoryList.clear();
    if(cates.isNotEmpty) {
      _categoryList.addAll(cates);
    }
    _categoryListSubject.sink.add(_categoryList);
  }

  void sendErrorMessage([String message = "Can't connect to the internet!"]) {
    print('sendErrorMessage');
    _newsListSubject.addError(BriefingError(message));
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
