import 'package:cloud_firestore/cloud_firestore.dart';

class Project {
  String id;
  String name;
  String bigImagePath;
  String logo;
  String description;
  String color;
  List<String> screens;

  static List<Project> fromJsonList(List<QueryDocumentSnapshot> jsonArray) {
    return List.generate(
        jsonArray.length, (index) => Project.fromJson(jsonArray[index]));
  }

  Project.fromJson(QueryDocumentSnapshot json)
      : id = json.id,
        name = json.data()['name'],
        bigImagePath = json.data()['bigImagePath'] ?? "",
        logo = json.data()['logo'] ?? "",
        description = json.data()['description'] ?? "",
        color = json.data()['color'] ?? "";
}
