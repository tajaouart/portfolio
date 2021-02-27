import 'package:carousel_slider/carousel_slider.dart';
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
    bool isMobile = MediaQuery.of(context).size.width <= 414;
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
                    ? Hero(
                        tag: "name",
                        child: Text(
                          _project.name,
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      )
                    : CircularProgressIndicator(),
              ),
              SizedBox(
                height: 22,
              ),
              Hero(
                tag: "project_logo",
                child: ClipRRect(
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
              (_project == null ||
                      _project.tools == null ||
                      _project.tools.isEmpty)
                  ? Center()
                  : Column(
                      children: [
                        SizedBox(height: 50),
                        Text(
                          'Les outils utilisés',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        SizedBox(height: 50),
                        Wrap(
                          spacing: 16,
                          runSpacing: 16,
                          children: [
                            for (var tool in _project.tools)
                              Chip(label: Text(tool))
                          ],
                        ),
                      ],
                    ),
              SizedBox(height: 50),
              Text(
                'Screens',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              SizedBox(
                height: 24,
              ),
              !isMobile
                  ? Center()
                  : Hero(
                      tag: "expand",
                      child: Padding(
                        padding: const EdgeInsets.only(left: 36.0),
                        child: Material(
                            color: Colors.transparent,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: IconButton(
                                    icon: Image.asset('expand.png'),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ExpandedCarouselPage(_project)),
                                      );
                                    }),
                              ),
                            )),
                      ),
                    ),
              Container(
                width: 414,
                decoration: BoxDecoration(
                  color: (_project != null && _project.color != null)
                      ? Color(int.parse("0xFF${_project.color}")).withAlpha(180)
                      : Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      spreadRadius: 8,
                      blurRadius: 50,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Hero(
                    tag: "carousel",
                    child: CarouselSlider(
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
                                            _project.screens[_project.screens
                                                    .indexOf(item)]
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
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ExpandedCarouselPage extends StatefulWidget {
  Project project;

  ExpandedCarouselPage(this.project);

  @override
  _ExpandedCarouselPageState createState() => _ExpandedCarouselPageState();
}

class _ExpandedCarouselPageState extends State<ExpandedCarouselPage> {
  final AppBar appBar = AppBar();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Hero(
          tag: "expand",
          child: Material(
            color: Colors.transparent,
            child: IconButton(
              icon: Image.asset('collapse.png'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
        title: Text(
          widget.project.name,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        actions: [
          Hero(
            tag: "project_logo",
            child: ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: Center(
                child: Image.network(
                  widget.project.logo.toString(),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
          child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: new BoxDecoration(
            gradient: new LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Color.fromARGB(255, 0, 0, 0),
              (widget.project != null && widget.project.color != null)
                  ? Color(int.parse("0xff${widget.project.color}"))
                  : Color.fromARGB(255, 0, 6, 61)
            ])),
        child: Center(
          child: Hero(
            tag: "carousel",
            child: CarouselSlider(
              options: CarouselOptions(
                height: 600.0,
                aspectRatio: 0.8,
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
              ),
              items: ((widget.project != null && widget.project.screens != null)
                      ? widget.project.screens
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
                                    widget
                                        .project
                                        .screens[widget.project.screens
                                            .indexOf(item)]
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
                                color: (widget.project != null &&
                                        widget.project.color != null)
                                    ? Color(int.parse(
                                            "0xFF${widget.project.color}"))
                                        .withAlpha(150)
                                    : Colors.black,
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                                child: Center(
                                  child: Text(
                                    '${widget.project.screens.indexOf(item) + 1}/${widget.project.screens.length}',
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
            ),
          ),
        ),
      )),
    );
  }
}
