class ContentModel{
  String uid;
  String title;
  String desc;
  String idCont;
  String authorName;
  String category;
  String rating;
  String photoUrl;
  String createDate;
  String updateDate;
  String imageUrl;
  String instance;


  ContentModel(
      {this.uid,
      this.title,
      this.desc,
      this.idCont,
      this.authorName,
      this.category,
      this.rating,
      this.photoUrl,
      this.createDate,
      this.updateDate,
        this.imageUrl,
        this.instance
      });

  ContentModel.map(dynamic obj) {
    this.uid = obj["uid"];
    this.title = obj["title"];
    this.desc = obj["desc"];
  }

  ContentModel.fromJson(Map<String, dynamic> json):
        uid = json['uid'],
        title = json['title'],
        desc = json['desc'],
        authorName = json['author_name'],
        category = json['category'],
        rating = json['rating'].toString(),
        photoUrl = json['photo_url'],
        createDate = json['create_date'],
        updateDate = json['update_date'],
        idCont = json['id_cont'].toString(),
        instance = json['instance'],
        imageUrl = json['imageUrl'] ?? "";

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["uid"] = uid;
    map["title"] = title;
    map["desc"] = desc;
    return map;
  }

}