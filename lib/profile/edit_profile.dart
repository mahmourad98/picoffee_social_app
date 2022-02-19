import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:picoffee/app_theme/application_colors.dart';
import 'package:picoffee/providers/UserProvider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameTextController = TextEditingController();
  TextEditingController usernameTextController = TextEditingController();
  TextEditingController phoneTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController genderTextController = TextEditingController();

  late var name;
  late var email;
  late var phone;
  late var gender;

  @override
  void initState() {
    Provider.of<UserProvider>(context, listen: false).getUserInfo();
    name = Provider.of<UserProvider>(context, listen: false).name;
    email = Provider.of<UserProvider>(context, listen: false).email;
    phone = Provider.of<UserProvider>(context, listen: false).phone ?? "Not Assigned Yet.";
    gender = Provider.of<UserProvider>(context, listen: false).profile['gender']!;
    nameTextController.text = this.name!;
    emailTextController.text = this.email!;
    usernameTextController.text = this.email.split('@')[0].toString();
    phoneTextController.text = this.phone;
    genderTextController.text = (this.gender.isEmpty) ? "Not Assigned Yet." : this.gender;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    final myAppBar = AppBar(
      title: Text(
        'My Profile',
        style: theme.textTheme.headline6,
      ),
      backgroundColor: ApplicationColors.white,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(Icons.chevron_left),
      ),
      elevation: 0,
      actions: [
        TextButton(
          onPressed: () {},
          child: Text(
            'Logout',
            style: theme.textTheme.button!
                .copyWith(color: theme.primaryColor, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
    final bheight = mediaQuery.size.height - mediaQuery.padding.top - myAppBar.preferredSize.height;
    return Scaffold(
      appBar: myAppBar,
      body: FadedSlideAnimation(
        Container(
          color: ApplicationColors.white,
          height: bheight,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      FadedScaleAnimation(
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: AssetImage('assets/images/Layer1677.png'),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 7,
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theme.primaryColor,
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 20, 0, 20),
                      alignment: Alignment.centerLeft,
                      color: ApplicationColors.lightGrey,
                      width: double.infinity,
                      child: Text(
                        'Porfile Info',
                        style: theme.textTheme.headline6!.copyWith(
                          color: Colors.grey,
                          fontSize: ApplicationColors.fontSize16,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: TextField(
                        controller: nameTextController,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          alignLabelWithHint: false,
                          border: InputBorder.none,
                          labelStyle: TextStyle(height: 1),
                        ),
                      ),
                    ),
                    Divider(
                      color: ApplicationColors.lightGrey,
                      thickness: 3,
                    ),
                    Container(
                      color: Colors.white,
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: TextField(
                        controller: usernameTextController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          labelStyle: TextStyle(height: 1),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Divider(
                      color: ApplicationColors.lightGrey,
                      thickness: 3,
                    ),
                    Container(
                      color: Colors.white,
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: TextField(
                        controller: phoneTextController,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          labelStyle: TextStyle(height: 1),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Divider(
                      color: ApplicationColors.lightGrey,
                      thickness: 3,
                    ),
                    Container(
                      color: Colors.white,
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: TextField(
                        controller: emailTextController,
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          labelStyle: TextStyle(height: 1),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Divider(
                      color: ApplicationColors.lightGrey,
                      thickness: 3,
                    ),
                    Container(
                      color: Colors.white,
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: TextField(
                        controller: genderTextController,
                        decoration: InputDecoration(
                          labelText: 'Gender',
                          labelStyle: TextStyle(height: 1),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Divider(
                      color: ApplicationColors.lightGrey,
                      thickness: 3,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: GestureDetector(
                      onTap: () {
                        //print(nameTextController.text);
                        Provider.of<UserProvider>(context, listen: false).updateUserInfo(
                            emailTextController.text,
                            nameTextController.text,
                            genderTextController.text);
                      },
                      child: Container(
                        //width: constraints.maxWidth * 0.35,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: theme.primaryColor, style: BorderStyle.solid, width: 1),
                            borderRadius: BorderRadius.circular(10),
                            color: theme.primaryColor),
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: Text(
                          'Update Profile',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.subtitle2!.copyWith(
                              color: theme.scaffoldBackgroundColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }
}
