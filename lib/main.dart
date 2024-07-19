import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yagi/Dashboard.dart';
import 'package:yagi/landingPage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:yagi/globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert' show jsonDecode;
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(
    MyApp(),
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
    
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? user_email = prefs.getString('user_email');
    final String? user_password = prefs.getString('user_password');

    if (user_email != null && user_password != null) {
      setState(() {
        globals.loadingAutologin = true;
      });
      var url = Uri.parse(globals.api + '/loginEncrypted');
      final response = await http.post(url, body: {'email': user_email, 'password': user_password});

      if (response.statusCode == 200) {
        Map<String, dynamic> parsed = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_id', (parsed['data']['user']['id']).toString());
        await prefs.setString('user_role', parsed['data']['user']['role']);
        await prefs.setString('user_name', parsed['data']['user']['name']);
        await prefs.setString('user_email', parsed['data']['user']['email']);
        await prefs.setString('user_password', parsed['data']['user']['password']);
        await prefs.setString('user_card_id', parsed['data']['user']['card_id']);
        setState(() {
          // globals.user_id = (parsed['data']['user']['id']).toString();
          // globals.user_role = parsed['data']['user']['role'];
          // globals.user_name = parsed['data']['user']['name'];
          // globals.user_email = parsed['data']['user']['email'];
          // globals.user_password = parsed['data']['user']['password'];
          // globals.user_card_id = parsed['data']['user']['card_id'];
          globals.isLoggedIn = true;
        });
      } else {
        await prefs.remove('user_id');
        await prefs.remove('user_role');
        await prefs.remove('user_name');
        await prefs.remove('user_email');
        await prefs.remove('user_password');
        await prefs.remove('user_card_id');
        setState(() {
          // globals.user_id = "";
          // globals.user_name = "";
          // globals.user_email = "";
          // globals.user_password = "";
          // globals.user_card_id = "";
          globals.isLoggedIn = false;
        });
        Alert(
          context: context,
          type: AlertType.info,
          title: "Login Failed!",
          desc: "Please relogin",
          buttons: [
            DialogButton(
              child: Text(
                "OK",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ).show();
      }
      setState(() {
        globals.loadingAutologin = false;
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return globals.loadingAutologin ? Scaffold() : Scaffold(body: globals.isLoggedIn ? Dashboard() : LandingPage());
  }
}