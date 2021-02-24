import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'components.dart';

class ContacPage extends Page {
  ContacPage() : super(key: ValueKey("contact"));

  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return ContactScreen();
      },
    );
  }
}

class ContactScreen extends StatefulWidget {
  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final nameController = TextEditingController();
  final mailController = TextEditingController();
  final messageController = TextEditingController();

  bool messageIsSucceeded = false;
  List<bool> textFieldsStatus = [true, true, true];

  @override
  void initState() {
    super.initState();
  }

  Widget _flightShuttleBuilder(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    return DefaultTextStyle(
      style: DefaultTextStyle.of(toHeroContext).style,
      child: toHeroContext.widget,
    );
  }

  @override
  Widget build(BuildContext context) {
    var isMobile = MediaQuery.of(context).size.width < 414;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 15, 20, 68),
        shadowColor: Colors.transparent,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.close)),
      ),
      body: Container(
        decoration: new BoxDecoration(
            gradient: new LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 15, 20, 68),
            Color.fromARGB(255, 0, 0, 0)
          ],
        )),
        child: ListView(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Hero(
                        tag: "logo",
                        child: Material(
                          color: Colors.transparent,
                          child: Wrap(
                            alignment: isMobile
                                ? WrapAlignment.center
                                : WrapAlignment.start,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Container(
                                width: isMobile ? 200 : null,
                                child: Text(
                                  "TAJAOUART Mounir",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              isMobile
                                  ? Center()
                                  : Container(
                                      height: 24,
                                      width: 3,
                                      color: Colors.white,
                                    ),
                              Container(
                                width: 200,
                                child: Row(
                                  children: [
                                    isMobile
                                        ? Container(
                                            height: 24,
                                            width: 3,
                                            color: Colors.white,
                                          )
                                        : SizedBox(),
                                    Text(
                                      "Développeur mobile",
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 182, 42, 222),
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
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        'Contact',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: const Color(0xFF070034),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      width: 500,
                      height: 800,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomTextField(
                              label: "Nom Complet",
                              key: UniqueKey(),
                              myController: nameController,
                              isOK: textFieldsStatus[0]),
                          CustomTextField(
                              label: "Mail",
                              key: UniqueKey(),
                              myController: mailController,
                              isOK: textFieldsStatus[1]),
                          Container(
                            child: CustomTextField(
                                label: "Message",
                                key: UniqueKey(),
                                myController: messageController,
                                isOK: textFieldsStatus[2],
                                maxLines: 20),
                          ),
                          TextButton(
                              onPressed: () async {
                                if (nameController.text != "" &&
                                    mailController.text != "" &&
                                    messageController.text != "") {
                                  CollectionReference messages =
                                      FirebaseFirestore.instance
                                          .collection('messages');

                                  // Call the user's CollectionReference to add a new user
                                  messages.add({
                                    'full_name':
                                        nameController.text, // John Doe
                                    'mail':
                                        mailController.text, // Stokes and Sons
                                    'message': messageController.text // 42
                                  }).then((value) {
                                    setState(() {
                                      nameController.text = "";
                                      mailController.text = "";
                                      messageController.text = "";
                                      messageIsSucceeded = true;
                                      textFieldsStatus[0] = true;
                                      textFieldsStatus[1] = true;
                                      textFieldsStatus[2] = true;
                                    });
                                  }).catchError((error) {
                                    setState(() {
                                      messageIsSucceeded = false;
                                      textFieldsStatus[0] = false;
                                      textFieldsStatus[1] = false;
                                      textFieldsStatus[2] = false;
                                    });
                                  });
                                } else {
                                  setState(() {
                                    messageIsSucceeded = false;
                                    textFieldsStatus[0] =
                                        nameController.text != "";
                                    textFieldsStatus[1] =
                                        mailController.text != "";
                                    textFieldsStatus[2] =
                                        messageController.text != "";
                                  });
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: messageIsSucceeded
                                        ? Colors.green
                                        : Color.fromARGB(255, 182, 42, 222),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(9))),
                                width: 150,
                                height: 40,
                                child: Material(
                                  color: Colors.transparent,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(
                                        messageIsSucceeded
                                            ? "Message envoyé"
                                            : "Envoyer",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
