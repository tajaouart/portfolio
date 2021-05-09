import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:portfolio/contact.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart' as r;
import 'package:url_launcher/url_launcher.dart';

import '404.dart';
import 'cgu.dart';
import 'components.dart';
import 'cv.dart';
import 'detail_project.dart';
import 'models.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (BuildContext context) => ProjectViewModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp()
      : _routerDelegate = ProjectRouterDelegate(),
        _routeInformationParser = ProjectRouteInformationParser();

  final ProjectRouterDelegate _routerDelegate;
  final ProjectRouteInformationParser _routeInformationParser;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Tajaouart',
      routerDelegate: _routerDelegate,
      routeInformationParser: _routeInformationParser,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    required this.projects,
    required this.onTapped,
  });

  final List<Project> projects;
  final ValueChanged<Object> onTapped;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  bool get isMobile => MediaQuery.of(context).size.width <= 414;
  r.Artboard? _riveArtBoard;
  double _containerWidth = 0.0;
  bool reverse = false;
  bool firstBuild = true;
  r.RiveAnimationController? _controller;

  @override
  void initState() {
    super.initState();
    Provider.of<ProjectViewModel>(context, listen: false).fetchProjects();

    rootBundle.load('assets/flame.riv').then(
      (ByteData data) async {
        // Load the RiveFile from the binary data.
        final r.RiveFile file = r.RiveFile.import(data);
        // The artboard is the root of the animation and gets drawn in the
        // Rive widget.
        final r.Artboard artboard = file.mainArtboard;
        // Add a controller to play back a known animation on the main/default
        // artboard.We store a reference to it so we can toggle playback.
        artboard.addController(_controller = r.SimpleAnimation('idle'));
        setState(() => _riveArtBoard = artboard);
      },
    );

    Future<void>.delayed(const Duration(seconds: 2)).then((_) {
      setState(() {
        _containerWidth = MediaQuery.of(context).size.width;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final ProjectViewModel viewModel = Provider.of<ProjectViewModel>(context);
    if (firstBuild) {
      if (viewModel.projects != null) {
        viewModel.projects!.sort((Project a, Project b) =>
            a.state.compareTo('published') *
            a.state.compareTo('unpublished') *
            a.state.compareTo(b.state));
        viewModel.projects = viewModel.projects!.reversed.toList();
        firstBuild = false;
      }
    }

    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 0, 0, 0),
              Color.fromARGB(255, 0, 6, 61),
            ],
          )),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 24,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          runSpacing: 24,
                          children: <Widget>[
                            Container(
                              child: Hero(
                                tag: 'logo',
                                child: Material(
                                  color: Colors.transparent,
                                  child: Wrap(
                                    alignment: isMobile
                                        ? WrapAlignment.center
                                        : WrapAlignment.start,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width: isMobile ? 200 : null,
                                        child: const Text(
                                          'TAJAOUART Mounir',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      if (isMobile)
                                        const Center()
                                      else
                                        Container(
                                          height: 24,
                                          width: 3,
                                          color: Colors.white,
                                        ),
                                      Container(
                                        width: 200,
                                        child: Row(
                                          children: [
                                            if (isMobile)
                                              Container(
                                                height: 24,
                                                width: 3,
                                                color: Colors.white,
                                              )
                                            else
                                              const SizedBox(),
                                            const Text(
                                              'Développeur mobile',
                                              textAlign: TextAlign.end,
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 182, 42, 222),
                                                  fontSize: 17),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const SizedBox(
                                    width: 48,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextButton(
                                        onPressed: () {
                                          widget.onTapped('contact');
                                        },
                                        child: const Text(
                                          'Contact',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextButton(
                                        onPressed: () {
                                          widget.onTapped('CGU');
                                        },
                                        child: const Text(
                                          'CGU',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextButton(
                                        onPressed: () {
                                          widget.onTapped('CV');
                                        },
                                        child: const Text(
                                          'CV',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        )),
                                  ),
                                  const SizedBox(
                                    width: 48,
                                  )
                                ],
                              ),
                            )
                          ]),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 48,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Wrap(
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        child: Container(
                            height: 200,
                            width: 200,
                            child: Image.asset(
                              'assets/profile_photo.jpg',
                              fit: BoxFit.fitWidth,
                            )),
                      ),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.cyan,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4))),
                                width: 5,
                                height: 200,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                constraints:
                                    const BoxConstraints(maxWidth: 450),
                                child: RichText(
                                  text: TextSpan(
                                    style: GoogleFonts.openSansCondensed(
                                      height: 1.5,
                                      color: Colors.white,
                                      fontSize: 23,
                                    ),
                                    text: '',
                                    children: <TextSpan>[
                                      const TextSpan(text: 'Je suis '),
                                      TextSpan(
                                          text: 'développeur mobile ',
                                          style: GoogleFonts.openSansCondensed(
                                              fontWeight: FontWeight.bold)),
                                      highlightedText('Android/iOS'),
                                      const TextSpan(
                                          text:
                                              '; j\'ai participé au développement de plusieurs applications notamment durant mon alternance en utilisant Android Studio pour Android et XCode pour iOS. Je me suis orienté aussi vers le Cross-Platforme avec le FrameWork'),
                                      highlightedText(' Flutter '),
                                      const TextSpan(
                                          text:
                                              'qui permet de créer des applications natives Android et IOS et même pour le Web. (ce site est créé avec Flutter) ')
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                const Text(
                  'Les outils',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Wrap(
                    runAlignment: WrapAlignment.center,
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      Container(
                        width: null,
                        height: 100,
                        child: Image.asset('assets/flutter.png',
                            fit: BoxFit.contain),
                      ),
                      Container(
                          width: null,
                          height: 100,
                          child: Image.asset('assets/android.png',
                              fit: BoxFit.contain)),
                      Container(
                          width: null,
                          height: 100,
                          child: Image.asset('assets/xcode.png',
                              fit: BoxFit.contain)),
                      Container(
                          width: null,
                          height: 100,
                          child: Image.asset(
                            'assets/adobexd.png',
                            fit: BoxFit.contain,
                          )),
                      Container(
                          width: null,
                          height: 100,
                          child: Image.asset('assets/firebase.png',
                              fit: BoxFit.contain)),
                      Container(
                        width: null,
                        height: 100,
                        child: Image.asset('assets/django.png',
                            fit: BoxFit.contain),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                const Text(
                  'Les projets',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 50),
                if (viewModel.projects != null &&
                    viewModel.projects!.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.all(isMobile ? 8 : 24.0),
                    child: Wrap(
                      spacing: 100,
                      runSpacing: 100,
                      children: [
                        for (final Project project in viewModel.projects!)
                          InkWell(
                            onTap: (project.state == 'published')
                                ? () => widget.onTapped(project)
                                : (project.state == 'website')
                                    ? () => _launchURL(
                                        'https://lounacar-11541.web.app/')
                                    : () => _launchURL(
                                        'https://www.linkedin.com/in/tajaouart'),
                            child: ProjectWidget(project),
                          )
                      ],
                    ),
                  )
                else
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                const SizedBox(
                  height: 100,
                ),
                const Text(
                  'Trouvez-moi sur',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                          onTap: () => _launchURL(
                              'https://www.linkedin.com/in/tajaouart'),
                          child: Container(
                              width: 50,
                              child: Image.asset('assets/linkedin.png'))),
                      const SizedBox(
                        width: 32,
                      ),
                      InkWell(
                          onTap: () => _launchURL(
                              'https://www.malt.fr/profile/mounirtajaouart'),
                          child: Container(
                              width: 50, child: Image.asset('assets/malt.png')))
                    ],
                  ),
                ),
                const SizedBox(height: 100),
                if (_riveArtBoard == null)
                  const SizedBox()
                else
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    child: FittedBox(
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        children: <Widget>[
                          AnimatedContainer(
                              onEnd: () {
                                setState(() {
                                  _containerWidth = _containerWidth == 0
                                      ? MediaQuery.of(context).size.width
                                      : 0;
                                  reverse = !reverse;
                                });
                              },
                              width: _containerWidth,
                              curve: Curves.slowMiddle,
                              duration: const Duration(seconds: 5)),
                          Transform(
                            transform: reverse
                                ? Matrix4.rotationY(3.14)
                                : Matrix4.rotationY(0),
                            alignment: Alignment.center,
                            child: Container(
                                width: 300,
                                height: 300,
                                child: r.Rive(artboard: _riveArtBoard!)),
                          )
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 100),
                const Center(
                    child: Text(
                  '© All Rights Reserved',
                  style: TextStyle(color: Colors.white),
                )),
                const SizedBox(height: 16),
              ],
            ),
          )),
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

TextSpan highlightedText(String txt) {
  return TextSpan(
      text: txt,
      style: GoogleFonts.openSansCondensed(
          color: const Color.fromARGB(255, 182, 42, 222),
          fontWeight: FontWeight.bold));
}

class ProjectRouteInformationParser
    extends RouteInformationParser<ProjectRoutePath> {
  @override
  Future<ProjectRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final Uri uri = Uri.parse(routeInformation.location!);
    // Handle '/'
    if (uri.pathSegments.isEmpty) {
      return ProjectRoutePath.home();
    }

    if (uri.pathSegments.length == 1) {
      // Handle '/contact'
      if (uri.pathSegments[0] == 'contact')
        return ProjectRoutePath.contact('contact');

      // Handle '/CGU'
      if (uri.pathSegments[0] == 'CGU') {
        return ProjectRoutePath.cgu('CGU');
      }

      // Handle '/CV'
      if (uri.pathSegments[0] != 'CV') {
        ProjectRoutePath.unknown();
      }
      return ProjectRoutePath.cv('CV');
    }

    // Handle '/project/:name'
    if (uri.pathSegments.length == 2) {
      if (uri.pathSegments[0] != 'project') {
        return ProjectRoutePath.unknown();
      }
      final String remaining = uri.pathSegments[1];
      final String name = remaining.toString();
      if (name.isEmpty) {
        return ProjectRoutePath.unknown();
      }
      return ProjectRoutePath.details(name);
    }

    // Handle unknown routes
    return ProjectRoutePath.unknown();
  }

  @override
  RouteInformation? restoreRouteInformation(ProjectRoutePath configuration) {
    if (configuration.isUnknown) {
      return const RouteInformation(location: '/404');
    }
    if (configuration.isHomePage) {
      return const RouteInformation(location: '/');
    }
    if (configuration.isContactPage) {
      return const RouteInformation(location: '/contact');
    }
    if (configuration.isCGUPage) {
      return const RouteInformation(location: '/CGU');
    }
    if (configuration.isCVPage) {
      return const RouteInformation(location: '/CV');
    }
    if (configuration.isDetailsPage) {
      return RouteInformation(location: '/project/${configuration.name}');
    }
    return null;
  }
}

class ProjectRouterDelegate extends RouterDelegate<ProjectRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<ProjectRoutePath> {
  ProjectRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  @override
  final GlobalKey<NavigatorState> navigatorKey;
  NoAnimationTransitionDelegate transitionDelegate =
      NoAnimationTransitionDelegate();

  Project? _selectedProject;
  String? name;
  bool show404 = false;

  @override
  ProjectRoutePath get currentConfiguration {
    if (show404) {
      return ProjectRoutePath.unknown();
    }
    return (_selectedProject == null && name == null)
        ? ProjectRoutePath.home()
        : name == 'contact'
            ? ProjectRoutePath.contact('contact')
            : name == 'CGU'
                ? ProjectRoutePath.cgu('CGU')
                : name == 'CV'
                    ? ProjectRoutePath.cv('CV')
                    : ProjectRoutePath.details(_selectedProject == null
                        ? name
                        : _selectedProject!.name);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      transitionDelegate: transitionDelegate,
      pages: [
        MaterialPage(
          key: const ValueKey('ProjectsListPage'),
          child: MyHomePage(
            onTapped: _handlePushRoute,
            projects: [],
          ),
        ),
        if (show404)
          MaterialPage(
              key: const ValueKey('UnknownPage'), child: UnknownScreen())
        else if (name == 'contact')
          MaterialPage(key: const ValueKey('contact'), child: ContactScreen())
        else if (name == 'CGU')
          MaterialPage(key: const ValueKey('CGU'), child: CGUScreen())
        else if (name == 'CV')
          MaterialPage(key: const ValueKey('CV'), child: CVScreen())
        else if (_selectedProject != null)
          ProjectDetailsPage(project: _selectedProject)
        else if (name != null)
          ProjectDetailsPage(name: name)
      ],
      onPopPage: (Route route, dynamic result) {
        if (!route.didPop(result)) {
          return false;
        }

        // Update the main by setting resting values
        _selectedProject = null;
        name = null;
        show404 = false;
        notifyListeners();

        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(ProjectRoutePath configuration) async {
    if (configuration.isUnknown) {
      _selectedProject = null;
      show404 = true;
      name = null;
      return;
    }

    if (configuration.isDetailsPage) {
      name = configuration.name;
      if (_selectedProject == null && name == null) {
        show404 = true;
        return;
      }
    } else if (configuration.isContactPage) {
      name = 'contact';
      _selectedProject = null;
      show404 = false;
    } else if (configuration.isCGUPage) {
      name = 'CGU';
      _selectedProject = null;
      show404 = false;
    } else if (configuration.isCVPage) {
      name = 'CV';
      _selectedProject = null;
      show404 = false;
    } else {
      _selectedProject = null;
    }

    show404 = false;
  }

  void _handlePushRoute(dynamic object) {
    if (object is Project) {
      _selectedProject = object;
    } else if (object.toString() == 'contact') {
      _selectedProject = null;
      name = 'contact';
    } else if (object.toString() == 'CGU') {
      _selectedProject = null;
      name = 'CGU';
    } else if (object.toString() == 'CV') {
      _selectedProject = null;
      name = 'CV';
    }
    notifyListeners();
  }
}

class ProjectRoutePath {
  ProjectRoutePath.home()
      : name = null,
        isUnknown = false;
  ProjectRoutePath.details(this.name) : isUnknown = false;

  ProjectRoutePath.contact(this.name) : isUnknown = false;

  ProjectRoutePath.cgu(this.name) : isUnknown = false;

  ProjectRoutePath.cv(this.name) : isUnknown = false;

  ProjectRoutePath.unknown()
      : name = null,
        isUnknown = true;

  final String? name;
  final bool isUnknown;

  bool get isHomePage => name == null;

  bool get isContactPage => name == 'contact';

  bool get isCGUPage => name == 'CGU';

  bool get isCVPage => name == 'CV';

  bool get isDetailsPage =>
      name != null && name != 'contact' && name != 'CGU' && name != 'CV';
}
