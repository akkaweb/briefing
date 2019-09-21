import 'dart:convert';

import 'package:briefing/model/article.dart';
import 'package:briefing/model/news.dart';
import 'package:briefing/model/news.dart' as cate;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:xml/xml.dart';
import 'package:briefing/model/response.dart';

const base_url = 'https://newsapi.org/v2';
const api_key = '11cd66d3a6994c108e7fb7d92cee5e12';
const local_news_url = 'https://news.google.com/rss';
const category_url = 'https://vnnews.apptonghop.com/api/categories';
const news_detail_url = 'https://vnnews.apptonghop.com/api/articles/';

String getUrl(String country, String category) {
  var url = '$base_url/top-headlines?page=1';
  if (country != null && country.isNotEmpty) {
    url += '&country=$country';
  }
  if (category != null && category.isNotEmpty) {
    url += '&category=$category';
  }
  return url += '&apiKey=$api_key';
}

String getNewsUrl(int categoryId, int publisherId) {
  var url = 'https://vnnews.apptonghop.com/api/articles?';
  if (categoryId > 0) {
    url += "category_id=$categoryId";
  }
  if (publisherId > 0) {
    url += "publisher_id=$publisherId";
  }
  return url;
}

String getVideoUrl(int page) {
  var url = 'https://vnnews.apptonghop.com/api/videos';
  return url;
}

class ApiService {
  static Future<List<Article>> getArticlesFromNetwork(country, category) async {
    var articles = [];
    try {
      final response = await http.get(getUrl(country, category));
      if (response.statusCode == 200) {
        articles = await compute(parseArticles, response.body);
      }
    } catch (e) {
      print('=== API::getArticlesFromNetwork Error ${e.toString()}');
    }
    return articles;
  }

  static Future<Response<List<News>>> getLocalNewsFromNetwork(category) async {
    Response<List<News>> news;
    try {
      final response = await http.get(getNewsUrl(category, 0));
      if (response.statusCode == 200) {
        print('=== API::LocalNewsFromNetwork::Response ${response.body.toString()}');
        news = await compute(parseNews, response.body);
      }
    } catch (error) {
      print('=== API::LocalNewsFromNetwork::Error ${error.toString()}');
    }
    return news;
  }

  static Future<Response<List<News>>> getNewsFromNextPage(nextPage) async {
    Response<List<News>> news;
    try {
      final response = await http.get(nextPage);
      if (response.statusCode == 200) {
        print('=== API::LocalNewsFromNetwork::Response ${response.body.toString()}');
        news = await compute(parseNews, response.body);
      }
    } catch (error) {
      print('=== API::LocalNewsFromNetwork::Error ${error.toString()}');
    }
    return news;
  }

  static Future<Response<List<News>>> getVideos(page) async {
    Response<List<News>> news;
    try {
      final response = await http.get(getVideoUrl(page));
      if (response.statusCode == 200) {
        print('=== API::LocalNewsFromNetwork::Response ${response.body.toString()}');
        news = await compute(parseNews, response.body);
      }
    } catch (error) {
      print('=== API::LocalNewsFromNetwork::Error ${error.toString()}');
    }
    return news;
  }

  static Future<List<News>> getRelateNews(newsId) async {
    List<News> news;
    try {
      final response = await http.get("http://vnnews.apptonghop.com/api/articles/relate/$newsId");
      if (response.statusCode == 200) {
        print('=== API::LocalNewsFromNetwork::Response ${response.body.toString()}');
        news = await compute(parseRelateNews, response.body);
      }
    } catch (error) {
      print('=== API::LocalNewsFromNetwork::Error ${error.toString()}');
    }
    return news;
  }

  static Future<List<cate.Category>> getAllCategory() async {
    var categories = [];
    try {
      final response = await http.get(category_url);
      if (response.statusCode == 200) {
        print('=== API::LocalNewsFromNetwork::Response ${response.body.toString()}');
        categories = await compute(parseCategory, response.body);
      }
    } catch (error) {
      print('=== API::LocalNewsFromNetwork::Error ${error.toString()}');
    }
    return categories;
  }

  static Future<News> getNewsDetail(id) async {
    try {
      final response = await http.get("$news_detail_url$id");
      if (response.statusCode == 200) {
        print('=== API::LocalNewsFromNetwork::Response ${response.body.toString()}');
        return parseNewsDetail(response.body);
      }
    } catch (error) {
      print('=== API::LocalNewsFromNetwork::Error ${error.toString()}');
    }
    return null;
  }
}

Response<List<News>> parseNews(String responseBody) {
  var articles = [];
  final parsed = json.decode(responseBody);
  if (parsed['code'] == 200) {
    articles = List<News>.from(parsed['data'].map((article) => News.fromJson(article)));
  }
  final response = Response<List<News>>.getMeta(parsed);
  response.data = articles;
  return response;
}

List<News> parseRelateNews(String responseBody) {
  var articles = [];
  final parsed = json.decode(responseBody);
  if (parsed['code'] == 200) {
    articles = List<News>.from(parsed['data']['relate_article'].map((article) => News.fromJson(article)));
  }
  return articles;
}

News parseNewsDetail(String responseBody) {
  final parsed = json.decode(responseBody);
  if (parsed['code'] == 200) {
    return News.fromJson(parsed['data']);
  }
  return null;
}

List<cate.Category> parseCategory(String responseBody) {
  var articles = [];
  final parsed = json.decode(responseBody);
  if (parsed['code'] == 200) {
    articles = List<cate.Category>.from(parsed['data'].map((article) => cate.Category.fromJson(article)));
  }
  return articles;
}

List<Article> parseArticles(String responseBody) {
  var articles = [];
  final parsed = json.decode(responseBody);
  if (parsed['totalResults'] > 0) {
    articles = List<Article>.from(parsed['articles'].map((article) => Article.fromMap(article, network: true)));
  }
  return articles;
}