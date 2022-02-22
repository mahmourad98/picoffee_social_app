import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:picoffee/app_config/app_config.dart';
import 'package:picoffee/providers/UserProvider.dart';
import 'package:provider/provider.dart';
import 'package:picoffee/app_theme/application_colors.dart';
import 'package:picoffee/profile/user_profile.dart';
import 'package:picoffee/providers/FollowersProvider.dart';


class FollowersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var myFollowers = Provider.of<FollowersProvider>(context, listen: true).followersUsers;
    var myUser = Provider.of<UserProvider>(context, listen: true);
    var myImageUrl = Provider.of<UserProvider>(context, listen: true).imageUrl;
    print("myImageUrl $myImageUrl");
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
              itemCount: myFollowers.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    contentPadding: EdgeInsets.only(left: 16, right: 10),
                    leading: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => UserProfileScreen(id: myFollowers[index]['id'].toString(),)
                          )
                        );
                      },
                      child: FadedScaleAnimation(
                        CircleAvatar(
                          radius: 22,
                          backgroundImage: (myFollowers[index]['image'] == null)
                          ? Image.network('${AppConfig.profilePicturesUrl}avatar.png', width: 128, height: 128, fit: BoxFit.cover,).image
                          : Image.network('${AppConfig.profilePicturesUrl}${myFollowers[index]['image']['picture_name']}', width: 128, height: 128, fit: BoxFit.cover,).image
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
                              text: myFollowers[index]['name'],
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
                        child: (myImageUrl.toString().isEmpty)
                          ? Image.network('${AppConfig.profilePicturesUrl}avatar.png', width: 128, height: 128, fit: BoxFit.cover,)
                          : Image.network(myImageUrl, width: 128, height: 128, fit: BoxFit.cover,)
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
