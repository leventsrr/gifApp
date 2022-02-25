class GifModel {
  List? results;
  String? next;

  GifModel.fromJson(Map json) {
    this.results = json['results'];
    this.next = json['next'];
  }
}
