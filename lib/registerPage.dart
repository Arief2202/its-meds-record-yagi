// ignore_for_file: file_names, camel_case_types, library_private_types_in_public_api, prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_const_declarations, sort_child_properties_last, prefer_const_constructors_in_immutables, prefer_final_fields, unused_field, curly_braces_in_flow_control_structures, no_leading_underscores_for_local_identifiers, prefer_interpolation_to_compose_strings, unnecessary_new, unnecessary_string_escapes, unused_import
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:yagi/globals.dart' as globals;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);
  @override
  RegisterPageState createState() {
    return new RegisterPageState();
  }
}

class RegisterPageState extends State<RegisterPage> {
  List<TextEditingController> _data = [TextEditingController(), TextEditingController(), TextEditingController(), TextEditingController()];
  List<bool> _error = [false, false, false, false];
  String _passwordMsg = "Value Can\'t Be Empty";

  _write(String text) async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    status = await Permission.accessMediaLocation.status;
    if (!status.isGranted) {
      await Permission.accessMediaLocation.request();
    }
    status = await Permission.manageExternalStorage.status;
    if (!status.isGranted) {
      await Permission.manageExternalStorage.request();
    }
    final Directory newDirectory = Directory('/storage/emulated/0/meds_record');
    if (await newDirectory.exists() == false) {
      await newDirectory.create();
    }
    final File file = File('/storage/emulated/0/meds_record/profile.txt');
    if (await file.exists() == false) {
      await file.create();
    }
    print(file);
    await file.writeAsString(text);
    Alert(
          context: context,
          type: AlertType.success,
          title: "Export Success",
          desc: "File Exported to \n/storage/emulated/0/meds_record/profile.txt",
          style: AlertStyle(
            descStyle: TextStyle(
              fontSize: 14
            )
          ),

          buttons: [
            DialogButton(
              child: Text(
                "OK",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ],
        ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Container(
              margin: new EdgeInsets.only(left: 20.0, right: 20.0, top: 30),
              child: Column(
                children: <Widget>[
                  Image.asset(
                    'assets/img/logo.png',
                    width: MediaQuery.of(context).size.width/2,
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.width / 15),
            Container(
              margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nama',
                      labelStyle: TextStyle(fontSize: 20),
                      errorText: _error[0] ? 'Value Can\'t Be Empty' : null,
                    ),
                    controller: _data[0],
                  )
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.width / 15),
            Container(
              margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'NIK',
                      labelStyle: TextStyle(fontSize: 20),
                      errorText: _error[1] ? 'Value Can\'t Be Empty' : null,
                    ),
                    controller: _data[1],
                  )
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.width / 15),
            Container(
              margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'No Telfon',
                      labelStyle: TextStyle(fontSize: 20),
                      errorText: _error[2] ? 'Value Can\'t Be Empty' : null,
                    ),
                    controller: _data[2],
                  )
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.width / 15),
            Container(
              margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      labelStyle: TextStyle(fontSize: 20),
                      errorText: _error[3] ? 'Value Can\'t Be Empty' : null,
                    ),
                    controller: _data[3],
                  )
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.width / 15),
            Container(
              margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 15),
              width: double.infinity,
              height: MediaQuery.of(context).size.width / 10,
              child: ElevatedButton(
                onPressed: () {
                  _doRegister(context);
                },
                child: Text(
                  "Create New Key",
                  style: TextStyle(fontSize: MediaQuery.of(context).size.width / 20),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.width / 15),
            SizedBox(height: MediaQuery.of(context).size.width / 15),
          ],
        ),
      ),
    );
  }

  Future _doRegister(context) async {
    bool status = true;
    setState(() {
      _passwordMsg = "Value Can\'t Be Empty";
      for (int a = 0; a < 4; a++) {
        if (_data[a].text.isEmpty) {
          _error[a] = true;
          status = false;
        } else
          _error[a] = false;
      }
    });
    if (status) {
      String _name = _data[0].text;
      String _nik = _data[1].text;
      String _phone = _data[2].text;
      String _email = _data[3].text;
      String json = "{\"name\": \"${_name}\",\"nik\": \"${_nik}\",\"phone\": \"${_phone}\",\"email\": \"${_email}\"}";
      print(json);


      final myKey = '4f1aaae66406e358';
      final myIV = 'df1e180949793972';
      final key = encrypt.Key.fromUtf8(myKey);
      final iv = encrypt.IV.fromUtf8(myIV);

      final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));
      final encrypted = encrypter.encrypt(json, iv: iv);
      final encryptedText = encrypted.base64;
      print(encryptedText);

      final Export = "{\"key\":\"${myKey}\",\"iv\":\"${myIV}\",\"padding\":\"PKCS7\",\"encrypted\":\"${encryptedText}\"}";
      print(Export);
      setState(() {
        globals.name=_name;
        globals.nik=_nik;
        globals.phone=_phone;
        globals.email=_email;
        globals.key=myKey;
        globals.iv=myIV;
        globals.encrypted=encryptedText;
        globals.isLoggedIn = true;
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('key', myKey);
      await prefs.setString('iv', myIV);
      await prefs.setString('padding', 'PKCS7');
      await prefs.setString('encrypted', encryptedText);

      Alert(
          context: context,
          type: AlertType.info,
          title: "Register Success",
          desc: "Key\n${myKey}\n\nIV\n${myIV}\n\nPadding\nPKCS7\n\nEncrypted Data\n${encryptedText}",
          style: AlertStyle(
            descStyle: TextStyle(
              fontSize: 12
            )
          ),

          buttons: [
            DialogButton(
              child: Text(
                "Export",
                style: TextStyle(color: Colors.white, fontSize: 20 ),
              ),
              onPressed: () async{
                _write(Export);
                // Navigator.pop(context);
              },
            ),
            DialogButton(
              child: Text(
                "OK",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: (){
                  Phoenix.rebirth(context);
              },
            ),
          ],
        ).show();
    }
  }
}
