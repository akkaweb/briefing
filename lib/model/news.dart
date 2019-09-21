import 'package:intl/intl.dart';
import 'package:briefing/model/article.dart';
import 'package:briefing/viewmodels/base_model.dart';
import 'package:briefing/repository/repository.dart';
import 'package:briefing/model/response.dart';

class News extends Article {
  List<Images> images;
  int hasImage;
  int hasVideo;
  Publisher publisher;
  Category categoryNews;
  String date;
  String dateTime;
  String thumbWidth;
  String thumbHeight;
  String apiGetContent;
  String thumbUrl;
  String videoUrl;
  bool bookmarked = false;
  List<NewsContent> newContent;

  News(
      {id,
      title,
      description,
      url,
      publishedAt,
      author,
      source,
      content,
      imageUrl,
      category,
      this.images,
      this.hasVideo,
      this.hasImage,
      this.publisher,
      this.categoryNews,
      this.date,
      this.dateTime,
      this.thumbWidth,
      this.thumbHeight,
      this.apiGetContent,
      this.thumbUrl,
      this.bookmarked,
      this.newContent});

  News.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    if (json['images'] != null) {
      images = new List<Images>();
      json['images'].forEach((v) {
        images.add(new Images.fromJson(v));
      });
    }
    hasImage = json['has_image'];
    hasVideo = json['has_video'];
    publisher = json['publisher'] != null ? new Publisher.fromJson(json['publisher']) : null;
    categoryNews = json['category'] != null ? new Category.fromJson(json['category']) : null;

    if (json['content'] != null) {
      newContent = new List<NewsContent>();
      json['content'].forEach((v) {
        newContent.add(new NewsContent.fromJson(v));
      });
    }
    if (categoryNews != null) {
      source = categoryNews.name ?? "";
    }
    date = json['date'];
    videoUrl = json['video_url'];
    dateTime = json['datetime'];
    thumbUrl = json['thumb_url'];
    thumbWidth = json['thumb_width'];
    thumbHeight = json['thumb_height'];
    apiGetContent = json['api_get_content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    if (this.images != null) {
      data['images'] = this.images.map((v) => v.toJson()).toList();
    }
    data['has_image'] = this.hasImage;
    data['has_video'] = this.hasVideo;
    if (this.publisher != null) {
      data['publisher'] = this.publisher.toJson();
    }
    if (this.categoryNews != null) {
      data['category'] = this.categoryNews.toJson();
    }

    if (this.newContent != null) {
      data['content'] = this.newContent.map((v) => v.toJson()).toList();
    }
    data['date'] = this.date;
    data['datetime'] = this.dateTime;
    data['thumb_url'] = this.thumbUrl;
    data['video_url'] = this.videoUrl;
    data['thumb_width'] = this.thumbWidth;
    data['thumb_height'] = this.thumbHeight;
    data['api_get_content'] = this.apiGetContent;
    return data;
  }

  Map<String, dynamic> toMap({category}) {
    return {
      'title': title,
      'description': description,
      'url': url,
      'publishedAt': publishedAt,
      'author': author,
      'source': source,
      'content': content,
      'urlToImage': imageUrl,
      'category': category ?? this.category,
      'has_video': hasVideo,
      'has_image': hasImage,
      'date': date,
      'date_time': dateTime,
      'thumb_width': thumbWidth,
      'thumb_height': thumbHeight,
      'api_get_content': apiGetContent,
      'bookmarked': bookmarked,
    };
  }

  String get timeAgo {
    var formatter = DateFormat("yyyy-MM-dd HH:mm:ss");
//    var formatter = DateFormat("EEE, d MMM yyyy HH:mm:ss zzz");

    DateTime parsedDate;

    try {
      parsedDate = formatter.parse(dateTime);
    } catch (error) {
      try {
        parsedDate = DateFormat("EEE, d MMM yyyy HH:mm:ss zzz").parse(dateTime);
      } catch (error) {
        print('${error.toString()}');
      }
    }
    if (parsedDate != null) {
      Duration duration = DateTime.now().difference(parsedDate);

      if (duration.inDays > 7) {
        return DateFormat.MMMMd().format(parsedDate);
      } else if (duration.inDays >= 1 && duration.inDays <= 7) {
        return duration.inDays == 1 ? "1 ngày" : "${duration.inDays} ngày";
      } else if (duration.inHours >= 1) {
        return duration.inHours == 1 ? "1 giờ" : "${duration.inHours} giờ";
      } else {
        return duration.inMinutes <= 1 ? "1 phút" : "${duration.inMinutes} phút";
      }
    } else {
      return "";
    }
  }

  bool isNew() {
    var formatter = DateFormat("yyyy-MM-dd HH:mm:ss");

    DateTime parsedDate = formatter.parse(dateTime);
    Duration duration = DateTime.now().difference(parsedDate);
    if (duration.inHours < 24) {
      return true;
    }
    return false;
  }

  bool get isValid => title != null && title.length > 3 && url != null;
}

