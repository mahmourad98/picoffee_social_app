import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:picoffee/app_config/app_config.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:picoffee/app_theme/application_colors.dart';
import 'package:picoffee/followers/followers.dart';
import 'package:picoffee/following/following.dart';
import 'package:picoffee/profile/edit_profile.dart';
import 'package:picoffee/providers/FollowersProvider.dart';
import 'package:picoffee/providers/FollowingProvider.dart';
import 'package:picoffee/providers/TweetProvider.dart';
import 'package:picoffee/providers/UserProvider.dart';


class MyProfileScreen extends StatefulWidget {
  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  late var myImageUrl;
  late var currentUserTweets;

  void initState() {
    super.initState();
    Provider.of<FollowersProvider>(context, listen: false).getFollowers();
    Provider.of<FollowingProvider>(context, listen: false).getFollowing();
    myImageUrl = Provider.of<UserProvider>(context, listen: false).imageUrl;
    //print("getting tweets");
    Provider.of<TweetsProvider>(context, listen: false).getCurrentUserTweets();
  }

  @override
  Widget build(BuildContext context) {
    var myUser = Provider.of<UserProvider>(context, listen: true);
    this.myImageUrl = Provider.of<UserProvider>(context, listen: true).imageUrl;
    this.currentUserTweets = Provider.of<TweetsProvider>(context, listen: true).currentUserTweets;

    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final myAppBar = AppBar(
      backgroundColor: ApplicationColors.white,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Image.asset(
          'assets/Icons/back_arrow_icon.png',
        ),
      ),
      elevation: 0,
    );
    final bheight = mediaQuery.size.height -
        mediaQuery.padding.top -
        myAppBar.preferredSize.height;

    return Scaffold(
      backgroundColor: ApplicationColors.white,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(56.0), // here the desired height
          child: myAppBar,
      ),
      body: FadedSlideAnimation(
        Column(
          children: [
            Container(
              color: ApplicationColors.white,
              height: bheight * 0.4,
              child: LayoutBuilder(
                builder: (context, constraints) => Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('${Provider.of<FollowersProvider>(context, listen: true).followersUsers.length.toString()}',
                                  style: theme.textTheme.headline6
                                ),
                                Text(
                                  'Followers',
                                  style: theme.textTheme.subtitle2!.copyWith(
                                    color: theme.hintColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            onTap: (){
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => FollowersScreen()
                                ),
                              );
                            },
                          ),
                          FadedScaleAnimation(
                            CircleAvatar(
                              radius: 40,
                              //backgroundImage: AssetImage('assets/images/Layer710.png'),
                              child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 2
                                    )
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: (myImageUrl.toString().isEmpty)
                                      ? Image.network('${AppConfig.profilePicturesUrl}avatar.png', width: 128, height: 128,  fit: BoxFit.cover,)
                                      : Image.network(myImageUrl, width: 128, height: 128, fit: BoxFit.cover,)
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('${Provider.of<FollowingProvider>(context, listen: true).followingUsers.length.toString()}',
                                  style: theme.textTheme.headline6
                                ),
                                Text(
                                  'Following',
                                  style: theme.textTheme.subtitle2!.copyWith(
                                    color: theme.hintColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            onTap: (){
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => FollowingScreen()
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${Provider.of<UserProvider>(context, listen: true).name}',
                      style: theme.textTheme.headline6,
                    ),
                    Text(
                      '${Provider.of<UserProvider>(context, listen: true).email}',
                      style: theme.textTheme.subtitle2!.copyWith(
                        color: theme.hintColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                    Container(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileScreen()));
                        },
                        child: Container(
                          width: constraints.maxWidth * 0.35,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: theme.primaryColor,
                                  style: BorderStyle.solid,
                                  width: 1),
                              borderRadius: BorderRadius.circular(10),
                              color: theme.primaryColor),
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: Text(
                            'Edit Profile',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.subtitle2!.copyWith(
                              color: theme.scaffoldBackgroundColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // TabBarView(
            //   controller: _tabController,
            //   children: [
            Container(
              height: bheight * 0.6,
              child: ListView.builder(
                itemCount: Provider.of<TweetsProvider>(context, listen: true).currentUserTweets.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 0,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.all(0),
                            leading: CircleAvatar(
                              backgroundImage: (myImageUrl.toString().isEmpty)
                                ? Image.network('${AppConfig.profilePicturesUrl}avatar.png', width: 128, height: 128,  fit: BoxFit.cover,).image
                                : Image.network(myImageUrl, width: 128, height: 128,).image
                            ),
                            title: Text(
                              '${Provider.of<UserProvider>(context, listen: true).name}',
                              style: theme.textTheme.subtitle2!.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                            subtitle: Text(
                              '${currentUserTweets[index]['created_at_string'].toString()}',
                              style: theme.textTheme.subtitle2!.copyWith(
                                color: theme.hintColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${currentUserTweets[index]['tweet'].toString()}',
                                style: theme.textTheme.headline5?.copyWith(
                                  color: ApplicationColors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: (currentUserTweets[index]['image'] == null)
                              ? Container()
                              : Image.network(myImageUrl, width: 128, height: 128,)
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.favorite_border,
                                      color: ApplicationColors.grey,
                                      size: 18.2,
                                    ),
                                    SizedBox(width: 8.5),
                                    Text(
                                      '${currentUserTweets[index]['comments'].length}',
                                      style: TextStyle(
                                          color: ApplicationColors.grey,
                                          letterSpacing: 1,
                                          fontSize: 11.7),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.chat_bubble_outline,
                                      color: ApplicationColors.grey,
                                      size: 18.2,
                                    ),
                                    SizedBox(width: 8.5),
                                    Text(
                                      '${currentUserTweets[index]['comments'].length}',
                                      style: TextStyle(
                                          color: ApplicationColors.grey,
                                          letterSpacing: 0.5,
                                          fontSize: 11.7),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            //   Container(),
            // ],
            // ),
          ],
        ),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }
}
