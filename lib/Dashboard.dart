// ignore_for_file: sort_child_properties_last, prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_print, use_key_in_widget_constructors, use_build_context_synchronously, prefer_interpolation_to_compose_strings, deprecated_member_use, unnecessary_this, unused_local_variable, annotate_overrides, prefer_final_fields, non_constant_identifier_names, avoid_unnecessary_containers, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yagi/globals.dart' as globals;
import 'dart:async';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'dataModel.dart';
// import 'history.dart';

class Dashboard extends StatefulWidget {
  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  List<TextEditingController> _data = [TextEditingController()];
  Timer? timer;
  int _selectedIndex = 0;
  bool status = false;
  
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: 1000), (Timer t) => readSMS());
        
  }
  void readSMS() async {

    // var url = Uri.parse("http://${globals.endpoint}/api.php");
    // try {
    //   final response = await http.get(url).timeout(
    //     const Duration(seconds: 1),
    //     onTimeout: () {
    //       return http.Response('Error', 408);
    //     },
    //   );
    //   if (response.statusCode == 200) {
    //     var respon = Json.tryDecode(response.body);
    //     if (this.mounted) {
    //       setState(() {
    //         currentData = FromAPI.fromJson(Json.tryDecode(response.body));
    //         _currentSliderValue = double.parse(
    //             currentData.kecerahan_lampu![_selectedIndex].kecerahan_lampu);
    //       });
    //     }
    //   }
    // } on Exception catch (_) {}
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        timer?.cancel();
        Navigator.pop(context);
        return Future.value(false);
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 0, 44, 138),
            // leading: IconButton(
            //   icon: Icon(Icons.arrow_back),
            //   onPressed: () => Phoenix.rebirth(context),
            // ),
            title: Text(
              "Meds Record",
              style: TextStyle(color: Colors.white),
            ),
            actions: <Widget>[
              // IconButton(
              //     icon: const Icon(Icons.settings,
              //         color: Colors.white, size: 20.0),
              //     onPressed: () async {
              //       //================================ ALERT UNTUK SETTING API ========================================
              //       Alert(
              //         context: context,
              //         // type: AlertType.info,
              //         desc: "Setting API",
              //         content: Column(
              //           children: <Widget>[
              //             SizedBox(
              //                 height: MediaQuery.of(context).size.width / 15),
              //             TextField(
              //               decoration: InputDecoration(
              //                 border: OutlineInputBorder(),
              //                 labelText: 'IP Endpoint',
              //                 labelStyle: TextStyle(fontSize: 20),
              //               ),
              //               controller: _data[0],
              //             ),
              //           ],
              //         ),
              //         buttons: [
              //           DialogButton(
              //               child: Text(
              //                 "Save",
              //                 style:
              //                     TextStyle(color: Colors.white, fontSize: 20),
              //               ),
              //               onPressed: () async {
              //                 if (_data[0].text.isEmpty) {
              //                   status = false;
              //                   Alert(
              //                     context: context,
              //                     type: AlertType.error,
              //                     title: "Value Cannot be Empty!",
              //                     buttons: [
              //                       DialogButton(
              //                         child: Text(
              //                           "OK",
              //                           style: TextStyle(
              //                               color: Colors.white, fontSize: 20),
              //                         ),
              //                         onPressed: () => Navigator.pop(context),
              //                       )
              //                     ],
              //                   ).show();
              //                 } else {
              //                   var url = Uri.parse('http://' +
              //                       _data[0].text +
              //                       '/checkConnection.php');
              //                   try {
              //                     final response = await http.get(url).timeout(
              //                       const Duration(
              //                           seconds: globals.httpTimeout),
              //                       onTimeout: () {
              //                         // Time has run out, do what you wanted to do.
              //                         return http.Response('Error',
              //                             408); // Request Timeout response status code
              //                       },
              //                     );
              //                     // context.loaderOverlay.hide();
              //                     if (response.statusCode == 200) {
              //                       Alert(
              //                         context: context,
              //                         type: AlertType.success,
              //                         title: "Connection OK",
              //                         buttons: [
              //                           DialogButton(
              //                               child: Text(
              //                                 "OK",
              //                                 style: TextStyle(
              //                                     color: Colors.white,
              //                                     fontSize: 20),
              //                               ),
              //                               onPressed: () async {
              //                                 final SharedPreferences prefs =
              //                                     await SharedPreferences
              //                                         .getInstance();
              //                                 setState(() {
              //                                   globals.endpoint =
              //                                       _data[0].text;
              //                                   prefs.setString(
              //                                       "endpoint", _data[0].text);
              //                                 });
              //                                 Navigator.pop(context);
              //                                 Navigator.pop(context);
              //                               })
              //                         ],
              //                       ).show();
              //                     } else {
              //                       Alert(
              //                         context: context,
              //                         type: AlertType.error,
              //                         title: "Connection Failed!",
              //                         desc: "Please check Endpoint IP",
              //                         buttons: [
              //                           DialogButton(
              //                             child: Text(
              //                               "OK",
              //                               style: TextStyle(
              //                                   color: Colors.white,
              //                                   fontSize: 20),
              //                             ),
              //                             onPressed: () =>
              //                                 Navigator.pop(context),
              //                           )
              //                         ],
              //                       ).show();
              //                     }
              //                   } on Exception catch (_) {
              //                     Alert(
              //                       context: context,
              //                       type: AlertType.error,
              //                       title: "Connection Failed!",
              //                       desc: "Please check Endpoint IP",
              //                       buttons: [
              //                         DialogButton(
              //                           child: Text(
              //                             "OK",
              //                             style: TextStyle(
              //                                 color: Colors.white,
              //                                 fontSize: 20),
              //                           ),
              //                           onPressed: () => Navigator.pop(context),
              //                         )
              //                       ],
              //                     ).show();
              //                     // rethrow;
              //                   }
              //                 }
              //               }),
              //         ],
              //       ).show();

              //       //================================ END ALERT UNTUK SETTING API ========================================
              //     })
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            showUnselectedLabels: true,
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.amber[800],
            unselectedItemColor: Colors.black,
            onTap: _onItemTapped,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Setting',
              ),
            ],
          ),
          body: Container(
            child: Text("Home"),
          ),
        ),
    );
  }

  Widget _buildTile(Widget child, {Function()? onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        child: InkWell(
            // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null
                ? () => onTap()
                : () {
                    print('Not set yet');
                  },
            child: child));
  }
}