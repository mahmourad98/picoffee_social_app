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
  String gender = ' ';
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
    await prefs.setString('image', AppConfig.profilePicturesUrl + data['user']['image']['picture_name'].toString());
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
    print("image url: ${this.imageUrl}");
    this.token = prefs.getString('token')!;
    this.logged_in = prefs.getBool('logged_in')!;
    this.profile['id'] = prefs.getString('profileId')!;
    this.profile['gender'] = prefs.getString('profileGender')!;
    this.profile['fcmToken'] = prefs.getString('profileFcmToken')!;

    //print("id: ${this.id}");
    //print("name: ${this.name}");
    //print("email: ${this.email}");
    //print("imageUrl: ${this.imageUrl}");
    print("token: ${this.token}");
    print("logged_in: ${this.logged_in}");
    //print("profile id: ${this.profile['id']}");
    //print("profile gender: ${this.profile['gender']}");
    //print("profile fcm token: ${this.profile['fcmToken']}");

    notifyListeners();
  }

  Future<dynamic> updateUserInfo(dynamic email, dynamic name, dynamic gender, dynamic image) async{
    print("image path: ${image.path}");
    /*
    var url = "https://api.imgbb.com/1/upload";
    var apiKey = "0bfadd703a3d3b16f0a0d9f62ce125ce";
    var uploadImage;
    if(image != null){
      var imageBytes = image.readAsBytesSync();
      var imageEncoded = base64Encode(imageBytes);
      uploadImage = imageEncoded;
      //print("we have Image");
    }
    var response = await http.post(
      Uri.parse(url),
      body: {
        'key': apiKey.toString(),
        'image': uploadImage,
        'name': this.id.toString() + "_image",
      },
    );
    print("response: ${response.body}");
    */

    /*
    var url = "https://api.imgbb.com/1/upload";
    var apiKey = "0bfadd703a3d3b16f0a0d9f62ce125ce";
    var request = http.MultipartRequest("POST", Uri.parse(url));
    request.fields["key"] = apiKey.toString();
    request.fields["name"] = this.id.toString() + "_image";
    if(image != null){
      var pic = await http.MultipartFile.fromPath('image', image);
      request.files.add(pic);
      //print("pic $pic");
    }
    //Get the response from the server
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    //print("response has come");
    print(responseString);
    */

    // // SharedPreferences prefs = await SharedPreferences.getInstance();
    // // this.id = prefs.getString('userId')!;
    // // this.token = prefs.getString('token')!;
    // var image_;


    var url = api.ApiUrl + "v1/users/update/${this.id}";
    print("url $url");

    var request = http.MultipartRequest("POST", Uri.parse(url));

    request.headers['Authorization'] = "Bearer ${this.token.toString()}";

    if(image != null)
    {

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

    StreamedResponse response = await request.send();

    if(response.statusCode == 200){
      print("result: profile updated");
    }
    else{
      print("result: profile not updated");
    }


    // print("response ${response.body}");
    // // var body = <String, String>{
    // //   'email': email.toString(),
    // //   'name': name.toString(),
    // //   'gender': gender.toString(),
    // // };
    // //print(url);
    //print(name);
    //print(email);
    //print("gender to update: $gender");
    // var uploadImage;
    // if(image != null){
    //   var imageBytes = image.readAsBytesSync();
    //   var imageEncoded = base64Encode(imageBytes);
    //   uploadImage = imageEncoded;
    //   //print("we have Image");
    // }
    //
    //
    //
    // //create multipart request for POST or PATCH method
    // var request = http.MultipartRequest("POST", Uri.parse(url));
    // //print("upload: $uploadImage");
    // //add text fields
    // request.fields["email"] = email.toString();
    // request.fields["name"] = name.toString();
    // request.fields["gender"] = gender.toString();
    //
    // /*if(image != null){
    //   var pic = await http.MultipartFile.fromPath('image', image.path);
    //   request.files.add(pic);
    //   print("pic $pic");
    // }*/
    //
    // //Get the response from the server
    // var response = await request.send();
    // var responseData = await response.stream.toBytes();
    // var responseString = String.fromCharCodes(responseData);
    // //print("response has come");
    // print(responseString);


    // Map<String, dynamic> data = new Map<String, dynamic>.from(json.decode(responseString)['data']);
    // print(data);



    /*Map<String, dynamic> data = new Map<String, dynamic>.from(json.decode(response.body)['data']);
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

    notifyListeners();*/
  }
}
