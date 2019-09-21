import 'package:briefing/model/news.dart';
import 'dart:convert';

class SaveNews {
    num newsId;
    String newsJson;
    num timeRead;
    News news;

    SaveNews(this.news) {
        this.timeRead = new DateTime.now().millisecondsSinceEpoch;
        if(news != null) {
            this.newsId = news?.id;
            this.newsJson = json.encode(news.toJson());
        }
    }

    void setNews(News news) {
        this.news = news;
        this.newsJson = json.encode(news.toJson());
    }

    factory SaveNews.fromMap(Map<String, dynamic> map) {
        News news = News.fromJson(json.decode(map["newsJson"]));
        return SaveNews(news);
    }

    Map<String, dynamic> toMap() {
        return {
            "newsId": newsId,
            "newsJson": newsJson,
            "timeRead": timeRead
        };
    }
}