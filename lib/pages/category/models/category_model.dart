/// title : "a"
/// desc : "a"
class CategoryModel {
  String title;
  String desc;

  CategoryModel({this.title, this.desc});

  CategoryModel.map(dynamic obj) {
    this.title = obj["title"];
    this.desc = obj["desc"];
  }

  CategoryModel.fromJson(Map<String,dynamic> json) {
    this.title = json["title"];
    this.desc = json["desc"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["title"] = title;
    map["desc"] = desc;
    return map;
  }

}

class CategoryListMap{
  List<CategoryModel> data;

  CategoryListMap.fromJson(List<Map<String,dynamic>> json) {
    if(json != null){
      data = List.generate(json.length, (index){
        return CategoryModel.fromJson(json[index]);
      });
    }
  }
}