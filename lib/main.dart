//import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
//import 'dart:math' hide log;
import 'package:shared_preferences/shared_preferences.dart';

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

  String sListOfLastNames = "";
  String sListOfFirstNames = "";
  var lastNames = [];
  var firstNames = [];
  String sPhoneNumberTemplate = "";
  String sEmailAddressTemplate = "";

  Key keyLastNames = Key("LastNames");
  Key keyFirstNames = Key("FirstNames");
  Key keyPhoneNumberTemplate = Key("PhoneNumberTemplate");
  Key keyEmailAddressTemplate = Key("EmailAddressTemplate");

  GetSettings() {
    log("GetSettings: called");

    SharedPreferences prefs = null;

    if (false) {
      try {
        //prefs = await SharedPreferences.getInstance();
        ;
      } catch (e) {
        log("GetSettings: exception1 " + e);
        return null;
      }

      try {
        sListOfLastNames = prefs.getString('sListOfLastNames');
      } catch (e) {
        log("GetSettings: exception2 " + e);
        return null;
      }
      //log("GetSettings: saved last names " + sListOfLastNames);
    }

    if (false) {
      sListOfLastNames = (prefs.getString('sListOfLastNames') ??
          "Zen,Zaragoza,Zabinski,Zimmermann,Zapata,Zona,Zidane");
      sListOfFirstNames =
      (prefs.getString('sListOfFirstNames') ?? "Zoe,Zach,Zbigniew,Zaire,Zero");
      sPhoneNumberTemplate =
      (prefs.getString('sPhoneNumberTemplate') ?? "+21345678nnn");
      sEmailAddressTemplate =
      (prefs.getString('sEmailAddressTemplate') ?? "FIRST.LAST@example.com");
    } else {
      sListOfLastNames = "Zen,Zaragoza,Zabinski,Zimmermann,Zapata,Zona,Zidane";
      sListOfFirstNames = "Zoe,Zach,Zbigniew,Zaire,Zero";
      sPhoneNumberTemplate = "+21345678nnn";
      sEmailAddressTemplate = "FIRST.LAST@example.com";
    }

    // to create the arrays of names
    _changedLastNames(sListOfLastNames);
    _changedFirstNames(sListOfFirstNames);

    return prefs;
  }

  void SaveSettings() async {
    log("SaveSettings: called");

    final SharedPreferences prefs = await SharedPreferences.getInstance();;
    await prefs.setString("sListOfLastNames", sListOfLastNames);
    await prefs.setString("sListOfFirstNames", sListOfFirstNames);
    await prefs.setString("sPhoneNumberTemplate", sPhoneNumberTemplate);
    await prefs.setString("sEmailAddressTemplate", sEmailAddressTemplate);
  }

    String generatePhoneNumber(String sLastName) {
    log("generatePhoneNumber: called, sPhoneNumberTemplate " + sPhoneNumberTemplate + ", sLastName " + sLastName);
    String sNumber = "";
    int nNext = 0; // next char to use in sLastName

    for (var i = 0; i < sPhoneNumberTemplate.length; i++) {
      //log("generatePhoneNumber: i " + i.toString() + ", sPhoneNumberTemplate[i] " + sPhoneNumberTemplate[i] + ", nNext " + nNext.toString());
      if (sPhoneNumberTemplate[i] != 'n') {
        sNumber += sPhoneNumberTemplate[i];
      } else {
        if (nNext >= sLastName.length)
          sNumber += "0";
        else {
          sNumber +=
          (String.fromCharCode(
              "0".codeUnitAt(0) + (sLastName.codeUnitAt(nNext) % 10)));
          nNext++;
        }
      }
    }

    log("generatePhoneNumber: returning, sNumber " + sNumber);
    return sNumber;
  }


  String generateEmailAddress(String sLastName, String sFirstName) {
    return sEmailAddressTemplate.replaceAll("FIRST", sFirstName).replaceAll("LAST", sLastName);
  }

  Future<void> _createAllContacts() async {

    log("_createAllContacts: about to call Permission.contacts.request");
    PermissionStatus permission = await Permission.contacts.request();

    if (!permission.isGranted) {
      log("_createAllContacts: no permission");
    } else {
      // Either the permission was already granted before or the user just granted it.

      for (var i=0 ; i<lastNames.length ; i++) {
        for (var j = 0; j < firstNames.length; j++) {
          Contact newContact = Contact(
              displayName: (firstNames[j] + " " + lastNames[i]),
              givenName: firstNames[j],
              familyName: lastNames[i]);
          newContact.phones = [Item(label: "mobile", value: generatePhoneNumber(lastNames[i]))];
          newContact.emails = [Item(label: "email", value: generateEmailAddress(lastNames[i], firstNames[j]))];
          log("_createAllContacts: about to call ContactsService.addContact(" + newContact.displayName + ")");
          // if Contact exists already, no error, another of same name is added
          await ContactsService.addContact(newContact);
        }
      }

    };
    log("_createAllContacts: about to return");
  }

  Future<void> _deleteAllContacts() async {
    log("_deleteAllContacts: about to call Permission.contacts.request");
    PermissionStatus permission = await Permission.contacts.request();
    if (!permission.isGranted) {
      log("_deleteAllContacts: no permission");
    } else {
      // Either the permission was already granted before or the user just granted it.
      for (var i=0 ; i<lastNames.length ; i++) {
        for (var j = 0; j < firstNames.length; j++) {
          Contact newContact = Contact(
              displayName: (firstNames[j] + " " + lastNames[i]),
              givenName: firstNames[j],
              familyName: lastNames[i]);
          log("_deleteAllContacts: about to call ContactsService.getContacts(" + newContact.displayName + ")");
          Iterable<Contact> iContacts = await ContactsService.getContacts(query: newContact.displayName);
          for (var c in iContacts) {
            log(
                "_deleteAllContacts: about to call ContactsService.deleteContact(" +
                    newContact.displayName + ")");
            await ContactsService.deleteContact(c);
          }
        }
      }
    };
    log("_deleteAllContacts: about to return");
  }


  // this gets called every time a char gets changed in the field
  // wasteful to recalculate every time, but doesn't matter
  void _changedLastNames(String sNewValue){
    log("_changedLastNames: called, " + sNewValue);
    sListOfLastNames = sNewValue;
    lastNames = sListOfLastNames.split(",");
    log("_changedLastNames: lastNames[0] == " + lastNames[0]);
    log("_changedLastNames: lastNames.toString == " + lastNames.toString());

    SaveSettings();
  }

  // this gets called every time a char gets changed in the field
  // wasteful to recalculate every time, but doesn't matter
  void _changedFirstNames(String sNewValue){
    log("_changedFirstNames: called, " + sNewValue);
    sListOfFirstNames = sNewValue;
    firstNames = sListOfFirstNames.split(",");
    log("_changedFirstNames: firstNames[0] == " + firstNames[0]);
    log("_changedFirstNames: firstNames.toString == " + firstNames.toString());

    SaveSettings();
  }

  // this gets called every time a char gets changed in the field
  void _changedPhoneNumberTemplate(String sNewValue){
    log("_changedPhoneNumberTemplate: called, " + sNewValue);
    sPhoneNumberTemplate = sNewValue;

    SaveSettings();
  }

  // this gets called every time a char gets changed in the field
  void _changedEmailAddressTemplate(String sNewValue){
    log("_changedEmailAddressTemplate: called, " + sNewValue);
    sEmailAddressTemplate = sNewValue;

    SaveSettings();
  }

  @override
  Widget build(BuildContext context) {

    GetSettings();
    // but needs to be async to do storage !!!

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
              key: keyLastNames,
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
              key: keyFirstNames,
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
              key: keyPhoneNumberTemplate,
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
              key: keyEmailAddressTemplate,
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
