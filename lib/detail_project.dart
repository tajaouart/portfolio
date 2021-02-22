import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models.dart';

class ProjectDetailsPage extends Page {
  final Project project;
  final String name;

  ProjectDetailsPage({
    this.project,
    this.name,
  }) : super(key: ValueKey(project));

  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return project != null
            ? ProjectDetailsScreen(project: project)
            : ProjectDetailsScreen(name: name);
      },
    );
  }
}

class ProjectDetailsScreen extends StatelessWidget {
  final Project project;
  final String name;

  ProjectDetailsScreen({
    this.project,
    this.name,
  });

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ProjectViewModel>(context);
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Center(
            child: project != null
                ? Text(project.name)
                : (viewModel.projects != null && viewModel.projects.length > 0)
                    ? Text(viewModel.projects
                        .firstWhere((element) => element.name == name)
                        .name)
                    : CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}

class UnknownScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text('404!'),
      ),
    );
  }
}
