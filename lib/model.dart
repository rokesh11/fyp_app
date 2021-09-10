class Model {
  String docId;
  String licensepath;
  String lat;
  String long;
  String photopath;
  DateTime date;
  String time;
  String type;

  Model(
      {this.licensepath,
      this.photopath,
      this.date,
      this.time,
      this.lat,
      this.long,
      this.type});

  Model.fromJson(Map<String, dynamic> json, String documentId) {
    licensepath = json['licensepath'];
    photopath = json['photopath'];
    lat = json['lat'];
    long = json['long'];
    date = DateTime.parse(json['date']);
    time = json['time'];
    type = json['type'];
    docId = documentId;
  }

  Map<String, dynamic> toJson() => {
        'licensepath': licensepath,
        'photopath': photopath,
        'lat': lat,
        'long': long,
        'date': date.toString(),
        'time': time,
        'type': type,
      };
}
