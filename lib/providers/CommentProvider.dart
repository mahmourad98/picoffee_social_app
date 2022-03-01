import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:picoffee/app_config/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:picoffee/components/service.dart';

class CommentProvider with ChangeNotifier{

  var comments = <dynamic>[];


  // Get comments
  Future<dynamic> getComments(tweetId) async {
    //clear comments
    comments.clear();

    var url = api.ApiUrl + "v1/tweets/" + tweetId.toString();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Authorization' : "Bearer $token"
        },
    );
    if(response.ok){
      // print("response = ${response.body}");
      Map<String, dynamic> data = new Map<String, dynamic>.from(convert.jsonDecode(response.body));
      this.comments = data['comments'];
      // print('comments length: ${this.comments.length}');
      notifyListeners();
      return true;
    }
    else {
      BotToast.showSimpleNotification(title: "failed to reload");
      return false;
    }
  }

  // Create comment
  Future<dynamic> createComment(tweetId,comment) async{
    var url = api.ApiUrl + 'v1/comments/store';
    var comments = comment.toString();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var userId = prefs.getString('id');
    print(url);
    var response = await http.post(
     Uri.parse(url),
      headers: <String, String>{
        'Accept': 'application/json',
        'Authorization' : "Bearer $token"
      },
      body: {
       'user_id':'$userId',
        'tweet_id':'$tweetId',
        'body':'$comments',
      }
    );
    //Json response
    if(response.ok){
      // getComments(tweetId);
      notifyListeners();
      return true;
    }
    else {
      BotToast.showSimpleNotification(title: "failed to comment");
      return false;
    }
  }

}
