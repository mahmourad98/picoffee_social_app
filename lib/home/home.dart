import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:picoffee/app_config/app_config.dart';
import 'package:picoffee/comments/comments.dart';
import 'package:picoffee/app_theme/application_colors.dart';
import 'package:picoffee/post/text_post.dart';
import 'package:picoffee/profile/edit_profile.dart';
import 'package:picoffee/profile/my_profile_screen.dart';
import 'package:picoffee/profile/user_profile.dart';
import 'package:picoffee/providers/FollowersProvider.dart';
import 'package:picoffee/providers/FollowingProvider.dart';
import 'package:picoffee/providers/TweetProvider.dart';
import 'package:picoffee/providers/UserProvider.dart';
import 'package:picoffee/topTweets/topTweets.dart';

class FollowingItems {
  String image;
  String name;

  FollowingItems(this.image, this.name);
}

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  late var myName;
  late var myEmail;
  late var myImageUrl;
  late var loggedIn;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<BottomNavigationBarItem> _bottomBarItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: FaIcon(
        FontAwesomeIcons.video,
        size: 20,
      ),
      label: 'Video',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.notifications),
      label: 'Noti',
    ),
    BottomNavigationBarItem(
      icon: FaIcon(
        FontAwesomeIcons.comments,
        size: 20,
      ),
      label: 'Chat',
    ),
  ];

  List<FollowingItems> _followingItems = [
    FollowingItems('assets/images/Layer707.png', 'Emili Williamson'),
    FollowingItems('assets/images/Layer709.png', 'Harshu Makkar'),
    FollowingItems('assets/images/Layer948.png', 'Mrs. White'),
    FollowingItems('assets/images/Layer884.png', 'Marie Black'),
    FollowingItems('assets/images/Layer915.png', 'Emili Williamson'),
    FollowingItems('assets/images/Layer946.png', 'Emili Williamson'),
    FollowingItems('assets/images/Layer948.png', 'Emili Williamson'),
    FollowingItems('assets/images/Layer949.png', 'Emili Williamson'),
    FollowingItems('assets/images/Layer950.png', 'Emili Williamson'),
  ];

  @override
  void initState() {
     Provider.of<UserProvider>(context, listen: false).getUserInfo();
     Provider.of<FollowersProvider>(context, listen: false).getFollowers();
     Provider.of<FollowingProvider>(context, listen: false).getFollowing();
     Provider.of<TweetsProvider>(context, listen: false).getFollowingUsersTweets();
     Provider.of<TweetsProvider>(context, listen: false).getCurrentUserTweets();
     myImageUrl = Provider.of<UserProvider>(context, listen: false).imageUrl;
     loggedIn = Provider.of<UserProvider>(context, listen: false).logged_in;
    super.initState();
  }

  void onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var myUser = Provider.of<UserProvider>(context, listen: true);
    this.myImageUrl = Provider.of<UserProvider>(context, listen: true).imageUrl;
    this.myEmail = Provider.of<UserProvider>(context, listen: true).email;
    this.myName = Provider.of<UserProvider>(context, listen: true).name;
    this.loggedIn = Provider.of<UserProvider>(context, listen: true).logged_in;
    var myFollowingUsersTweets = Provider.of<TweetsProvider>(context, listen: true).followingUsersTweets;

    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    final bHeight = mediaQuery.size.height -
        mediaQuery.padding.top -
        AppBar().preferredSize.height;

    //var followingUsersTweets = Provider.of<TweetsProvider>(context, listen: true).followingUsersTweets;

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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.centerRight,
                          width: double.infinity,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Icon(Icons.close, color: theme.primaryColor),
                          ),
                        ),
                        SizedBox(height: 20),
                        FadedScaleAnimation(
                          Container(
                            child: CircleAvatar(
                              radius: 35,
                              //backgroundImage: AssetImage('assets/images/Layer707.png'),
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
                                    child: (myImageUrl.isEmpty)
                                      ? Image.asset('assets/images/Layer1677.png', fit: BoxFit.cover,)
                                      : Image.network(myImageUrl, fit: BoxFit.cover,)
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          child: Text(
                            'Hey',
                            style: theme.textTheme.subtitle2!.copyWith(
                              color: theme.hintColor,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            (myName == null) ? "Null" : myName,
                            style: theme.textTheme.subtitle2!.copyWith(
                              color: theme.hintColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        SizedBox(height: 50),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => MyProfileScreen()));
                          },
                          child: Container(
                            width: double.infinity,
                            child: Text(
                              'View Profile',
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
                                builder: (context) => ProfileScreen()));
                          },
                          child: Container(
                            width: double.infinity,
                            child: Text(
                              'Edit Profile',
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
                                                        .languagesSupported.keys
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
                            width: double.infinity,
                            child: Text(
                              'Change Language',
                              style: theme.textTheme.headline6!.copyWith(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        GestureDetector(
                          onTap: () async{
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.clear();
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => TopTweetsScreen()));
                          },
                          child: Container(
                            width: double.infinity,
                            child: Text(
                              'Logout',
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
          'Share World',
          style: Theme.of(context).textTheme.headline6!.copyWith(fontSize: 24),
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
                  //backgroundImage: AssetImage('assets/images/Layer1677.png'),
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
                        child: (myImageUrl.isEmpty)
                          ? Image.asset('assets/images/Layer1677.png', width: 128, height: 128,)
                          : Image.network(myImageUrl, width: 48, height: 48,)
                    ),
                  ),
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
                  itemCount: myFollowingUsersTweets.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 0,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.all(0),
                              leading: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) {
                                        return UserProfileScreen(
                                          id: Provider.of<TweetsProvider>(context).followingUsersTweets[index]['user']['id'].toString(),
                                        );
                                      }
                                    ),
                                  );
                                },
                                child: CircleAvatar(
                                 backgroundImage: AssetImage(_followingItems[index].image),
                                ),
                              ),
                              title: Text(
                                Provider.of<TweetsProvider>(context).followingUsersTweets[index]['user']['name'],
                                style: theme.textTheme.bodyText1!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                '${myFollowingUsersTweets[index]['created_at_string']}',
                                style: theme.textTheme.bodyText1!.copyWith(
                                    color: ApplicationColors.textGrey,
                                    fontSize: 11),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  '${Provider.of<TweetsProvider>(context).followingUsersTweets[index]['tweet'].toString()}',
                                  style: theme.textTheme.headline5?.copyWith(
                                      color: ApplicationColors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => CommentScreen(comm: [],indexuserTweet: 0,),
                                  ),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: ((myFollowingUsersTweets[index]['image'] == null) || myFollowingUsersTweets[index]['image'].isEmpty)
                                  ? Container()
                                  : Image.network(myFollowingUsersTweets[index]['image'], fit: BoxFit.cover,)
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
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
                                        '${myFollowingUsersTweets[index]['likes'].length}',
                                        style: TextStyle(
                                            color: ApplicationColors.grey,
                                            fontSize: 12,
                                            letterSpacing: 1),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.chat_bubble_outline,
                                        color: ApplicationColors.grey,
                                        size: 18,
                                      ),
                                      SizedBox(width: 8.5),
                                      Text(
                                        '${myFollowingUsersTweets[index]['comments'].length}',
                                        style: TextStyle(
                                            color: ApplicationColors.grey,
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
                    );
                  },
                ),
                beginOffset: Offset(0, 0.3),
                endOffset: Offset(0, 0),
                slideCurve: Curves.linearToEaseOut,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => TextPostScreen()));
        },
      ),
    );
  }
}
