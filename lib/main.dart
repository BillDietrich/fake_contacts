import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

//import 'dart:io';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Fake Contacts',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Fake Contacts'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}



class _MyHomePageState extends State<MyHomePage> {

  String sListOfLastNames = "Zen,Zaragoza,Zabinski,Zimmermann";
  String sListOfFirstNames = "Zoe,Zach,Zbigniew,Zaire";
  var lastNames = [];
  var firstNames = [];
  String sPhoneNumberTemplate = "+21345678nnn";
  String sEmailAddressTemplate = "FIRST.LAST@example.com";

  Future<void> _createAllContacts() async {
    log("_createAllContacts: about to call Permission.contacts.request");
    PermissionStatus permission = await Permission.contacts.request();
    if (!permission.isGranted) {
      log("_createAllContacts: no permission");
    } else {
      // Either the permission was already granted before or the user just granted it.
      Contact newContact = Contact(
          displayName: (firstNames[0] + " " + lastNames[0]), givenName: firstNames[0], familyName: lastNames[0]);
      newContact.phones = [Item(label: "mobile", value:"1234")];
      newContact.emails = [Item(label: "email", value:"abc@yahoo.com")];
      log("_createAllContacts: about to call ContactsService.addContact");
      // if Contact exists already, no error, another of same name is added
      await ContactsService.addContact(newContact);
    };
    log("_createAllContacts: about to return");
  }


  Future<void> _deleteAllContacts() async {
    log("_deleteAllContacts: called");
  }


  // this gets called every time a char gets changed in the field
  // wasteful to recalculate every time, but doesn't matter
  void _changedLastNames(String sNewValue){
    log("_changedLastNames: called, " + sNewValue);
    sListOfLastNames = sNewValue;
    lastNames = sListOfLastNames.split(",");
    log("_changedLastNames: lastNames[0] == " + lastNames[0]);
    log("_changedLastNames: lastNames.toString == " + lastNames.toString());
  }

  // this gets called every time a char gets changed in the field
  // wasteful to recalculate every time, but doesn't matter
  void _changedFirstNames(String sNewValue){
    log("_changedFirstNames: called, " + sNewValue);
    sListOfFirstNames = sNewValue;
    firstNames = sListOfFirstNames.split(",");
    log("_changedFirstNames: firstNames[0] == " + firstNames[0]);
    log("_changedFirstNames: firstNames.toString == " + firstNames.toString());
  }

  // this gets called every time a char gets changed in the field
  void _changedPhoneNumberTemplate(String sNewValue){
    log("_changedPhoneNumberTemplate: called, " + sNewValue);
    sPhoneNumberTemplate = sNewValue;
  }

  // this gets called every time a char gets changed in the field
  void _changedEmailAddressTemplate(String sNewValue){
    log("_changedEmailAddressTemplate: called, " + sNewValue);
    sEmailAddressTemplate = sNewValue;
  }

  @override
  Widget build(BuildContext context) {

    // to create the arrays of names
    _changedLastNames(sListOfLastNames);
    _changedFirstNames(sListOfFirstNames);

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              onChanged: _changedLastNames,
              maxLines: 1,
              initialValue: sListOfLastNames,
              decoration: new InputDecoration(
                labelText: 'Last names',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 5.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.greenAccent, width: 5.0),
                ),
              ),
            ),
            SizedBox(
              width: 10,
              height:20,
            ),
            TextFormField(
              onChanged: _changedFirstNames,
              maxLines: 1,
              initialValue: sListOfFirstNames,
              decoration: new InputDecoration(
                labelText: 'First names',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 5.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.greenAccent, width: 5.0),
                ),
              ),
            ),
            SizedBox(
              width: 10,
              height:30,
            ),
            TextFormField(
              onChanged: _changedPhoneNumberTemplate,
              maxLines: 1,
              initialValue: sPhoneNumberTemplate,
              decoration: new InputDecoration(
                labelText: 'Phone number template',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 5.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.greenAccent, width: 5.0),
                ),
              ),
            ),
            SizedBox(
              width: 10,
              height:20,
            ),
            TextFormField(
              onChanged: _changedEmailAddressTemplate,
              maxLines: 1,
              initialValue: sEmailAddressTemplate,
              decoration: new InputDecoration(
                labelText: 'Email address template',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 5.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.greenAccent, width: 5.0),
                ),
              ),
            ),
            SizedBox(
              width: 10,
              height:40,
            ),
            ElevatedButton(
              onPressed: () => _createAllContacts(),
              child: Text("Create Fake Contacts"),
            ),
            ElevatedButton(
              onPressed: () => _deleteAllContacts(),
              child: Text("Delete Fake Contacts"),
            ),
          ],
        ),
      ),
    );
  }
}
