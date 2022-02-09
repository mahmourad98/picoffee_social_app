import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:verbose_share_world/app_theme/application_colors.dart';
import 'package:verbose_share_world/profile/user_profile.dart';


class FollowersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            child: Icon(Icons.arrow_back,color: ApplicationColors.black),
            onTap: (){
              Navigator.of(context).pop();
            },
          ),
          title: Text('Followers',style: Theme.of(context).textTheme.headline6!.copyWith(fontSize: 24),),
        ),
        body: Container(
          color: ApplicationColors.white,
          child: FadedSlideAnimation(
            ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: 20,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    contentPadding: EdgeInsets.only(left: 16, right: 10),
                    leading: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => UserProfileScreen()));
                      },
                      child: FadedScaleAnimation(
                        CircleAvatar(
                          radius: 22,
                          backgroundImage: AssetImage(
                              'assets/images/profile_pics/Layer1804.png'),
                        ),
                      ),
                    ),
                    // title: Text('Kevin Taylor Liked your post'),
                    title: RichText(
                      text: TextSpan(
                        style: theme.textTheme.subtitle1!.copyWith(
                          letterSpacing: 0.5,
                        ),
                        children: [
                          TextSpan(
                              text: 'kayvin taylor',
                              style: theme.textTheme.subtitle2!
                                  .copyWith(fontSize: 12)),
                          TextSpan(
                              text: ' ' + 'Followed' + ' ',
                              style: TextStyle(
                                  color: theme.primaryColor, fontSize: 12)),
                          TextSpan(
                              text: 'you',
                              style: theme.textTheme.subtitle2!.copyWith(
                                fontSize: 14,
                              )),
                        ],
                      ),
                    ),
                    subtitle: Text(
                      'Yesterday 5:00 am',
                      style: theme.textTheme.subtitle2!.copyWith(
                        fontSize: 12,
                        color: theme.hintColor,
                      ),
                    ),
                    trailing: AspectRatio(
                      aspectRatio: 1 / 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: Image.asset(
                          'assets/images/Layer709.png',
                          fit: BoxFit.fitHeight,
                        ),
                      ),
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
    );
  }
}
