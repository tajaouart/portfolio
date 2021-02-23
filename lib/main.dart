import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '404.dart';
import 'components.dart';
import 'detail_project.dart';
import 'models.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ProjectViewModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  ProjectRouterDelegate _routerDelegate = ProjectRouterDelegate();
  ProjectRouteInformationParser _routeInformationParser =
      ProjectRouteInformationParser();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Projects App',
      routerDelegate: _routerDelegate,
      routeInformationParser: _routeInformationParser,
    );
  }
}

class MyHomePage extends StatefulWidget {
  final List<Project> projects;
  final ValueChanged<Project> onTapped;

  MyHomePage({
    @required this.projects,
    @required this.onTapped,
  });

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Provider.of<ProjectViewModel>(context, listen: false).fetchProjects();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ProjectViewModel>(context);

    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: new BoxDecoration(
              gradient: new LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 0, 0, 0),
              Color.fromARGB(255, 0, 6, 61),
            ],
          )),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Text(
                  "TAJAOURT Mounir",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "Développeur mobile",
                  style: TextStyle(
                      color: Color.fromARGB(255, 182, 42, 222), fontSize: 17),
                ),
                SizedBox(
                  height: 48,
                ),
                Text(
                  "Les projects",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 24),
                viewModel.projects != null && viewModel.projects.length > 0
                    ? Column(
                        children: [
                          for (var project in viewModel.projects)
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 16.0, top: 16),
                              child: InkWell(
                                onTap: () => widget.onTapped(project),
                                child: ProjectWidget(project),
                              ),
                            )
                        ],
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      )
              ],
            ),
          )),
    );
  }
}

class ProjectRouteInformationParser
    extends RouteInformationParser<ProjectRoutePath> {
  @override
  Future<ProjectRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location);
    // Handle '/'
    if (uri.pathSegments.length == 0) {
      return ProjectRoutePath.home();
    }

    // Handle '/project/:name'
    if (uri.pathSegments.length == 2) {
      if (uri.pathSegments[0] != 'project') return ProjectRoutePath.unknown();
      var remaining = uri.pathSegments[1];
      var name = remaining.toString();
      if (name == null) return ProjectRoutePath.unknown();
      return ProjectRoutePath.details(name);
    }

    // Handle unknown routes
    return ProjectRoutePath.unknown();
  }

  @override
  RouteInformation restoreRouteInformation(ProjectRoutePath path) {
    if (path.isUnknown) {
      return RouteInformation(location: '/404');
    }
    if (path.isHomePage) {
      return RouteInformation(location: '/');
    }
    if (path.isDetailsPage) {
      return RouteInformation(location: '/project/${path.name}');
    }
    return null;
  }
}

class ProjectRouterDelegate extends RouterDelegate<ProjectRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<ProjectRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey;
  TransitionDelegate transitionDelegate = NoAnimationTransitionDelegate();

  Project _selectedProject;
  String name;
  bool show404 = false;

  ProjectRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  ProjectRoutePath get currentConfiguration {
    if (show404) {
      return ProjectRoutePath.unknown();
    }
    return (_selectedProject == null && name == null)
        ? ProjectRoutePath.home()
        : ProjectRoutePath.details(
            _selectedProject == null ? name : _selectedProject.name);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      transitionDelegate: transitionDelegate,
      pages: [
        MaterialPage(
          key: ValueKey('ProjectsListPage'),
          child: MyHomePage(
            onTapped: _handleProjectTapped,
          ),
        ),
        if (show404)
          MaterialPage(key: ValueKey('UnknownPage'), child: UnknownScreen())
        else if (_selectedProject != null)
          ProjectDetailsPage(project: _selectedProject)
        else if (name != null)
          ProjectDetailsPage(name: name)
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }

        // Update the list of pages by setting _selectedBook to null
        _selectedProject = null;
        name = null;
        show404 = false;
        notifyListeners();

        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(ProjectRoutePath path) async {
    if (path.isUnknown) {
      _selectedProject = null;
      show404 = true;
      return;
    }

    if (path.isDetailsPage) {
      name = path.name;
      if (_selectedProject == null && name == null) {
        show404 = true;
        return;
      }
    } else {
      _selectedProject = null;
    }

    show404 = false;
  }

  void _handleProjectTapped(Project project) {
    _selectedProject = project;
    notifyListeners();
  }
}

class ProjectRoutePath {
  final String name;
  final bool isUnknown;

  ProjectRoutePath.home()
      : name = null,
        isUnknown = false;

  ProjectRoutePath.details(this.name) : isUnknown = false;

  ProjectRoutePath.unknown()
      : name = null,
        isUnknown = true;

  bool get isHomePage => name == null;

  bool get isDetailsPage => name != null;
}
