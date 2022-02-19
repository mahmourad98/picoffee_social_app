import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verbose_share_world/app_theme/app_theme.dart';
import 'package:verbose_share_world/home/home.dart';
import 'package:verbose_share_world/providers/FollowersProvider.dart';
import 'package:verbose_share_world/providers/FollowingProvider.dart';
import 'package:verbose_share_world/providers/GenderProvider.dart';
import 'package:verbose_share_world/providers/TopTweetProvider.dart';
import 'package:verbose_share_world/providers/TweetProvider.dart';

import 'package:verbose_share_world/providers/UserProvider.dart';
import 'package:verbose_share_world/topTweets/topTweets.dart';

import 'auth/login/login_ui.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp app = await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? logged_in = (prefs.containsKey('logged_in')) ? prefs.getBool('logged_in') : false;
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
        ChangeNotifierProvider(create: (_)=>Gender()),
        ChangeNotifierProvider(create: (_)=>TopTweets()),
        ChangeNotifierProvider(create: (_)=>FollowersProvider()),
        ChangeNotifierProvider(create: (_)=>FollowingProvider()),
        ChangeNotifierProvider(create: (_)=>TweetsProvider()),
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
