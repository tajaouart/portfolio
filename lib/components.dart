import 'package:flutter/material.dart';

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
      child: Align(
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
      ),
    );
  }
}