class Images {
  String type;
  ContentData data;
  String align;

  Images({this.type, this.data, this.align});

  Images.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    data = json['data'] != null ? new ContentData.fromJson(json['data']) : null;
    align = json['align'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['align'] = this.align;
    return data;
  }
}

class Publisher {
  int id;
  String name;
  int view;
  String status;
  String iconPath;
  String iconUrl;
  String createdAt;
  String updatedAt;
  Null deletedAt;

  Publisher(
      {this.id,
      this.name,
      this.view,
      this.status,
      this.iconPath,
      this.iconUrl,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  Publisher.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    view = json['view'];
    status = json['status'];
    iconPath = json['icon_path'];
    iconUrl = json['icon_url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['view'] = this.view;
    data['status'] = this.status;
    data['icon_path'] = this.iconPath;
    data['icon_url'] = this.iconUrl;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}

class Category {
  int id;
  String name;
  int view;
  String status;
  Null iconPath;
  Null iconUrl;
  String createdAt;
  String updatedAt;
  Null deletedAt;
  String apiGetContent;
  List<News> listNews;
  String nextPage;

  Category(
      {this.id,
      this.name,
      this.view,
      this.status,
      this.iconPath,
      this.iconUrl,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.apiGetContent});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    view = json['view'];
    status = json['status'];
    iconPath = json['icon_path'];
    iconUrl = json['icon_url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    apiGetContent = json['api_get_content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['view'] = this.view;
    data['status'] = this.status;
    data['icon_path'] = this.iconPath;
    data['icon_url'] = this.iconUrl;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['api_get_content'] = this.apiGetContent;
    return data;
  }

  Future<void> getNews({bool isLoadmore = false}) async {
    Response<List<News>> news;
    if (isLoadmore && nextPage?.isNotEmpty == true && listNews?.isNotEmpty == true) {
      news = await RepositoryArticle.getNewsFromNextPage(nextPage);
      if (news.data?.isNotEmpty == true) {
        this.listNews?.addAll(news.data);
      }
    } else {
      nextPage = null;
      news = await RepositoryArticle.getLocalNewsFromNetwork(id);
      this.listNews = news.data;
    }
    nextPage = news?.meta?.nextPage;
  }
}

class NewsContent {
  String type;
  ContentData data;
  String align;

  NewsContent({this.type, this.data, this.align});

  NewsContent.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    data = json['data'] != null ? new ContentData.fromJson(json['data']) : null;
    align = json['align'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['align'] = this.align;
    return data;
  }
}

class ContentData {
  String content;
  String image;
  String width;
  String height;

  ContentData({this.content, this.width, this.height});

  ContentData.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    image = json['image'];
    width = json['width'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    data['image'] = this.image;
    data['width'] = this.width;
    data['height'] = this.height;
    return data;
  }
}
