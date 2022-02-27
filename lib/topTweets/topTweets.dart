import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:picoffee/app_config/app_config.dart';
import 'package:picoffee/auth/login/login_ui.dart';
import 'package:picoffee/auth/registration/registration_ui.dart';
import 'package:picoffee/app_theme/application_colors.dart';
import 'package:picoffee/providers/TopTweetProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TopTweetsScreen extends StatefulWidget {
  _TopTweetsScreenState createState() => _TopTweetsScreenState();
}

class _TopTweetsScreenState extends State<TopTweetsScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    Provider.of<TopTweets>(context, listen: false).getTopTweets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final bHeight = mediaQuery.size.height -
        mediaQuery.padding.top -
        AppBar().preferredSize.height;

    final theme = Theme.of(context);

    return Scaffold(
        key: _scaffoldKey,
        endDrawer: Container(
          width: 225,
          color: ApplicationColors.scaffoldBackgroundColor,
          height: mediaQuery.size.height,
          child: Drawer(
            child: FadedSlideAnimation(
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 40, left: 20, right: 10),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            width: double.infinity,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child:
                                  Icon(Icons.close, color: theme.primaryColor),
                            ),
                          ),
                          SizedBox(height: 20),
                          FadedScaleAnimation(
                            Container(
                              child: CircleAvatar(
                                radius: 35,
                                backgroundImage:
                                    AssetImage('assets/images/Layer1677.png'),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            child: Text(
                              'Hey',
                              style: theme.textTheme.subtitle2!.copyWith(
                                color: theme.hintColor,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              'Guest',
                              style: theme.textTheme.subtitle2!.copyWith(
                                color: theme.hintColor,
                              ),
                            ),
                          ),
                          SizedBox(height: 50),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => LoginUi()));
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              child: Text(
                                'Login',
                                style: theme.textTheme.headline6!.copyWith(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => RegistrationUi()));
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              child: Text(
                                'Create new Account',
                                style: theme.textTheme.headline6!.copyWith(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ),
                          SizedBox(height: 30),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) {
                                  return FadedSlideAnimation(
                                    AlertDialog(
                                      title: Text(
                                        'Select Language',
                                        style: theme.textTheme.headline6!
                                            .copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                      ),
                                      content: Container(
                                        width: 300,
                                        child: ListView.builder(
                                            physics: BouncingScrollPhysics(),
                                            itemCount: AppConfig
                                                .languagesSupported.length,
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) =>
                                                TextButton(
                                                  onPressed: () {},
                                                  child: Text(AppConfig
                                                          .languagesSupported[
                                                      AppConfig
                                                          .languagesSupported
                                                          .keys
                                                          .elementAt(index)]!),
                                                )),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Cancel'),
                                        ),
                                      ],
                                    ),
                                    beginOffset: Offset(0, 0.3),
                                    endOffset: Offset(0, 0),
                                    slideCurve: Curves.linearToEaseOut,
                                  );
                                },
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              child: Text(
                                'Change Language',
                                style: theme.textTheme.headline6!.copyWith(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              beginOffset: Offset(0, 0.3),
              endOffset: Offset(0, 0),
              slideCurve: Curves.linearToEaseOut,
            ),
          ),
        ),
        appBar: AppBar(
          title: Text(
            'Shared World',
            style:
                Theme.of(context).textTheme.headline6!.copyWith(fontSize: 24),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: GestureDetector(
                onTap: () {
                  _scaffoldKey.currentState!.openEndDrawer();
                },
                child: FadedScaleAnimation(
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/images/Layer1677.png'),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                height: bHeight,
                color: ApplicationColors.lightGrey,
                child: FadedSlideAnimation(
                  ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: Provider.of<TopTweets>(context, listen: true)
                        .topTweets
                        .length,
                    itemBuilder: (context, index) {
                      return Provider.of<TopTweets>(context, listen: true)
                                  .topTweets[index]['image'] !=
                              null
                          ? Card(
                              elevation: 0,
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  children: [
                                    ListTile(
                                      contentPadding: EdgeInsets.all(0),
                                      leading: CircleAvatar(
                                        backgroundImage: AssetImage(
                                            ('${Provider.of<TopTweets>(context, listen: true).topTweets[index]['image']}') !=
                                                    null
                                                ? "loading"
                                                : "emptysss"),
                                      ),
                                      title: Text(
                                        '${Provider.of<TopTweets>(context, listen: true).topTweets[index]['user']['name']}',
                                        style: theme.textTheme.bodyText1!
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                        '${Provider.of<TopTweets>(context, listen: true).topTweets[index]['created_at_string']}',
                                        style: theme.textTheme.bodyText1!
                                            .copyWith(
                                                color:
                                                    ApplicationColors.textGrey,
                                                fontSize: 11),
                                      ),
                                    ),
                                    Container(
                                      width: 300,
                                      // color: Colors.teal,
                                      child: ListTile(
                                        contentPadding:
                                            EdgeInsets.only(bottom: 5),
                                        title: Text(
                                            '${Provider.of<TopTweets>(context, listen: true).topTweets[index]['tweet']}'),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.favorite_border,
                                                color: ApplicationColors.grey,
                                                size: 18,
                                              ),
                                              SizedBox(width: 8.5),
                                              Text(
                                                '${Provider.of<TopTweets>(context, listen: true).topTweets[index]['likes_count']}',
                                                style: TextStyle(
                                                    color:
                                                        ApplicationColors.grey,
                                                    fontSize: 12,
                                                    letterSpacing: 1),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () async {
                                                  SharedPreferences prefs =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  prefs.getString('token') !=
                                                          null
                                                      ? Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (cx) =>
                                                                  RegistrationUi()))
                                                      : Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (cx) =>
                                                                  RegistrationUi()));
                                                },
                                                child: Icon(
                                                  Icons.chat_bubble_outline,
                                                  color: ApplicationColors.grey,
                                                  size: 18,
                                                ),
                                              ),
                                              SizedBox(width: 8.5),
                                              Text(
                                                '${Provider.of<TopTweets>(context, listen: true).topTweets[index]['comments'].length}',
                                                style: TextStyle(
                                                    color:
                                                        ApplicationColors.grey,
                                                    fontSize: 12,
                                                    letterSpacing: 0.5),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Provider.of<TopTweets>(context, listen: true)
                                      .topTweets[index]['image'] ==
                                  null
                              ? Card(
                                  elevation: 0,
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          contentPadding: EdgeInsets.all(0),
                                          leading: CircleAvatar(
                                            backgroundImage: AssetImage(
                                                ('${Provider.of<TopTweets>(context, listen: true).topTweets[index]['image']}') !=
                                                        null
                                                    ? "loading"
                                                    : "emptysss"),
                                          ),
                                          title: Text(
                                            '${Provider.of<TopTweets>(context, listen: true).topTweets[index]['user']['name']}',
                                            style: theme.textTheme.bodyText1!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                          subtitle: Text(
                                            ' ${Provider.of<TopTweets>(context, listen: true).topTweets[index]['created_at_string']}',
                                            style: theme.textTheme.bodyText1!
                                                .copyWith(
                                                    color: ApplicationColors
                                                        .textGrey,
                                                    fontSize: 11),
                                          ),
                                        ),
                                        Container(
                                            child: ListTile(
                                          contentPadding:
                                              EdgeInsets.only(bottom: 5),
                                          title: Text(
                                              '${Provider.of<TopTweets>(context, listen: true).topTweets[index]['tweet']}'),
                                        )),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.favorite_border,
                                                    color:
                                                        ApplicationColors.grey,
                                                    size: 18,
                                                  ),
                                                  SizedBox(width: 8.5),
                                                  Text(
                                                    '${Provider.of<TopTweets>(context, listen: true).topTweets[index]['likes_count']}',
                                                    style: TextStyle(
                                                        color: ApplicationColors
                                                            .grey,
                                                        fontSize: 12,
                                                        letterSpacing: 1),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () async {
                                                      SharedPreferences prefs =
                                                          await SharedPreferences
                                                              .getInstance();
                                                      prefs.getString(
                                                                  'token') !=
                                                              null
                                                          ? Navigator.pushReplacement(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (cx) =>
                                                                      RegistrationUi()))
                                                          : Navigator.pushReplacement(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (cx) =>
                                                                      RegistrationUi()));
                                                    },
                                                    child: Icon(
                                                      Icons.chat_bubble_outline,
                                                      color: ApplicationColors
                                                          .grey,
                                                      size: 18,
                                                    ),
                                                  ),
                                                  SizedBox(width: 8.5),
                                                  Text(
                                                    '${Provider.of<TopTweets>(context, listen: true).topTweets[index]['comments'].length}',
                                                    style: TextStyle(
                                                        color: ApplicationColors
                                                            .grey,
                                                        fontSize: 12,
                                                        letterSpacing: 0.5),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container();
                    },
                  ),
                  beginOffset: Offset(0, 0.3),
                  endOffset: Offset(0, 0),
                  slideCurve: Curves.linearToEaseOut,
                ),
                // Container(
                //
                //     child: Card(child: Center(child: Text('No_data',style: TextStyle(fontSize: 24),)),)),
              ),
            ),
          ],
        ));
  }
}
