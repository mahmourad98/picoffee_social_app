import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:picoffee/app_config/app_config.dart';
import 'package:picoffee/components/service.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'FollowingProvider.dart';

class ProfileProvider with ChangeNotifier {
  var userData = <String, dynamic>{};
  var userTweets = <Map <String, dynamic>>[];
  var followed = false;

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
    userData['name'] = data['data']['attributes']['name'].toString();
    userData['email'] = data['data']['attributes']['email'].toString();
    if(data['data']['attributes']['image'] != null){
      var _imageUrl = AppConfig.postsPicturesUrl + data['data']['attributes']['image']['picture_name'].toString();
      userData['imageUrl'] = _imageUrl;
    }
    else{
      userData['imageUrl'] = "";
    }
    userData['gender'] = data['data']['attributes']['profile']['gender'].toString();
    userData['fcmToken'] = data['data']['attributes']['profile']['fcm_token'].toString();
    userData['followingCount'] = data['data']['attributes']['following_count'].toString();
    userData['followersCount'] = data['data']['attributes']['followers_count'].toString();
    //print('user data: $userData');

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

  Future<dynamic> followUser(dynamic id) async {
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

    if(data.contains('follow')){
      this.followed = true;
    }
    if(data.contains('unfollow')){
      this.followed = false;
    }

    notifyListeners();
  }

  dynamic checkFollowing(dynamic id, BuildContext buildContext){
    var list = Provider.of<FollowingProvider>(buildContext, listen: false).followingUsers;
    list.forEach(
      (element) {
        if (element.containsKey("id")) {
          if (element["id"] == id) {
            Provider.of<ProfileProvider>(buildContext, listen: false).followed = true;
            print("followed: ${this.followed}");
          }
        }
      }
    );
  }
}
