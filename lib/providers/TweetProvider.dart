import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:picoffee/components/service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class TweetsProvider extends ChangeNotifier{
  final String subRoute = 'v1/users/tweets';
  final String subRoute2 = 'v1/tweets';

  var currentUserTweets = <dynamic>[];
  var followingUsersTweets = <dynamic>[];

  Future<dynamic> getCurrentUserTweets() async{
    currentUserTweets.clear();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('userId');
    var url = api.ApiUrl + this.subRoute + '/$userId';
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
    //print("the tweets of the user: $jsonResponse");
    currentUserTweets.addAll(jsonResponse);

    notifyListeners();
  }

  Future<dynamic> getFollowingUsersTweets() async{
    followingUsersTweets.clear();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = api.ApiUrl + this.subRoute2;
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
    //print("the tweets of the following users: $jsonResponse");
    followingUsersTweets.addAll(jsonResponse);

    notifyListeners();
  }
}