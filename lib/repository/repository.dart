import 'package:briefing/model/article.dart';
import 'package:briefing/model/news.dart';
import 'package:briefing/service/api_service.dart';
import 'package:briefing/service/database/database.dart';
import 'package:briefing/model/response.dart';

class RepositoryCommon {
  static close() {
    DatabaseService.db.close();
  }
}

class RepositoryArticle {

  static Future<List<News>> getReadNews() async {
    return await DatabaseService.db.getReadNews();
  }

  static Future<int> readNews(news) async {
    return await DatabaseService.db.insertNews(news);
  }

  //ApiService
  static Future<List<Article>> getArticleListFromNetwork(
      String country, String category) async {
    return ApiService.getArticlesFromNetwork(country, category);
  }

  static Future<Response<List<News>>> getLocalNewsFromNetwork(category) async {
    return ApiService.getLocalNewsFromNetwork(category);
  }

  static Future<Response<List<News>>> getNewsFromNextPage(nextPage) async {
    return ApiService.getNewsFromNextPage(nextPage);
  }

  static Future<List<Category>> getAllCategory() async {
    return ApiService.getAllCategory();
  }

  static Future<News> getNewsDetail(id) async {
    return ApiService.getNewsDetail(id);
  }

  static Future<Response<List<News>>> getVideos({int page = 1}) async {
    return ApiService.getVideos(page);
  }

  static Future<List<News>> getRelateNews(newsId) async {
    return ApiService.getRelateNews(newsId);
  }
}
