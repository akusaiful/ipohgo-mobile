class StateModel {
  int? id;
  String? name;
  int? total;
  String? thumbnailUrl;
  String? timestamp;

  StateModel(
      {this.id, this.name, this.total, this.thumbnailUrl, this.timestamp});

  // factory StateModel.fromFirestore(DocumentSnapshot snapshot) {
  //   Map d = snapshot.data() as Map<dynamic, dynamic>;
  //   return StateModel(
  //     name: d['name'],
  //     thumbnailUrl: d['thumbnail'],
  //     timestamp: d['timestamp'],
  //   );
  // }

  factory StateModel.fromJson(Map<String, dynamic> d) {
    return StateModel(
      id: d['id'],
      name: d['name'],
      total: d['total'],
      thumbnailUrl: d['thumbnail'],
      timestamp: d['timestamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'thumbnail': thumbnailUrl, 'timestamp': timestamp};
  }
}
