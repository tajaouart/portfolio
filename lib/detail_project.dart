import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'models.dart';

class ProjectDetailsPage extends Page {
  ProjectDetailsPage({
    this.project,
    this.name,
  }) : super(key: ValueKey(project));
  final Project? project;
  final String? name;

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
  const ProjectDetailsScreen({
    this.project,
    this.name,
  });

  final Project? project;
  final String? name;

  @override
  Widget build(BuildContext context) {
    final ProjectViewModel viewModel = Provider.of<ProjectViewModel>(context);
    final bool isMobile = MediaQuery.of(context).size.width <= 414;
    final Project? _project = project ??
        ((viewModel.projects != null && viewModel.projects!.isNotEmpty)
            ? viewModel.projects!
                .firstWhere((Project element) => element.name == name)
            : null);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
              const Color.fromARGB(255, 0, 0, 0),
              if (_project != null)
                Color(int.parse('0xff${_project.color}'))
              else
                const Color.fromARGB(255, 0, 6, 61)
            ])),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _project != null
                    ? Hero(
                        tag: 'name',
                        child: Text(
                          _project.name,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                        ),
                      )
                    : const CircularProgressIndicator(),
              ),
              const SizedBox(
                height: 22,
              ),
              Hero(
                tag: 'project_logo',
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
                          : const CircularProgressIndicator(),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Container(
                width: MediaQuery.of(context).size.width > 360 ? 360 : 300,
                child: Text(
                  _project == null
                      ? ''
                      : _project.description.replaceAll('.', '.\n\n'),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              if (_project == null ||
                  _project.tools == null ||
                  _project.tools!.isEmpty)
                Center()
              else
                Column(
                  children: <Widget>[
                    const SizedBox(height: 50),
                    const Text(
                      'Les outils utilisés',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    const SizedBox(height: 50),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        for (final String tool in _project.tools!)
                          Chip(label: Text(tool))
                      ],
                    ),
                  ],
                ),
              const SizedBox(height: 50),
              const Text(
                'Screens',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              const SizedBox(
                height: 24,
              ),
              if (!isMobile)
                const Center()
              else
                Hero(
                  tag: 'expand',
                  child: Padding(
                    padding: const EdgeInsets.only(left: 36.0),
                    child: Material(
                        color: Colors.transparent,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                                icon: Image.asset('assets/expand.png'),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
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
                  color: (_project != null)
                      ? Color(int.parse('0xFF${_project.color}')).withAlpha(180)
                      : Colors.black,
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  boxShadow: const <BoxShadow>[
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
                    tag: 'carousel',
                    child: CarouselSlider(
                      options: CarouselOptions(
                        height: 600.0,
                        aspectRatio: 0.8,
                        enlargeCenterPage: true,
                        enableInfiniteScroll: false,
                      ),
                      items: ((_project != null && _project.screens != null)
                              ? _project.screens
                              : <String>[])!
                          .map((String item) {
                        return Builder(
                          builder: (BuildContext context) {
                            return Container(
                                width: MediaQuery.of(context).size.width,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Stack(
                                  children: <Widget>[
                                    Positioned.fill(
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10)),
                                        child: Container(
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(18))),
                                          child: Image.network(
                                            _project!.screens![_project.screens!
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
                                        color: Color(int.parse(
                                                '0xFF${_project.color}'))
                                            .withAlpha(150),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 20.0),
                                        child: Center(
                                          child: Text(
                                            '${_project.screens!.indexOf(item) + 1}/${_project.screens!.length}',
                                            style: const TextStyle(
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
              ),
              const SizedBox(
                height: 100,
              ),
              if (_project == null || _project.googlePlayLink.isEmpty)
                const Center()
              else
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Divider(),
                    const SizedBox(
                      height: 32,
                    ),
                    Text(
                      'Voir sur le store',
                      style: GoogleFonts.titilliumWeb(
                          color: Colors.white, fontSize: 20),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    InkWell(
                      onTap: () => _launchURL(_project.googlePlayLink),
                      child: Image.asset(
                        'assets/google_play.png',
                        height: 64,
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class ExpandedCarouselPage extends StatefulWidget {
  ExpandedCarouselPage(this.project);

  final Project? project;

  @override
  _ExpandedCarouselPageState createState() => _ExpandedCarouselPageState();
}

class _ExpandedCarouselPageState extends State<ExpandedCarouselPage> {
  final AppBar appBar = AppBar();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Hero(
          tag: 'expand',
          child: Material(
            color: Colors.transparent,
            child: IconButton(
              icon: Image.asset('assets/collapse.png'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
        title: Text(
          widget.project!.name,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        actions: [
          Hero(
            tag: 'project_logo',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: Center(
                child: Image.network(
                  widget.project!.logo.toString(),
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
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
              const Color.fromARGB(255, 0, 0, 0),
              if (widget.project != null)
                Color(int.parse('0xff${widget.project!.color}'))
              else
                const Color.fromARGB(255, 0, 6, 61)
            ])),
        child: Center(
          child: Hero(
            tag: 'carousel',
            child: CarouselSlider(
              options: CarouselOptions(
                height: 600.0,
                aspectRatio: 0.8,
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
              ),
              items:
                  ((widget.project != null && widget.project!.screens != null)
                          ? widget.project!.screens
                          : <String>[])!
                      .map((String item) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Stack(
                          children: <Widget>[
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                                child: Container(
                                  decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(18))),
                                  child: Image.network(
                                    widget
                                        .project!
                                        .screens![widget.project!.screens!
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
                                color: (widget.project != null)
                                    ? Color(int.parse(
                                            '0xFF${widget.project!.color}'))
                                        .withAlpha(150)
                                    : Colors.black,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                                child: Center(
                                  child: Text(
                                    '${widget.project!.screens!.indexOf(item) + 1}/${widget.project!.screens!.length}',
                                    style: const TextStyle(
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
