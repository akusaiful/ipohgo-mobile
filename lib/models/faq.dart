class Faq {
  String? title;
  String? content;

  Faq({
    this.title,
    this.content,
  });

  factory Faq.fromJson(Map<String, dynamic> d) {
    return Faq(title: d['title'], content: d['content']);
  }
}
