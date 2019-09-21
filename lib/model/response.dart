class Response<T> {

    Response();

    T data;
    Meta meta;
    Response.getMeta(Map<String, dynamic> json) {
        if(json.containsKey('meta')) {
            meta = Meta.fromJson(json['meta']);
        }
    }
}

class Meta {
    String nextPage;
    Meta(this.nextPage);

    Meta.fromJson(Map<String, dynamic> json) {
        nextPage = json['next_page'];
    }
}