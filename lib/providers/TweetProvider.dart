import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:picoffee/components/service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class TweetsProvider extends ChangeNotifier{
  final String subRoute = 'v1/users/tweets';
  final String subRoute2 = 'v1/tweets';
  final String tweet_create='v1/tweets/store';
  final String tweet_update='v1/tweets/update/';
  final String tweet_delete='v1/tweets/delete/';
  var imageUrl;
  var currentUserTweets = <dynamic>[];
  var followingUsersTweets = <dynamic>[];

  bool showProgressBar = false;

  Future<dynamic> getCurrentUserTweets() async{
    currentUserTweets.clear();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('id');
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


  Future<dynamic> createTweet(tweeta,pic) async{
    print("Tweeta");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('id');
    var tweet = tweeta.text;//controller
    var url = api.ApiUrl + this.tweet_create;
    var token = prefs.getString('token');
    var img = pic;//controller


    var request = http.MultipartRequest("POST", Uri.parse(url));
    if(img != null) {
      var multipartAvatar = await http.MultipartFile.fromPath("image", img.path);
      request.files.add(multipartAvatar);
    }

    request.fields.addAll(
        {
          'user_id': userId.toString(),
          'tweet': tweet.toString(),

        }
    );
    request.headers['Authorization'] = "Bearer ${token.toString()}";

    StreamedResponse response = await request.send();
    //(response.statusCode == 200) ? print("profile was updated") : print("profile was not updated");
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print(responseString);
   // var jsonResponse = convert.jsonDecode(response.body);

    notifyListeners();
  }



  Future<dynamic> updateTweet(tweeta_id,tweeta) async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('id');
    var tweetId=tweeta_id;//index from front end
    var tweet =tweeta.text;//from front end
    var url = api.ApiUrl + this.tweet_update+ '$tweetId';
    var token = prefs.getString('token');
    tweetId=tweetId.toString();


    var response = await http.put(
        Uri.parse(url),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },

        body:{
          'user_id': '$userId',
          'tweet_id':'$tweetId',
          'tweet':'$tweet',
        }
    );
  //  var jsonResponse = convert.jsonDecode(response.body);

    notifyListeners();
  }

  Future<dynamic> deleteTweet(dynamic tweeta_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var tweetId=tweeta_id; //index from front end
    var url = api.ApiUrl + this.tweet_delete + '$tweetId';
    print(url);
    var token = prefs.getString('token');
    tweetId=tweetId.toString();

    var response = await http.delete(
        Uri.parse(url),
        headers: <String, String>{
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: {
          'tweet_id': '$tweetId',
        }
    );
   //var jsonResponse = convert.jsonDecode(response.body);

    notifyListeners();
  }
}