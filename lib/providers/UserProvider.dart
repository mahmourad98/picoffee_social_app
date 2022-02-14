import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verbose_share_world/components/service.dart';

class User with ChangeNotifier {
  String? name;
  String? email;
  String? password;
  String? devicename;
  String gender= '';
  var fcmtoken;

  signUp(name, email, password,) async {

    var url = api.ApiUrl + "users/store";

    var response = await http.post(Uri.parse(url), body: {
      'name': name.text,
      'email': email.text,
      'password': password.text,
      'device_name': devicename,
      'gender': gender,
      'fcm_token': fcmtoken.toString()
    });

    Map<String, dynamic> data = new Map<String, dynamic>.from(json.decode(response.body));

    SharedPreferences prefs = await SharedPreferences.getInstance();


    prefs.setString('name',data['user']['name']);
    prefs.setString('email',data['user']['email']);
    prefs.setString('token',data['token']);
    prefs.setBool('logged_in', true);

    notifyListeners();
  }


  signIn(email, password) async {

    var url = api.ApiUrl + "users/login";

    var response = await http.post(Uri.parse(url), body: {
      'email': email.text,
      'password': password.text,
      'device_name': devicename,
    });

    Map<String, dynamic> data = new Map<String, dynamic>.from(json.decode(response.body));


    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('name',data['user']['name']);
    prefs.setString('email',data['user']['email']);
    prefs.setString('token',data['token']);
    prefs.setBool('logged_in', true);

    notifyListeners();
  }
}
