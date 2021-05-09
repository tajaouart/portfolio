import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Project extends ChangeNotifier {
  Project.fromJson(QueryDocumentSnapshot json)
      : id = json.id,
        name = (json.data() as dynamic)['name'] as String? ?? '',
        bigImagePath = (json.data() as dynamic)['bigImagePath'] as String? ?? '',
        logo = (json.data() as dynamic)['logo'] as String? ?? '',
        description = (json.data() as dynamic)['description'] as String? ?? '',
        color = (json.data() as dynamic)['color'] as String? ?? 'B62ADE',
        screens = ((json.data() as dynamic)['screens'] ?? []).cast<String>(),
        tools = ((json.data() as dynamic)['tools'] ?? []).cast<String>(),
        googlePlayLink =
            (json.data() as dynamic)['googlePlayLink'] as String? ?? '',
        state = (json.data() as dynamic)['state'] as String? ?? 'unpublished';

  String id;
  String name;
  String bigImagePath;
  String logo;
  String description;
  String color;
  List<String>? screens;
  List<String>? tools;
  String googlePlayLink;
  String state = 'unpublished';

  static List<Project> fromJsonList(List<QueryDocumentSnapshot> jsonArray) {
    return List<Project>.generate(
        jsonArray.length, (int index) => Project.fromJson(jsonArray[index]));
  }
}

class ProjectService {
  static Future<List<Project>> getProjectsList() async {
    final QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('projects').get();

    final List<Project> listProjects = Project.fromJsonList(querySnapshot.docs);

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
  List<Project>? projects;

  Future<void> fetchProjects() async {
    projects = await ProjectService.getProjectsList();
    notifyListeners();
  }
}
