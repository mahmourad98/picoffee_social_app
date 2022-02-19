import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:picoffee/components/service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class FollowersProvider extends ChangeNotifier{
  final String subRoute = 'v1/userGetFollowers';
  var followersUsers = <dynamic>[];

  Future<dynamic> getFollowers() async{
    followersUsers.clear();
    var url = api.ApiUrl + subRoute;
    //print(url);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    //print('token: $token');
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      }
    );

    var jsonResponse = convert.jsonDecode(response.body);
    print("the followers: $jsonResponse");
    followersUsers.addAll(jsonResponse);
    notifyListeners();
  }
}