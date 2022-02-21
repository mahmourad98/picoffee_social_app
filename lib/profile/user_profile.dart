import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:picoffee/providers/PofileProvider.dart';
import 'package:picoffee/providers/UserProvider.dart';
import 'package:provider/provider.dart';
import 'package:picoffee/app_theme/application_colors.dart';
import 'package:picoffee/followers/followers.dart';
import 'package:picoffee/following/following.dart';
import 'package:picoffee/providers/FollowersProvider.dart';
import 'package:picoffee/providers/FollowingProvider.dart';


class UserProfileScreen extends StatefulWidget {
  late final int userId;

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();

  UserProfileScreen({required dynamic id}){
    userId = int.parse(id);
    print("user id: $userId");
  }
}

class _UserProfileScreenState extends State<UserProfileScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  bool followed = false;

  @override
  void initState() {
    super.initState();
    Provider.of<FollowersProvider>(context, listen: false).getFollowers();
    Provider.of<FollowingProvider>(context, listen: false).getFollowing();
    Provider.of<ProfileProvider>(context, listen: false).getUserInfo(widget.userId);
    Provider.of<ProfileProvider>(context, listen: false).getUserTweets(widget.userId);
    checkFollowing();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    var myUserdata = Provider.of<ProfileProvider>(context, listen: true).userData;
    var myUserTweets = Provider.of<ProfileProvider>(context, listen: true).userTweets;

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
              height: bheight * 0.44,
              child: LayoutBuilder(
                builder: (context, constraints) => Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 70,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('9784', style: theme.textTheme.headline6),
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
                                MaterialPageRoute(builder: (context)=>FollowersScreen())
                              );
                            },
                          ),
                          FadedScaleAnimation(
                            CircleAvatar(
                              radius: 40,
                              backgroundImage:
                                  AssetImage('assets/images/Layer710.png'),
                            ),
                          ),
                          GestureDetector(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('3224', style: theme.textTheme.headline6),
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
                                  MaterialPageRoute(builder: (context)=>FollowingScreen())
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Text(
                      myUserdata['name'].toString(),
                      style: theme.textTheme.headline6,
                    ),
                    Text(
                      myUserdata['email'].toString(),
                      style: theme.textTheme.subtitle2!.copyWith(
                        color: theme.hintColor,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: constraints.maxWidth * 0.35,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: theme.primaryColor,
                                      style: BorderStyle.solid,
                                      width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                  color: ApplicationColors.white),
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child: Text(
                                'Message',
                                style: theme.textTheme.subtitle2!.copyWith(
                                  color: theme.primaryColor,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Provider.of<ProfileProvider>(context, listen: false).followUser(widget.userId);
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
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child: Text(
                                (this.followed)
                                ? ('Unfollow Now')
                                : ('Unfollow Now'),
                                textAlign: TextAlign.center,
                                style: theme.textTheme.subtitle2!.copyWith(
                                  color: theme.scaffoldBackgroundColor,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Expanded(
                      child: Container(
                        child: TabBar(
                          controller: _tabController,
                          isScrollable: true,
                          indicatorColor: theme.primaryColor,
                          indicatorSize: TabBarIndicatorSize.label,
                          tabs: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Posts',
                                style: theme.textTheme.bodyText1,
                              ),
                            ),
                            Text(
                              'Stories',
                              style: theme.textTheme.bodyText1,
                            ),
                          ],
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
            Expanded(
              child: Container(
                //height: bheight * 0.6,
                child: ListView.builder(
                  itemCount: myUserTweets.length,
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
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => UserProfileScreen(id: 0)));
                                },
                                child: CircleAvatar(
                                  backgroundImage: (myUserdata['imageUrl'] == null)
                                    ? AssetImage('assets/images/Layer710.png')
                                    : NetworkImage("${myUserdata['imageUrl']}") as ImageProvider,
                                  // child: (myUserTweets[index]['imageUrl'] == null)
                                  //     ? Image.asset('assets/images/Layer709.png')
                                  //     : Image.network(myUserTweets[index]['imageUrl'])
                                ),
                              ),
                              title: Text(
                                myUserdata['name'].toString(),
                                style: theme.textTheme.subtitle2!.copyWith(
                                  fontSize: 13.3,
                                ),
                              ),
                              subtitle: Text(
                                'Today 10:00 pm',
                                style: theme.textTheme.subtitle2!.copyWith(
                                  color: theme.hintColor,
                                  fontSize: 10.7,
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Image.asset(
                                    'assets/Icons/ic_share.png',
                                    scale: 3,
                                  ),
                                  SizedBox(width: 10),
                                  Icon(
                                    Icons.bookmark_border,
                                    size: 18,
                                  ),
                                  SizedBox(width: 10),
                                  Icon(
                                    Icons.more_vert,
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: (myUserTweets[index]['imageUrl'] == null)
                                ? Image.asset('assets/images/Layer709.png')
                                : Image.network(myUserTweets[index]['imageUrl'])
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.remove_red_eye,
                                        color: ApplicationColors.grey,
                                        size: 18.3,
                                      ),
                                      SizedBox(width: 7),
                                      Text(
                                        '1.2k',
                                        style: TextStyle(
                                            color: ApplicationColors.grey,
                                            fontSize: 11.7,
                                            letterSpacing: 1),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      FaIcon(
                                        Icons.repeat_rounded,
                                        color: ApplicationColors.grey,
                                        size: 18.3,
                                      ),
                                      SizedBox(width: 7),
                                      Text(
                                        '287',
                                        style: TextStyle(
                                            color: ApplicationColors.grey,
                                            fontSize: 11.7,
                                            letterSpacing: 0.5),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.chat_bubble_outline,
                                        color: ApplicationColors.grey,
                                        size: 18.3,
                                      ),
                                      SizedBox(width: 7),
                                      Text(
                                        '287',
                                        style: TextStyle(
                                            color: ApplicationColors.grey,
                                            fontSize: 11.7,
                                            letterSpacing: 0.5),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.favorite_border,
                                        color: ApplicationColors.grey,
                                        size: 18.3,
                                      ),
                                      SizedBox(width: 7),
                                      Text(
                                        '8.2k',
                                        style: TextStyle(
                                            color: ApplicationColors.grey,
                                            fontSize: 11.7,
                                            letterSpacing: 1),
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

  dynamic checkFollowing(){
    var list = Provider.of<FollowingProvider>(context, listen: false).followingUsers;
    list.forEach(
      (element) {
        if (element.containsKey("id")) {
          if (element["id"] == widget.userId) {
            this.followed = true;
          }
        }
      }
    );
  }
}
