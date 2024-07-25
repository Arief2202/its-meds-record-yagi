// ignore_for_file: sort_child_properties_last, prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_print, use_key_in_widget_constructors, use_build_context_synchronously, prefer_interpolation_to_compose_strings, deprecated_member_use, unnecessary_this, unused_local_variable, annotate_overrides, prefer_final_fields, non_constant_identifier_names, avoid_unnecessary_containers, sized_box_for_whitespace, unused_import, unused_field

import 'dart:developer';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yagi/globals.dart' as globals;
import 'dart:async';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart'; 
import 'package:readsms/readsms.dart';
import 'dart:convert';
// import 'dataModel.dart';
// import 'history.dart';

class Dashboard extends StatefulWidget {
  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  List<globals.registerModel> registerModelHistory = [];
  List<globals.permissionModel> permissionModelHistory = [];
  TextStyle titleStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500
  );
  TextStyle valueStyle = TextStyle(
    fontSize: 16,
  );
  final _plugin = Readsms();
  String sms = 'no sms received';
  String sender = 'no sms received';
  String time = 'no sms received';
  
  List<TextEditingController> _data = [TextEditingController()];
  Timer? timer;
  int _selectedIndex = 0;
  bool status = false;
  bool openRead = false;
  String incomingJsonData = "";
  String modeIncomingData = "";
  void initState() {
    super.initState();
    smsPermissionRequest();
    readSMS();
    // timer = Timer.periodic(Duration(milliseconds: 1000), (Timer t) => readSMS());     
  }
  void smsPermissionRequest() async{    
    var status = await Permission.sms.status;
    if (!status.isGranted) {
      await Permission.sms.request();
    }
  }
  void readSMS() async {
    var status = await Permission.sms.status;
    if (!status.isGranted) {
      await Permission.sms.request();
    }
    _plugin.read();
    _plugin.smsStream.listen((event) {
      String text = event.body;
      final val = text.split("\n");
      val.removeWhere((item) => item.length <= 0);
      
      for(int a = 0; a<val.length; a++){
        if(val[a] == "Register" || val[a] == "Permission"){
          setState(() {
            openRead = true; //start mode baca
            modeIncomingData = val[a];
          });
        }
        else if(val[a] == "end"){
          log(incomingJsonData);
          showPopUp(modeIncomingData, incomingJsonData);
  
          setState(() {
            openRead = false; //stop mode baca
            incomingJsonData = "";
          });
        }
        else if(openRead == true){
          setState(() {
            incomingJsonData = incomingJsonData + val[a];
          });
        }      
        // print(val[a]);
      }
      setState(() {
        sms = event.body;
        sender = event.sender;
        time = event.timeReceived.toString();
      });
    });
  }

  void showPopUp(String mode, String incomingJson) async{
      if(mode == "Register"){
        globals.registerModel register = globals.registerModel.fromJson(jsonDecode(incomingJson) as Map<String, dynamic>);
        Alert(
          context: context,
          type: AlertType.info,
          title: "Register",
          desc: "Apakah dibawah ini benar data anda ?\nName : ${register.name}\nHospital : ${register.hospital}\nAddress : ${register.address}",
          style: AlertStyle(
            descStyle: TextStyle(
              fontSize: 12
            )
          ),

          buttons: [
            DialogButton(
              child: Text(
                "No",
                style: TextStyle(color: Colors.white, fontSize: 20 ),
              ),
              onPressed: () async{
                setState(() {
                  register.correct = 0;
                  registerModelHistory.add(register);
                });
                var url = Uri.parse("https://si.its.ac.id/labs/ikti/emr_backend/response.php?par={\"code\":\"0\")");  
                try {
                  final response = await http.get(url).timeout(
                    const Duration(seconds: 1),
                    onTimeout: () {
                      return http.Response('Error', 408);
                    },
                  );
                } on Exception catch (_) {}
               
                Navigator.pop(context);
              },
            ),
            DialogButton(
              child: Text(
                "Yes",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () async{
                setState(() {
                  register.correct = 1;                  
                  registerModelHistory.add(register);
                });
                var url = Uri.parse("https://si.its.ac.id/labs/ikti/emr_backend/response.php?par={\"code\":\"10\", \"algorithm\":\"aes-cbc\", \"key\":\"${globals.key}\")");  
                try {
                  final response = await http.get(url).timeout(
                    const Duration(seconds: 1),
                    onTimeout: () {
                      return http.Response('Error', 408);
                    },
                  );
                } on Exception catch (_) {}
                Navigator.pop(context);
              },
            ),
          ],
        ).show();
      }
      if(mode == "Permission"){
        print(mode);
        globals.permissionModel permission = globals.permissionModel.fromJson(jsonDecode(incomingJson) as Map<String, dynamic>);
        Alert(
          context: context,
          type: AlertType.info,
          title: "Request Permission",
          desc: "Apakah anda ingin meminjamkan data anda ?\nRumah Sakit : ${permission.hospital}\nDokter : ${permission.doctor}\nTujuan : ${permission.purpose}",
          style: AlertStyle(
            descStyle: TextStyle(
              fontSize: 12
            )
          ),

          buttons: [
            DialogButton(
              child: Text(
                "No",
                style: TextStyle(color: Colors.white, fontSize: 20 ),
              ),
              onPressed: () async{
                setState(() {
                  permission.accept = 0;
                  permissionModelHistory.add(permission);
                });
                var url = Uri.parse("https://si.its.ac.id/labs/ikti/emr_backend/response.php?par={\"code\":\"0\")");  
                try {
                  final response = await http.get(url).timeout(
                    const Duration(seconds: 1),
                    onTimeout: () {
                      return http.Response('Error', 408);
                    },
                  );
                } on Exception catch (_) {}
               
                Navigator.pop(context);
              },
            ),
            DialogButton(
              child: Text(
                "Yes",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () async{
                setState(() {
                  permission.accept = 1;
                  permissionModelHistory.add(permission);
                });
                var url = Uri.parse("https://si.its.ac.id/labs/ikti/emr_backend/response.php?par={\"code\":\"20\", \"key\":\"${globals.key}\", \"session_key\":\"${permission.key}\", \"id\":\"${permission.id}\"}");  
                try {
                  final response = await http.get(url).timeout(
                    const Duration(seconds: 1),
                    onTimeout: () {
                      return http.Response('Error', 408);
                    },
                  );
                } on Exception catch (_) {}
                Navigator.pop(context);
              },
            ),
          ],
        ).show();
      }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
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
    status = await Permission.sms.status;
    if (!status.isGranted) {
      await Permission.sms.request();
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
              IconButton(
                  icon: const Icon(Icons.logout,
                      color: Colors.white, size: 20.0),
                  onPressed: () async {
                    Alert(
                      context: context,
                      type: AlertType.warning,
                      desc: "Apakah anda ingin logout ?",
                      buttons: [
                        DialogButton(
                            child: Text(
                              "Tidak",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () async {
                              Navigator.pop(context);
                            }
                        ),
                        DialogButton(
                            child: Text(
                              "Ya",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () async {                              
                              final prefs = await SharedPreferences.getInstance();
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
                              Phoenix.rebirth(context);
                            }
                        )
                      ],
                    ).show();

                    //================================ END ALERT UNTUK SETTING API ========================================
                  })
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
                icon: Icon(Icons.app_registration),
                label: 'Register',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.lock),
                label: 'Permission',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Setting',
              ),
            ],
          ),
          body: _selectedIndex == 0 ?
          Container(
            margin: new EdgeInsets.only(left: 20.0, right: 20.0, top: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: [
                    Image.asset(
                      'assets/img/logo.png',
                      width: MediaQuery.of(context).size.width/2,
                    ),
                  ],
                )
              ],
            ),
          )
          : _selectedIndex == 1 ? 
          Container(
            margin: new EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
            child: SingleChildScrollView(
              child: 
            Column(children: [

             if(registerModelHistory.length>0) for(int a=registerModelHistory.length-1; a>=0; a--) 
             Container(
              width: MediaQuery.of(context).size.width,
              child: Card(          
                color: registerModelHistory![a].correct == 1 ? Colors.green : Colors.red,
                  child: Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top:10, bottom: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [                        
                      Text(style: titleStyle, "ID"),
                      Text(style: valueStyle, "${registerModelHistory[a].id}"),
                      Text(style: titleStyle, "Name"),
                      Text(style: valueStyle, "${registerModelHistory[a].name}"),
                      Text(style: titleStyle, "Hospital"),
                      Text(style: valueStyle, "${registerModelHistory[a].hospital}"),
                      Text(style: titleStyle, "Address"),
                      Text(style: valueStyle, "${registerModelHistory[a].address}"),
                      Text(style: titleStyle, "Hospital ID"),
                      Text(style: valueStyle, "${registerModelHistory[a].hospital_id}"),
                    ],
                  ),
                ),
              ),
             ),

            ],),
            )
            
          ) 
          : _selectedIndex == 2 ? 
          Container(
            margin: new EdgeInsets.only(left: 20.0, right: 20.0, top: 20),
            child: SingleChildScrollView(
              child: 
            Column(children: [

             if(permissionModelHistory.length>0)  for(int a=permissionModelHistory.length-1; a>=0; a--) 
             Container(
              width: MediaQuery.of(context).size.width,
              child: Card(          
                color: permissionModelHistory![a].accept == 1 ? Colors.green : Colors.red,
                  child: Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top:10, bottom: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [                        
                      Text(style: titleStyle, "ID"),
                      Text(style: valueStyle, "${permissionModelHistory[a].id}"),
                      Text(style: titleStyle, "Hospital ID"),
                      Text(style: valueStyle, "${permissionModelHistory[a].hospital_id}"),
                      Text(style: titleStyle, "Hospital"),
                      Text(style: valueStyle, "${permissionModelHistory[a].hospital}"),
                      Text(style: titleStyle, "Doctor"),
                      Text(style: valueStyle, "${permissionModelHistory[a].doctor}"),
                      Text(style: titleStyle, "Purpose"),
                      Text(style: valueStyle, "${permissionModelHistory[a].purpose}"),
                      Text(style: titleStyle, "Key"),
                      Text(style: valueStyle, "${permissionModelHistory[a].key}"),
                      Text(style: titleStyle, "Encripted Session Key"),
                      Text(style: valueStyle, "${permissionModelHistory[a].encrypted_key}"),
                    ],
                  ),
                ),
              ),
             ),

            ],),
            )
            
          ) 
          :
          Container(
            margin: new EdgeInsets.only(left: 20.0, right: 20.0, top: 50),
            child:
            Column(
              children: [
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: [
                        Image.asset(
                          'assets/img/logo.png',
                          width: MediaQuery.of(context).size.width/2,
                        ),
                        SizedBox(height: MediaQuery.of(context).size.width / 15),
                      ],
                    )
                  ],
                ),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Name : ${globals.name}"),
                        Text("NIK : ${globals.nik}"),
                        Text("Phone : ${globals.phone}"),
                        Text("Email : ${globals.email}"),
                        SizedBox(height: MediaQuery.of(context).size.width / 15),
                        Text("Key : ${globals.key}"),
                        Text("IV : ${globals.iv}"),
                      ],
                    )
                  ],
                ),

                SizedBox(height: 12),
                DialogButton(
                  child: Text(
                    "Export",
                    style: TextStyle(color: Colors.white, fontSize: 20 ),
                  ),
                  onPressed: () async{
                    var status = await Permission.storage.status;
                    if (!status.isGranted) {
                      await Permission.storage.request();
                    }
                    
                    final Export = "{\"key\":\"${globals.key}\",\"iv\":\"${globals.iv}\",\"padding\":\"PKCS7\",\"encrypted\":\"${globals.encrypted}\"}";
                    _write(Export);
                    // Navigator.pop(context);
                  },
                ),
              ],
            ) 
          )
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