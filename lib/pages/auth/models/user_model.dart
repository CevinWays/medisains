/// email : "hh@mail.com"
/// uid : "RAv3XzJWxQdWl8F1gqD9XqMIehM2"
/// username : "hh"

class UserModel {
  String email;
  String uid;
  String username;
  String education;
  String noHp;
  String gender;
  String location;
  String createDate;
  String updateDate;
  String instansi;


  UserModel(
      {this.email,
      this.uid,
      this.username,
      this.education,
      this.noHp,
      this.gender,
      this.location,
      this.createDate,
      this.updateDate,
      this.instansi});

  UserModel.map(dynamic obj) {
    this.email = obj["email"];
    this.uid = obj["uid"];
    this.username = obj["username"];
  }

  UserModel.fromJson(Map<String, dynamic> json):
    uid = json != null ? json['uid'] : "null",
    username = json != null ? json['username'] : "null",
    email = json != null ? json['email'] : "null",
    education = json != null ? json['education'] : "null",
    noHp = json != null ? json['no_hp'] : "null",
    gender = json != null ? json['gender'] : "null",
    location = json != null ? json['location'] : "null",
    createDate = json != null ? json['create_date'] : "null",
    updateDate = json != null ? json['update_date'] : "null",
    instansi = json != null ? json['instansi'] : "null";

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["email"] = email;
    map["uid"] = uid;
    map["username"] = username;
    return map;
  }

}