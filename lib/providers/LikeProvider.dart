import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:picoffee/components/service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class LikeProvider extends ChangeNotifier{

  var liked = false;
  var likeCount;
  var resp = <dynamic>[];

  Future<dynamic> getlikesTweet($tweetId) async{
    // resp.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('id');
    var url = api.ApiUrl + "v1/tweets/" + $tweetId.toString();
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
    print("the tweets of the user: $jsonResponse");
    this.likeCount = jsonResponse['likes_count'];
    // resp.addAll(jsonResponse);

    notifyListeners();
  }

  Future<dynamic> likeTweet(tweetId) async {
    var url = api.ApiUrl + "v1/tweets/like";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token')!;
    var userId = prefs.getString('id')!;

    var response = await http.post(
        Uri.parse(url),
        body: {
          'user_id' : '$userId',
          'tweet_id' : '$tweetId',
        },
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        }
    );

    var data = response.body;
    //print('response: $data');

    if(data.contains('likes_count')){
      this.liked = true;
    }
    else{
      this.liked = false;
    }

    notifyListeners();
  }

}