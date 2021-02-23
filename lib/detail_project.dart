import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    Project _project = project != null
        ? project
        : (viewModel.projects != null && viewModel.projects.length > 0)
            ? viewModel.projects.firstWhere((element) => element.name == name)
            : null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: new BoxDecoration(
            gradient: new LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Color.fromARGB(255, 0, 0, 0),
              (_project != null && _project.color != null)
                  ? Color(int.parse("0xff${_project.color}"))
                  : Color.fromARGB(255, 0, 6, 61)
            ])),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _project != null
                    ? Text(
                        _project.name,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )
                    : CircularProgressIndicator(),
              ),
              SizedBox(
                height: 22,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: Container(
                  width: 100,
                  height: 100,
                  child: Center(
                    child: _project != null
                        ? Image.network(
                            _project.logo.toString(),
                          )
                        : CircularProgressIndicator(),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                width: MediaQuery.of(context).size.width > 360 ? 360 : 300,
                child: Text(
                  _project == null
                      ? ""
                      : _project.description.replaceAll(".", ".\n\n"),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Text(
                'Screens',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 36.0),
                child: Material(
                    color: Colors.transparent,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                            icon: Image.asset('expand.png'), onPressed: () {}),
                      ),
                    )),
              ),
              CarouselSlider(
                options: CarouselOptions(
                  height: 600.0,
                  aspectRatio: 0.8,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                ),
                items: ((_project != null && _project.screens != null)
                        ? _project.screens
                        : [])
                    .map((item) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(18))),
                                    child: Image.network(
                                      _project.screens[
                                              _project.screens.indexOf(item)]
                                          .toString(),
                                      fit: BoxFit.cover,
                                      alignment: Alignment.topCenter,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0.0,
                                left: 0.0,
                                right: 0.0,
                                child: Container(
                                  color: (_project != null &&
                                          _project.color != null)
                                      ? Color(int.parse(
                                              "0xFF${_project.color}"))
                                          .withAlpha(150)
                                      : Colors.black,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 20.0),
                                  child: Center(
                                    child: Text(
                                      '${_project.screens.indexOf(item) + 1}/${_project.screens.length}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ));
                    },
                  );
                }).toList(),
              )
            ],
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
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 0, 0, 0),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: new BoxDecoration(
              gradient: new LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                Color.fromARGB(255, 0, 0, 0),
                Color.fromARGB(255, 0, 6, 61)
              ])),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: SvgPicture.asset("page_not_found.svg",
                  semanticsLabel: 'Acme Logo'),
            ),
          ),
        ));
  }
}
