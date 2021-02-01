class ContentModel{
  String uid;
  String title;
  String desc;

  ContentModel({this.uid, this.title, this.desc});

  ContentModel.map(dynamic obj) {
    this.uid = obj["uid"];
    this.title = obj["title"];
    this.desc = obj["desc"];
  }

  ContentModel.fromJson(Map<String, dynamic> json):
        uid = json['uid'],
        title = json['title'],
        desc = json['desc'];

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["uid"] = uid;
    map["title"] = title;
    map["desc"] = desc;
    return map;
  }

}