import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Project extends ChangeNotifier {
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
        color = json.data()['color'] ?? "",
        screens = (json.data()['screens'] ?? []).cast<String>();
}

class ProjectService {
  static Future<List<Project>> getProjectsList() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('projects').get();

    List<Project> listProjects = Project.fromJsonList(querySnapshot.docs);

    if (listProjects.isNotEmpty) {
      return listProjects;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load Projects from Server');
    }
  }
}

class ProjectViewModel extends ChangeNotifier {
  List<Project> projects;

  Future<void> fetchProjects() async {
    this.projects = await ProjectService.getProjectsList();
    notifyListeners();
  }
}
