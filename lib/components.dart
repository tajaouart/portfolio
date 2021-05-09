import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'models.dart';

class NoAnimationTransitionDelegate extends TransitionDelegate<void> {
  @override
  Iterable<RouteTransitionRecord> resolve({
    required List<RouteTransitionRecord> newPageRouteHistory,
    required Map<RouteTransitionRecord?, RouteTransitionRecord>
        locationToExitingPageRoute,
    Map<RouteTransitionRecord?, List<RouteTransitionRecord>>?
        pageRouteToPagelessRoutes,
  }) {
    final List<RouteTransitionRecord> results = <RouteTransitionRecord>[];

    for (final RouteTransitionRecord pageRoute in newPageRouteHistory) {
      if (pageRoute.isWaitingForEnteringDecision) {
        pageRoute.markForAdd();
      }
      results.add(pageRoute);
    }

    for (final RouteTransitionRecord exitingPageRoute
        in locationToExitingPageRoute.values) {
      if (exitingPageRoute.isWaitingForExitingDecision) {
        exitingPageRoute.markForRemove();
        final List<RouteTransitionRecord>? pagelessRoutes =
            pageRouteToPagelessRoutes![exitingPageRoute];
        if (pagelessRoutes != null) {
          for (final RouteTransitionRecord pagelessRoute in pagelessRoutes) {
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
  const ProjectWidget(this.project);

  final Project project;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 208,
      width: 266,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(4))),
      child: Stack(
        children: [
          Positioned.fill(
            child:
                (project.state == 'in_progress' || project.bigImagePath.isEmpty)
                    ? SvgPicture.asset(
                        'assets/in_progress.svg',
                      )
                    : Image.network(
                        project.bigImagePath.toString(),
                        fit: BoxFit.cover,
                      ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Color(int.parse('0xFF${project.color}')).withAlpha(122),
                  Colors.black,
                ],
              )),
              height: 50,
              width: 266,
              child: Center(
                child: Text(
                  (project.state == 'in_progress')
                      ? 'Projet en cours'
                      : project.name,
                  style: const TextStyle(color: Colors.white, fontSize: 17),
                ),
              ),
            ),
          ),
          if (project.state == 'unpublished')
            Positioned.fill(
              child: Container(
                color: Colors.black.withAlpha(160),
                child: (project.state == 'published')
                    ? const Center()
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'L\'application sera publiée prochainement, restez à jours avec mes postes sur LinkedIn',
                            style: GoogleFonts.roboto(
                                backgroundColor: Colors.black87,
                                color: Colors.white,
                                fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
              ),
            )
          else
            const Center()
        ],
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    this.maxLines,
    required this.label,
    required this.key,
    required this.myController,
    required this.isOK,
  });

  final TextEditingController myController;
  final String label;
  final UniqueKey key;
  final int? maxLines;
  final bool isOK;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: TextField(
          controller: myController,
          maxLines: maxLines,
          style: const TextStyle(
            color: Color(0xFF707070),
          ),
          decoration: InputDecoration(
            alignLabelWithHint: true,
            filled: true,
            labelStyle:
                const TextStyle(color: Color.fromARGB(255, 182, 42, 222)),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: isOK
                      ? const Color.fromARGB(255, 182, 42, 222)
                      : Colors.red),
            ),
            fillColor: Colors.transparent,
            border: const OutlineInputBorder(),
            labelText: label,
          ),
        ),
      ),
    );
  }
}
