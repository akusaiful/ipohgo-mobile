class Include {
  String? title;

  Include({
    this.title,
  });

  factory Include.fromJson(Map<String, dynamic> d) {
    return Include(title: d['title']);
  }
}
