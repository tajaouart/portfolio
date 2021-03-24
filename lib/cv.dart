import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class CVPage extends Page {
  CVPage() : super(key: ValueKey("cv"));

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
    var isMobile = MediaQuery.of(context).size.width < 414;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Curriculum vitæ"),
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Color.fromARGB(255, 0, 6, 61),
        ),
        body: Stack(
          children: [
            Center(
                child: PhotoView(
              imageProvider: AssetImage("assets/TAJOUART-Mounir_CV.png"),
              backgroundDecoration: new BoxDecoration(
                  gradient: new LinearGradient(
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
          backgroundColor: Color.fromARGB(255, 0, 6, 61),
          child: Icon(Icons.info_outline),
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
          title: Text('Double clique pour zoomer'),
          content: SingleChildScrollView(),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
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
