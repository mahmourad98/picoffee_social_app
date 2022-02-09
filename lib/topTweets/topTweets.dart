import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:verbose_share_world/app_config/app_config.dart';
import 'package:verbose_share_world/auth/login/login_ui.dart';
import 'package:verbose_share_world/auth/registration/registration_ui.dart';
import 'package:verbose_share_world/comments/comments.dart';
import 'package:verbose_share_world/app_theme/application_colors.dart';
import 'package:verbose_share_world/profile/edit_profile.dart';
import 'package:verbose_share_world/profile/my_profile_screen.dart';
import 'package:verbose_share_world/profile/user_profile.dart';

class FollowingItems {
  String image;
  String name;

  FollowingItems(this.image, this.name);
}

class TopTweetsScreen extends StatefulWidget {
  @override
  _TopTweetsScreenState createState() => _TopTweetsScreenState();
}

class _TopTweetsScreenState extends State<TopTweetsScreen> {

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
  Widget build(BuildContext context) {

    final mediaQuery = MediaQuery.of(context);

    final bHeight = mediaQuery.size.height - mediaQuery.padding.top - AppBar().preferredSize.height;

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
                            child: Icon(Icons.close, color: theme.primaryColor),
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
                                      style: theme.textTheme.headline6!.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    content: Container(
                                      width: 300,
                                      child: ListView.builder(
                                          physics: BouncingScrollPhysics(),
                                          itemCount:
                                          AppConfig.languagesSupported.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) =>
                                              TextButton(
                                                onPressed: () {

                                                },
                                                child: Text(
                                                    AppConfig.languagesSupported[
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
                  itemCount: _followingItems.length,
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
                                          builder: (_) =>
                                              UserProfileScreen()));
                                },
                                child: CircleAvatar(
                                  backgroundImage: AssetImage(
                                      _followingItems[index].image),
                                ),
                              ),
                              title: Text(
                                _followingItems[index].name,
                                style: theme.textTheme.bodyText1!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                'Today 8:30 am',
                                style: theme.textTheme.bodyText1!.copyWith(
                                    color: ApplicationColors.textGrey,
                                    fontSize: 11),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => CommentScreen()));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child:
                                Image.asset(_followingItems[index].image),
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
                                        Icons.remove_red_eye,
                                        size: 18,
                                        color: ApplicationColors.grey,
                                      ),
                                      SizedBox(width: 8.5),
                                      Text(
                                        '1.5k',
                                        style: TextStyle(
                                            color: ApplicationColors.grey,
                                            fontSize: 12,
                                            letterSpacing: 1),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      FaIcon(
                                        Icons.repeat_rounded,
                                        color: ApplicationColors.grey,
                                        size: 18,
                                      ),
                                      SizedBox(width: 8.5),
                                      Text(
                                        '287',
                                        style: TextStyle(
                                            color: ApplicationColors.grey,
                                            fontSize: 12,
                                            letterSpacing: 0.5),
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
                                        '287',
                                        style: TextStyle(
                                            color: ApplicationColors.grey,
                                            fontSize: 12,
                                            letterSpacing: 0.5),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.favorite_border,
                                        color: ApplicationColors.grey,
                                        size: 18,
                                      ),
                                      SizedBox(width: 8.5),
                                      Text(
                                        '9.5k',
                                        style: TextStyle(
                                            color: ApplicationColors.grey,
                                            fontSize: 12,
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
                beginOffset: Offset(0, 0.3),
                endOffset: Offset(0, 0),
                slideCurve: Curves.linearToEaseOut,
              ),
            ),
          ),
        ],
      )
    );
  }
}
