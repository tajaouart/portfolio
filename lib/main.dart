import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'models.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TAJAOUART Mounir',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Project> projects = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('projects').get();

    List<Project> listProjects = Project.fromJsonList(querySnapshot.docs);

    if (listProjects.isNotEmpty) {
      setState(() {
        projects = listProjects;
      });
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load Suggestions from Server');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: new BoxDecoration(
              gradient: new LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 0, 0, 0),
              Color.fromARGB(255, 0, 6, 61),
            ],
          )),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Text(
                  "TAJAOURT Mounir",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "Développeur mobile",
                  style: TextStyle(
                      color: Color.fromARGB(255, 182, 42, 222), fontSize: 17),
                ),
                SizedBox(
                  height: 48,
                ),
                Text(
                  "Les projects",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 24),
                Column(
                  children: getProjects(),
                )
              ],
            ),
          )),
    );
  }

  List<Widget> getProjects() {
    return List.generate(projects.length, (index) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0, top: 16),
        child: InkWell(
          onTap: () {},
          child: Container(
            height: 208,
            width: 266,
            decoration: BoxDecoration(
                color: Colors.red,
                image: DecorationImage(
                  image: NetworkImage(projects[index].bigImagePath.toString()),
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
                    Color(int.parse("0xFF${projects[index].color}"))
                        .withAlpha(122),
                    Colors.black,
                  ],
                )),
                height: 50,
                width: 266,
                child: Center(
                  child: Text(
                    projects[index].name,
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
