import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as service;
import 'package:rive/rive.dart' as r;

import 'components.dart';

class ContactPage extends Page {
  const ContactPage() : super(key: const ValueKey('contact'));

  @override
  MaterialPageRoute<Widget> createRoute(BuildContext context) {
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
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  bool messageIsSucceeded = false;
  List<bool> textFieldsStatus = <bool>[true, true, true];
  r.RiveAnimationController? _controller;

  @override
  void initState() {
    super.initState();
    service.rootBundle.load('assets/mail.riv').then(
      (service.ByteData data) async {
        // Load the RiveFile from the binary data.
        final r.RiveFile file = r.RiveFile.import(data);
        // The artboard is the root of the animation and gets drawn in the
        // Rive widget.
        final r.Artboard artboard = file.mainArtboard;
        // Add a controller to play back a known animation on the main/default
        // artboard.We store a reference to it so we can toggle playback.
        artboard.addController(_controller = r.SimpleAnimation('mail'));
        setState(() => _riveArtBoard = artboard);
      },
    );
  }

  r.Artboard? _riveArtBoard;

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 414;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 15, 20, 68),
        shadowColor: Colors.transparent,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close)),
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 15, 20, 68),
            Color.fromARGB(255, 0, 0, 0)
          ],
        )),
        child: Stack(
          children: <Widget>[
            if (_riveArtBoard == null)
              const SizedBox()
            else
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                    height: 500,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: <Widget>[
                        Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: r.Rive(artboard: _riveArtBoard!)),
                      ],
                    )),
              ),
            ListView(
              children: <Widget>[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Hero(
                            tag: 'logo',
                            child: Material(
                              color: Colors.transparent,
                              child: Wrap(
                                alignment: isMobile
                                    ? WrapAlignment.center
                                    : WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.center,
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
                                      children: <Widget>[
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
                        const Padding(
                          padding: EdgeInsets.all(24.0),
                          child: Text(
                            'Contact',
                            style: TextStyle(color: Colors.white, fontSize: 24),
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                              color: Color(0xFF070034),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          width: 500,
                          height: 800,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              CustomTextField(
                                  label: 'Nom Complet',
                                  key: UniqueKey(),
                                  myController: nameController,
                                  isOK: textFieldsStatus[0]),
                              CustomTextField(
                                  label: 'Mail',
                                  key: UniqueKey(),
                                  myController: mailController,
                                  isOK: textFieldsStatus[1]),
                              Container(
                                child: CustomTextField(
                                    label: 'Message',
                                    key: UniqueKey(),
                                    myController: messageController,
                                    isOK: textFieldsStatus[2],
                                    maxLines: 20),
                              ),
                              TextButton(
                                  onPressed: () async {
                                    if (nameController.text != '' &&
                                        mailController.text != '' &&
                                        messageController.text != '') {
                                      final CollectionReference messages =
                                          FirebaseFirestore.instance
                                              .collection('messages');

                                      // Call the user's CollectionReference to add a new user
                                      messages.add(<String, String>{
                                        'full_name':
                                            nameController.text, // John Doe
                                        'mail': mailController
                                            .text, // Stokes and Sons
                                        'message': messageController.text // 42
                                      }).then((DocumentReference value) {
                                        setState(() {
                                          nameController.text = '';
                                          mailController.text = '';
                                          messageController.text = '';
                                          messageIsSucceeded = true;
                                          textFieldsStatus[0] = true;
                                          textFieldsStatus[1] = true;
                                          textFieldsStatus[2] = true;
                                        });
                                      }).catchError(() {
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
                                            nameController.text != '';
                                        textFieldsStatus[1] =
                                            mailController.text != '';
                                        textFieldsStatus[2] =
                                            messageController.text != '';
                                      });
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: messageIsSucceeded
                                            ? Colors.green
                                            : const Color.fromARGB(
                                                255, 182, 42, 222),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(9))),
                                    width: 150,
                                    height: 40,
                                    child: Material(
                                      color: Colors.transparent,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Text(
                                            messageIsSucceeded
                                                ? 'Message envoyé'
                                                : 'Envoyer',
                                            style: const TextStyle(
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
                        const SizedBox(
                          height: 32,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
