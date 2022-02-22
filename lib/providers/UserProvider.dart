import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:picoffee/app_config/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:picoffee/components/service.dart';

class UserProvider with ChangeNotifier {
  String? id;
  String? name;
  String? email;
  String? password;
  String? deviceName;
  String? phone;
  //String gender = ' ';
  String? gender;
  String imageUrl = '';
  bool showProgressBar = false;

  var token;
  var logged_in;

  final Map<String, String> profile= {
    "id": "",
    "gender": "",
    "fcmToken": ""
  };

  Future<dynamic> signUp(name, email, password,) async{
    var url = api.ApiUrl + "users/store";

    var response = await http.post(Uri.parse(url), body: {
      'name': name.text.toString(),
      'email': email.text.toString(),
      'password': password.text.toString(),
      'device_name': deviceName,
      'gender': gender,
      'fcm_token': profile['fcmToken'].toString()
    });

    if(response.ok){
      //print("response = ${response.body}");
      Map<String, dynamic> data = new Map<String, dynamic>.from(json.decode(response.body));

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('id', data['user']['id'].toString());
      await prefs.setString('name', data['user']['name']);
      await prefs.setString('email', data['user']['email']);
      //no image in sign up
      if(data['user']['image'] != null){
        var _imageUrl = AppConfig.profilePicturesUrl + data['user']['image']['picture_name'].toString();
        await prefs.setString('image', _imageUrl);
      }
      else{
        await prefs.setString('image', "");
      }
      await prefs.setString('profileId', data['user']['profile']['id'].toString());
      await prefs.setString('profileGender', data['user']['profile']['gender'].toString());
      await prefs.setString('profileFcmToken', data['user']['profile']['fcm_token'].toString());
      await prefs.setString('token', data['token'].toString());
      await prefs.setBool('logged_in', true);

      await getUserInfo();
      notifyListeners();
    }
    else {
      BotToast.showSimpleNotification(title: "Register Was Unsuccessful");
      return false;
    }

  }

  Future<dynamic> signIn(email, password,) async {
    var url = api.ApiUrl + "users/login";

    var response = await http.post(Uri.parse(url), body: {
      'email': email.text,
      'password': password.text,
      'device_name': deviceName,
    });

    if(response.ok){
      //print("response = ${response.body}");
      Map<String, dynamic> data = new Map<String, dynamic>.from(json.decode(response.body));

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('id', data['user']['id'].toString());
      await prefs.setString('name', data['user']['name'].toString());
      await prefs.setString('email', data['user']['email'].toString());
      if(data['user']['image'] != null){
        var _imageUrl = AppConfig.profilePicturesUrl + data['user']['image']['picture_name'].toString();
        await prefs.setString('image', _imageUrl);
      }
      else{
        await prefs.setString('image', "");
      }
      await prefs.setString('profileId', data['user']['profile']['id'].toString());
      await prefs.setString('profileGender', data['user']['profile']['gender'].toString());
      await prefs.setString('profileFcmToken', data['user']['profile']['fcm_token'].toString());
      await prefs.setString('token', data['token'].toString());
      await prefs.setBool('logged_in', true);

      await getUserInfo();
      notifyListeners();

      return true;
    }
    else {
     BotToast.showSimpleNotification(title: "Login Was Unsuccessful");
     return false;
    }
  }

  Future<dynamic> getUserInfo() async{
    print("getting user info");
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

  Future<dynamic> updateUserInfo(dynamic email, dynamic name, dynamic gender, dynamic image) async{
    this.showProgressBar = !(this.showProgressBar);
    notifyListeners();
    var url = api.ApiUrl + "v1/users/update/${this.id}";

    var request = http.MultipartRequest("POST", Uri.parse(url));
    if(image != null) {
      var multipartAvatar = await http.MultipartFile.fromPath("image", image.path);
      request.files.add(multipartAvatar);
    }

    request.fields.addAll(
      {
        'email': email.toString(),
        'name': name.toString(),
        'gender': gender.toString(),
      }
    );
    request.headers['Authorization'] = "Bearer ${this.token.toString()}";

    StreamedResponse response = await request.send();
    //(response.statusCode == 200) ? print("profile was updated") : print("profile was not updated");
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);

    await Future.delayed(Duration(milliseconds: 1000));

    if(response.ok){
      //print("response = $responseString");
      Map<String, dynamic> data = new Map<String, dynamic>.from(json.decode(responseString));

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('id', data['data']['id'].toString());
      await prefs.setString('name', data['data']['attributes']['name'].toString());
      await prefs.setString('email', data['data']['attributes']['email'].toString());
      if(data['data']['attributes']['image'] != null){
        var _imageUrl = AppConfig.profilePicturesUrl + data['data']['attributes']['image']['picture_name'].toString();
        await prefs.setString('image', _imageUrl);
      }
      else{
        await prefs.setString('image', "");
      }
      await prefs.setString('profileId', data['data']['attributes']['profile']['id'].toString());
      await prefs.setString('profileGender', data['data']['attributes']['profile']['gender'].toString());
      await prefs.setString('profileFcmToken', data['data']['attributes']['profile']['fcm_token'].toString());

      await getUserInfo();
      this.showProgressBar = !(this.showProgressBar);
      notifyListeners();

      return true;
    }
    else {
      this.showProgressBar = !(this.showProgressBar);
      notifyListeners();
      BotToast.showSimpleNotification(title: "Login Was Unsuccessful");
      return false;
    }
  }
}
