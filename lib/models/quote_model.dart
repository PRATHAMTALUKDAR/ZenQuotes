class Quote {
  final String? content;
  final String? author;
  Quote({this.content , this.author});
  factory Quote.fromJson(Map<String , dynamic> json){
    return Quote(content : json["body"],
                 author : json["author"]);
  }
}