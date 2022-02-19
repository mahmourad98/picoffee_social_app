import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:verbose_share_world/app_theme/application_colors.dart';
import 'package:verbose_share_world/components/custom_button.dart';
import 'package:verbose_share_world/components/entry_field.dart';
import 'package:verbose_share_world/home/home.dart';
import 'package:verbose_share_world/providers/GenderProvider.dart';
import 'dart:io' as IO;
import 'package:verbose_share_world/providers/UserProvider.dart';

class RegistrationUi extends StatefulWidget {
  @override
  _RegistrationUiState createState() => _RegistrationUiState();
}

class _RegistrationUiState extends State<RegistrationUi> {
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  bool passwordVisible = true;
  bool clicked = false;

  void initState() {
    getUserToken();
    getPlatform();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('New User', style: theme.textTheme.headline6),
        leading: (Navigator.of(context).canPop())
            ? GestureDetector(
                child: Icon(Icons.arrow_back, color: ApplicationColors.black),
                onTap: () {
                  Navigator.of(context).pop();
                },
              )
            : SizedBox(),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height -
              AppBar().preferredSize.height -
              MediaQuery.of(context).padding.vertical,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.only(start: 56),
                child: Text(
                  'Register now to continue',
                  style: theme.textTheme.headline6!
                      .copyWith(fontSize: 12, color: theme.hintColor),
                ),
              ),
              SizedBox(height: 70),
              EntryField(
                hint: 'Full Name',
                controller: nameC,
              ),
              SizedBox(height: 20),
              EntryField(
                hint: 'Email Address',
                controller: emailC,
              ),
              SizedBox(height: 20),
              EntryField(
                hint: 'Password',
                controller: passwordC,
                obscureText: passwordVisible,
                prefix: IconButton(
                  icon: Icon(
                    passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      passwordVisible = !passwordVisible;
                    });
                  },
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                enabled: false,
                decoration: InputDecoration(
                    hintText: 'Gender', border: InputBorder.none),
              ),
              Row(
                children: [
                  Row(
                    children: [
                      Text('Male'),
                      Radio(
                        activeColor: Colors.red,
                        value: 0,
                        groupValue:
                            Provider.of<Gender>(context, listen: true).isMale,
                        onChanged: (int? valyue) {
                          Provider.of<Gender>(context, listen: false).isMale =
                              valyue!;
                          Provider.of<UserProvider>(context, listen: false).gender =
                              "male";
                        },
                        focusColor: Colors.amberAccent,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Female'),
                      Radio(
                        activeColor: Colors.red,
                        value: 1,
                        groupValue:
                            Provider.of<Gender>(context, listen: false).isMale,
                        onChanged: (int? valyue) {
                          Provider.of<Gender>(context, listen: false).isMale =
                              valyue!;
                          Provider.of<UserProvider>(context, listen: false).gender =
                              "female";
                        },
                      ),
                    ],
                  ),
                ],
              ),
              Spacer(flex: 1),
              (clicked == false)
                  ? CustomButton(
                      label: 'Register Now',
                      onTap: () async {
                        if (nameC.text.isEmpty || emailC.text.isEmpty) {
                          BotToast.showSimpleNotification(
                              title: 'enter name and email ',
                              duration: Duration(seconds: 3));
                        } else if (passwordC.text.isEmpty ||
                            Provider.of<UserProvider>(context, listen: false)
                                .gender
                                .isEmpty) {
                          BotToast.showSimpleNotification(
                              title: ' enter password and gender ',
                              duration: Duration(seconds: 3));
                        } else {
                          setState(() {
                            clicked = true;
                          });
                          await Provider.of<UserProvider>(context, listen: false)
                              .signUp(nameC, emailC, passwordC);
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()));
                        }
                      })
                  : Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    ),
              SizedBox(height: 28),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  getUserToken() async {
    return await firebaseMessaging.getToken().then((value) {
      Provider.of<UserProvider>(context, listen: false).fcmtoken = value;
    });
  }

  getPlatform() {
    if (IO.Platform.isAndroid) {
      Provider.of<UserProvider>(context, listen: false).deviceName = "android";
    } else if (IO.Platform.isIOS) {
      Provider.of<UserProvider>(context, listen: false).deviceName = "IOS";
    }
  }
}
