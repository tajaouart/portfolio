import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'models.dart';

class NoAnimationTransitionDelegate extends TransitionDelegate<void> {
  @override
  Iterable<RouteTransitionRecord> resolve({
    List<RouteTransitionRecord> newPageRouteHistory,
    Map<RouteTransitionRecord, RouteTransitionRecord>
        locationToExitingPageRoute,
    Map<RouteTransitionRecord, List<RouteTransitionRecord>>
        pageRouteToPagelessRoutes,
  }) {
    final results = <RouteTransitionRecord>[];

    for (final pageRoute in newPageRouteHistory) {
      if (pageRoute.isWaitingForEnteringDecision) {
        pageRoute.markForAdd();
      }
      results.add(pageRoute);
    }

    for (final exitingPageRoute in locationToExitingPageRoute.values) {
      if (exitingPageRoute.isWaitingForExitingDecision) {
        exitingPageRoute.markForRemove();
        final pagelessRoutes = pageRouteToPagelessRoutes[exitingPageRoute];
        if (pagelessRoutes != null) {
          for (final pagelessRoute in pagelessRoutes) {
            pagelessRoute.markForRemove();
          }
        }
      }

      results.add(exitingPageRoute);
    }
    return results;
  }
}

class ProjectWidget extends StatelessWidget {
  Project project;

  ProjectWidget(this.project);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 208,
      width: 266,
      decoration: BoxDecoration(
          color: Colors.red,
          image: DecorationImage(
            image: NetworkImage(project.bigImagePath.toString()),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.all(Radius.circular(4))),
      child: Stack(
        children: [
          project.published
              ? Center()
              : Positioned.fill(
                  child: Container(
                    color: Colors.black.withAlpha(160),
                    child: project.published
                        ? Center()
                        : Expanded(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "L'application sera publiée prochainement, restez à jours avec mes postes sur LinkedIn",
                                  style: GoogleFonts.roboto(
                                      color: Colors.white, fontSize: 18),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: new BoxDecoration(
                  gradient: new LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(int.parse("0xFF${project.color}")).withAlpha(122),
                  Colors.black,
                ],
              )),
              height: 50,
              width: 266,
              child: Center(
                child: Text(
                  project.name,
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  TextEditingController myController;
  String label;
  UniqueKey key;
  int maxLines;
  bool isOK;

  CustomTextField({
    this.maxLines,
    @required this.label,
    @required this.key,
    @required this.myController,
    @required this.isOK,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: TextField(
          controller: myController,
          maxLines: maxLines,
          style: TextStyle(
            color: Color(0xFF707070),
          ),
          decoration: InputDecoration(
            alignLabelWithHint: true,
            filled: true,
            labelStyle: TextStyle(color: Color.fromARGB(255, 182, 42, 222)),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: isOK ? Color.fromARGB(255, 182, 42, 222) : Colors.red),
            ),
            fillColor: Colors.transparent,
            border: OutlineInputBorder(),
            labelText: label,
          ),
        ),
      ),
    );
  }
}
