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
  String? imageUrl = '';
  var token;
  var logged_in;
  var fcmtoken;

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
      'fcm_token': fcmtoken.toString()
    });

    Map<String, dynamic> data =
        new Map<String, dynamic>.from(json.decode(response.body));

    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('id', data['user']['id'].toString());
    prefs.setString('name', data['user']['name']);
    prefs.setString('email', data['user']['email']);
    prefs.setString('gender', data['user']['profile']['gender']);
    //prefs.setString('token', data['token']);
    //prefs.setBool('logged_in', true);

    prefs.setString('userId', data['user']['id'].toString());
    prefs.setString('userName', data['user']['name'].toString());
    prefs.setString('userEmail', data['user']['email'].toString());
    prefs.setString('userImage', data['user']['image'].toString());
    prefs.setString('userProfileId', data['user']['profile']['id'].toString());
    prefs.setString('userProfileGender', data['user']['profile']['gender'].toString());
    prefs.setString('userProfileFcmToken', data['user']['profile']['fcm_token'].toString());
    prefs.setString('token', data['token'].toString());
    prefs.setBool('logged_in', true);

    getUserInfo();

    notifyListeners();
  }

  signIn(email, password) async {
    var url = api.ApiUrl + "users/login";

    var response = await http.post(Uri.parse(url), body: {
      'email': email.text,
      'password': password.text,
      'device_name': deviceName,
    });

    Map<String, dynamic> data =
        new Map<String, dynamic>.from(json.decode(response.body));

    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('id', data['user']['id'].toString());
    prefs.setString('name', data['user']['name']);
    prefs.setString('email', data['user']['email']);
    //prefs.setString('token', data['token']);
    //prefs.setBool('logged_in', true);

    prefs.setString('userId', data['user']['id'].toString());
    prefs.setString('userName', data['user']['name'].toString());
    prefs.setString('userEmail', data['user']['email'].toString());
    prefs.setString('userImage', data['user']['image'].toString());
    prefs.setString('userProfileId', data['user']['profile']['id'].toString());
    prefs.setString('userProfileGender', data['user']['profile']['gender'].toString());
    prefs.setString('userProfileFcmToken', data['user']['profile']['fcm_token'].toString());
    prefs.setString('token', data['token'].toString());
    prefs.setBool('logged_in', true);

    getUserInfo();

    notifyListeners();
  }

  dynamic getUserInfo() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.id = prefs.getString('userId')!;
    this.name = prefs.getString('userName')!;
    this.email = prefs.getString('userEmail')!;
    this.imageUrl = prefs.getString('userImage')!;
    this.token = prefs.getString('token')!;
    this.logged_in = prefs.getBool('logged_in')!;
    this.profile['id'] = prefs.getString('userProfileId')!;
    this.profile['gender'] = prefs.getString('userProfileGender')!;
    this.profile['fcmToken'] = prefs.getString('userProfileFcmToken')!;

    print("id: ${this.id}");
    print("name: ${this.name}");
    print("email: ${this.email}");
    print("imageUrl: ${this.imageUrl}");
    print("token: ${this.token}");
    print("logged_in: ${this.logged_in}");
    print("profile id: ${this.profile['id']}");
    print("profile gender: ${this.profile['gender']}");
    print("profile fcm token: ${this.profile['fcmToken']}");

    notifyListeners();
  }

  Future<dynamic> updateUserInfo(dynamic email, dynamic name, dynamic gender) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    this.id = prefs.getString('userId')!;
    this.token = prefs.getString('token')!;
    var url = api.ApiUrl + "v1/users/update/${this.id}";
    print(url);
    //print(name);
    //print(email);
    //print(gender);

    var response = await http.post(
      Uri.parse(url),
      body: {
        'email': email.toString(),
        'name': name.toString(),
        'gender': gender.toString()
      },
      headers: <String, String>{
        'Authorization': 'Bearer ${this.token}',
      }
    ).then(
      (_) async{
        var _url = api.ApiUrl + "v1/users/${this.id}";
        var _response = await http.get(
          Uri.parse(_url),
          headers: <String, String>{
            'Authorization': 'Bearer ${this.token}',
          }
        );
        Map<String, dynamic> data =
        new Map<String, dynamic>.from(json.decode(_response.body));

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('userId', data['attributes']['id'].toString());
        prefs.setString('userName', data['attributes']['name'].toString());
        prefs.setString('userEmail', data['attributes']['email'].toString());
        prefs.setString('userImage', data['attributes']['image'].toString());
        prefs.setString('userProfileId', data['attributes']['profile']['id'].toString());
        prefs.setString('userProfileGender', data['attributes']['profile']['gender'].toString());
        prefs.setString('userProfileFcmToken', data['attributes']['profile']['fcm_token'].toString());
      }
    );
    Map<String, dynamic> data =
    new Map<String, dynamic>.from(json.decode(response.body));

    getUserInfo();

    notifyListeners();
  }
}
