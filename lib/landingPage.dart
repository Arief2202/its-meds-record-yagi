// ignore_for_file: file_names, camel_case_types, library_private_types_in_public_api, prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:yagi/loginPage.dart';
import 'package:yagi/registerPage.dart';

class LandingPage extends StatefulWidget {
  LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  // final List<LandingPage> doneTourismPlaceList = [];
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/img/logo.png',
                width: MediaQuery.of(context).size.width/2,
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 20),
                width: double.infinity,
                height: MediaQuery.of(context).size.width / 10,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return LoginPage();
                      }),
                    );
                  },
                  child: Text(
                    "Log in",
                    style: TextStyle(fontSize: MediaQuery.of(context).size.width / 20),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.width / 15),
              Container(
                margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 20),
                width: double.infinity,
                height: MediaQuery.of(context).size.width / 10,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return RegisterPage();
                      }),
                    );
                  },
                  child: Text(
                    "Sign Up",
                    style: TextStyle(fontSize: MediaQuery.of(context).size.width / 20),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.width / 15),
            ],
          ),
        ),
      ],
    );
  }
}