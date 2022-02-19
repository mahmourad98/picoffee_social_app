import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:picoffee/components/service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class FollowingProvider extends ChangeNotifier{
  final String subRoute = 'v1/userGetFollowing';
  var followingUsers = <dynamic>[];

  Future<dynamic> getFollowing() async{
    followingUsers.clear();

    var url = api.ApiUrl + subRoute;
    //print(url);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }
    );

    var jsonResponse = convert.jsonDecode(response.body);
    print("the following: $jsonResponse");
    followingUsers.addAll(jsonResponse);
    notifyListeners();
  }
}