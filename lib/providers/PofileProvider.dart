import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:picoffee/components/service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider with ChangeNotifier {
  var userData = <String, dynamic>{};
  var userTweets = <Map <String, dynamic>>[];

  dynamic getUserInfo(dynamic id) async {
    userData.clear();
    var url = api.ApiUrl + "v1/users/" + id.toString();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token')!;
    var response = await http.get(
      Uri.parse(url),
        headers: <String, String>{
          //'Content-Type': 'application/json',
          //'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }
    );

    Map<String, dynamic> data = new Map<String, dynamic>.from(json.decode(response.body));
    //print("profile provider data: $data");
    userData['name'] = data['data']['attributes']['name'];
    userData['email'] = data['data']['attributes']['email'];
    userData['imageUrl'] = data['data']['attributes']['image'];
    userData['gender'] = data['data']['attributes']['profile']['gender'];
    userData['fcmToken'] = data['data']['attributes']['profile']['fcm_token'];
    print('user data: $userData');

    notifyListeners();
  }

  dynamic getUserTweets(dynamic id) async {
    userTweets.clear();
    var url = api.ApiUrl + "v1/users/tweets/" + id.toString();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token')!;

    var response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          //'Content-Type': 'application/json',
          //'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }
    );

    var data = new List.from(json.decode(response.body));
    for(var i = 0; i < data.length; i++){
      var map = <String, dynamic>{
        'id' : data[i]['id'],
        'tweet' : data[i]['tweet'],
        'comments' : data[i]['comments'],
        'imageUrl' : data[i]['image'],
      };
      userTweets.add(map);
    }
    print('user tweets: $userTweets');

    notifyListeners();
  }

  dynamic followUser(dynamic id) async {
    var url = api.ApiUrl + "v1/users/follow";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token')!;
    var fromUserId = prefs.getString('id')!;

    var response = await http.post(
        Uri.parse(url),
        body: {
          'from_user_id' : fromUserId,
          'to_user_id' : id.toString(),
        },
        headers: <String, String>{
          //'Content-Type': 'application/json',
          //'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }
    );

    var data = response.body;
    print('response: $data');

    notifyListeners();
  }
}
