import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class CVPage extends Page {
  const CVPage() : super(key: const ValueKey('cv'));

  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return CVScreen();
      },
    );
  }
}

class CVScreen extends StatefulWidget {
  @override
  _CVScreenState createState() => _CVScreenState();
}

class _CVScreenState extends State<CVScreen> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Curriculum vitæ'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: const Color.fromARGB(255, 0, 6, 61),
        ),
        body: Stack(
          children: [
            Center(
                child: PhotoView(
              imageProvider: const AssetImage('assets/TAJOUART-Mounir_CV.png'),
              backgroundDecoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    Color.fromARGB(255, 0, 0, 0),
                    Color.fromARGB(255, 0, 6, 61)
                  ])),
            ))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 0, 6, 61),
          child: const Icon(Icons.info_outline),
          onPressed: () {
            _showMyDialog();
          },
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Double clique pour zoomer'),
          content: const SingleChildScrollView(),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
