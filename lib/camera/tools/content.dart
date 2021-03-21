class Content {
  String type;
  String mime;
  String data;

  Content(String type, String mime, String data) {
    this.type = type;
    this.mime = mime;
    this.data = data;
  }

  Map<String, dynamic> toJson() => {'type': type, 'mime': mime, 'data': data};
}
