import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verbose_share_world/app_theme/app_theme.dart';
import 'package:verbose_share_world/auth/login/login_ui.dart';
import 'package:verbose_share_world/home/home.dart';
import 'package:verbose_share_world/topTweets/topTweets.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: TopTweetsScreen(),
    );
  }
}
