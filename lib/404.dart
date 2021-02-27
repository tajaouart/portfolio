import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
                  semanticsLabel: 'Page not found'),
            ),
          ),
        ));
  }
}
