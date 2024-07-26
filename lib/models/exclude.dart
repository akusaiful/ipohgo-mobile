class Exclude {
  String? title;

  Exclude({
    this.title,
  });

  factory Exclude.fromJson(Map<String, dynamic> d) {
    return Exclude(title: d['title']);
  }
}
