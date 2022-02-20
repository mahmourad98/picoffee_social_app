import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:picoffee/providers/ImageProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:picoffee/app_theme/app_theme.dart';
import 'package:picoffee/home/home.dart';
import 'package:picoffee/providers/FollowersProvider.dart';
import 'package:picoffee/providers/FollowingProvider.dart';
import 'package:picoffee/providers/GenderProvider.dart';
import 'package:picoffee/providers/TopTweetProvider.dart';
import 'package:picoffee/providers/TweetProvider.dart';

import 'package:picoffee/providers/UserProvider.dart';
import 'package:picoffee/topTweets/topTweets.dart';

import 'auth/login/login_ui.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp app = await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? logged_in = (prefs.containsKey('logged_in')) ? prefs.getBool('logged_in') : false;
  print("logged in $logged_in");
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MyApp( logged_in));

}

class MyApp extends StatelessWidget {

  var logged_in;

  MyApp(this.logged_in);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>UserProvider()),
        ChangeNotifierProvider(create: (_)=>MyGenderProvider()),
        ChangeNotifierProvider(create: (_)=>TopTweets()),
        ChangeNotifierProvider(create: (_)=>FollowersProvider()),
        ChangeNotifierProvider(create: (_)=>FollowingProvider()),
        ChangeNotifierProvider(create: (_)=>TweetsProvider()),
        ChangeNotifierProvider(create: (_)=>MyImageProvider()),
      ],
      child: MaterialApp(
        builder: BotToastInit(),
        navigatorObservers: [BotToastNavigatorObserver()],
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home:(logged_in == false) ? TopTweetsScreen() :  HomeScreen(),
      ),
    );
  }
}
