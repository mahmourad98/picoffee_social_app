import 'package:flutter/cupertino.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:picoffee/components/service.dart';

import 'FollowersProvider.dart';

class TopTweets with ChangeNotifier {
  List topTweets = [];

  getTopTweets() async {
    topTweets.clear();

    var url = api.ApiUrl + "getTopTweets";

    var response = await http.get(Uri.parse(url));
    var jsonResponse = convert.jsonDecode(response.body);
    topTweets.addAll(jsonResponse);

    notifyListeners();
  }
}
