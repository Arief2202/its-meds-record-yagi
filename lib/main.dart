import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yagi/Dashboard.dart';
import 'package:yagi/landingPage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:yagi/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:permission_handler/permission_handler.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:async';

void main() {
  runApp(
    Phoenix(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Auto Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // scaffoldBackgroundColor: Color(0xFF736AB7),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController nameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    autoLogIn();
  }

  void autoLogIn() async {
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

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? keyStorage = prefs.getString('key');
    final String? ivStorage = prefs.getString('iv');
    final String? paddingStorage = prefs.getString('padding');
    final String? encryptedStorage = prefs.getString('encrypted');

    if (keyStorage != null && ivStorage != null && encryptedStorage != null) {
      final key = encrypt.Key.fromUtf8(keyStorage!);
      final iv = encrypt.IV.fromUtf8(ivStorage!);
      final decrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc,padding: paddingStorage ?? "PKCS7"));
      final decrypted = decrypter.decryptBytes(encrypt.Encrypted.from64(encryptedStorage!), iv: iv);
      final decryptedString = utf8.decode(decrypted);
      final user = jsonDecode(decryptedString) as Map<String, dynamic>;
      setState(() {
        globals.name=user['name'];
        globals.nik=user['nik'];
        globals.phone=user['phone'];
        globals.email=user['email'];
        globals.key=keyStorage;
        globals.iv=ivStorage;
        globals.encrypted=encryptedStorage;
        globals.isLoggedIn = true;
      });
    }
    else {
        await prefs.remove('key');
        await prefs.remove('iv');
        await prefs.remove('padding');
        await prefs.remove('encrypted');
        setState(() {
        globals.name="";
        globals.nik="";
        globals.phone="";
        globals.email="";
        globals.key="";
        globals.iv="";
        globals.encrypted="";
        globals.isLoggedIn = false;
        });
        // Alert(
        //   context: context,
        //   type: AlertType.info,
        //   title: "Login Failed!",
        //   desc: "Please relogin",
        //   buttons: [
        //     DialogButton(
        //       child: Text(
        //         "OK",
        //         style: TextStyle(color: Colors.white, fontSize: 20),
        //       ),
        //       onPressed: () => Navigator.pop(context),
        //     )
        //   ],
        // ).show();
      }
      setState(() {
        globals.loadingAutologin = false;
      });
      return;
    }

  @override
  Widget build(BuildContext context) {
    return globals.loadingAutologin ? Scaffold() : Scaffold(body: globals.isLoggedIn ? Dashboard() : LandingPage());
  }
}