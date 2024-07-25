library globals;

import 'dart:ffi';

bool loadingAutologin = false;
bool isLoggedIn = false;
String api = "http://onparking.eepis.tech/api";

String name = "";
String nik = "";
String phone = "";
String email = "";
String key = "";
String iv = "";
String encrypted = "";

const int httpTimeout = 1;

class registerModel {
  registerModel({
    required this.id,
    required this.name,
    required this.hospital,
    required this.address,
    required this.hospital_id,
    this.correct
  });
  
  int id;
  String name;
  String hospital;
  String address;
  int hospital_id;
  int? correct;
  
  factory registerModel.fromJson(Map<String, dynamic> json) => registerModel(
    id: json["id"],
    name: json["name"],
    hospital: json["hospital"],
    address: json["address"],
    hospital_id: json["hospital_id"],
  );
}


class permissionModel {
  permissionModel({
    required this.id,
    required this.hospital_id,
    required this.hospital,
    required this.doctor,
    required this.purpose,
    required this.key,
    required this.encrypted_key,
    this.accept
  });
  
  int id;
  int hospital_id;
  String hospital;
  String doctor;
  String purpose;
  String key;
  String encrypted_key;
  int? accept;
  
  factory permissionModel.fromJson(Map<String, dynamic> json) => permissionModel(
    id: json["id"],
    hospital_id: json["hospital_id"],
    hospital: json["hospital"],
    doctor: json["doctor"],
    purpose: json["purpose"],
    key: json["key"],
    encrypted_key: json["encrypted_key"],
  );
}