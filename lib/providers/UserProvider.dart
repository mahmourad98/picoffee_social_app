import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:picoffee/components/service.dart';

class UserProvider with ChangeNotifier {
  String? id;
  String? name;
  String? email;
  String? password;
  String? deviceName;
  String? phone;
  String gender = '';
  String imageUrl = '';
  var token;
  var logged_in;
  var fcmToken;

  final Map<String, String> profile= {
    "id": "",
    "gender": "",
    "fcmToken": ""
  };

  signUp(
    name,
    email,
    password,
  ) async {
    var url = api.ApiUrl + "users/store";

    var response = await http.post(Uri.parse(url), body: {
      'name': name.text,
      'email': email.text,
      'password': password.text,
      'device_name': deviceName,
      'gender': gender,
      'fcm_token': fcmToken.toString()
    });

    Map<String, dynamic> data = new Map<String, dynamic>.from(json.decode(response.body));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('id', data['user']['id'].toString());
    await prefs.setString('name', data['user']['name']);
    await prefs.setString('email', data['user']['email']);
    await prefs.setString('image', data['user']['image'].toString());
    await prefs.setString('profileId', data['user']['profile']['id'].toString());
    await prefs.setString('profileGender', data['user']['profile']['gender'].toString());
    await prefs.setString('profileFcmToken', data['user']['profile']['fcm_token'].toString());
    await prefs.setString('token', data['token']);
    await prefs.setBool('logged_in', true);

    await getUserInfo();

    notifyListeners();
  }

  signIn(email, password) async {
    var url = api.ApiUrl + "users/login";

    var response = await http.post(Uri.parse(url), body: {
      'email': email.text,
      'password': password.text,
      'device_name': deviceName,
    });

    Map<String, dynamic> data = new Map<String, dynamic>.from(json.decode(response.body));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('id', data['user']['id'].toString());
    await prefs.setString('name', data['user']['name']);
    await prefs.setString('email', data['user']['email']);
    await prefs.setString('image', data['user']['image'].toString());
    await prefs.setString('profileId', data['user']['profile']['id'].toString());
    await prefs.setString('profileGender', data['user']['profile']['gender'].toString());
    await prefs.setString('profileFcmToken', data['user']['profile']['fcm_token'].toString());
    await prefs.setString('token', data['token'].toString());
    await prefs.setBool('logged_in', true);

    await getUserInfo();

    notifyListeners();
  }

  dynamic getUserInfo() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.id = prefs.getString('id')!;
    this.name = prefs.getString('name')!;
    this.email = prefs.getString('email')!;
    this.imageUrl = prefs.getString('image')!;
    this.token = prefs.getString('token')!;
    this.logged_in = prefs.getBool('logged_in')!;
    this.profile['id'] = prefs.getString('profileId')!;
    this.profile['gender'] = prefs.getString('profileGender')!;
    this.profile['fcmToken'] = prefs.getString('profileFcmToken')!;

    //print("id: ${this.id}");
    //print("name: ${this.name}");
    //print("email: ${this.email}");
    //print("imageUrl: ${this.imageUrl}");
    //print("token: ${this.token}");
    //print("logged_in: ${this.logged_in}");
    //print("profile id: ${this.profile['id']}");
    //print("profile gender: ${this.profile['gender']}");
    //print("profile fcm token: ${this.profile['fcmToken']}");

    notifyListeners();
  }

  Future<dynamic> updateUserInfo(dynamic email, dynamic name, dynamic gender, dynamic image) async{
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // this.id = prefs.getString('userId')!;
    // this.token = prefs.getString('token')!;
    var url = api.ApiUrl + "v1/users/update/${this.id}";
    var body = <String, String>{
      'email': email.toString(),
      'name': name.toString(),
      'gender': gender.toString(),
    };
    //print(url);
    //print(name);
    //print(email);
    //print("gender to update: $gender");
    if(image != null){
      var imageBytes = image.readAsBytesSync();
      var imageEncoded = base64Encode(imageBytes);
      body['image'] = imageEncoded.toString();
      //print("we have Image");
    }

    var response = await http.post(
      Uri.parse(url),
      body: body,
      headers: <String, String>{
        'Authorization': 'Bearer ${this.token}',
      }
    );
    //print("response has come");



    Map<String, dynamic> data = new Map<String, dynamic>.from(json.decode(response.body)['data']);
    print(data);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('id', data['id'].toString());
    await prefs.setString('name', data['attributes']['name'].toString());
    await prefs.setString('email', data['attributes']['email'].toString());
    await prefs.setString('image', data['attributes']['image'].toString());
    await prefs.setString('profileId', data['attributes']['profile']['id'].toString());
    await prefs.setString('profileGender', data['attributes']['profile']['gender'].toString());
    await prefs.setString('profileFcmToken', data['attributes']['profile']['fcm_token'].toString());

    await getUserInfo();
    notifyListeners();
  }
}
