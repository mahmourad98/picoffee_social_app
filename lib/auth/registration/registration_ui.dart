import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
                prefix:  IconButton(
                  icon: Icon(
                    passwordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
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
              EntryField(
                enabled: false,
                hint: 'Gender',
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  // MALE

                  GestureDetector(
                    onTap: () {
                      // Provider.of<Gender>(context,listen:false ).selected();
                      Provider.of<Gender>(context, listen: false).isMale =
                          false;
                      Provider.of<User>(context, listen: false).gender = "male";
                    },
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Provider.of<Gender>(context, listen: true)
                                      .isMale ==
                                  false
                              ? Colors.red
                              : Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/Icons/icon_male.png',
                            height: 40,
                            // color: genderProvider.maleColor,
                          ),
                          Text(
                            'Male',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              // color: genderProvider.maleColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  // FEMALE
                  GestureDetector(
                    onTap: () {
                      Provider.of<Gender>(context, listen: false).isMale = true;
                      Provider.of<User>(context, listen: true).gender =
                          "female";
                    },
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Provider.of<Gender>(context, listen: false)
                                      .isMale ==
                                  true
                              ? Colors.red
                              : Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/Icons/icon_female.png',
                            height: 40,
                            // color: genderProvider.femaleColor,
                          ),
                          Text(
                            'Female',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              // color: genderProvider.femaleColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Spacer(flex: 1),
              CustomButton(
                  label: 'Register Now',
                  onTap: () async{
                    await createAccount();

                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
                  }),
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
      Provider.of<User>(context, listen: false).fcmtoken = value;
      // print(Provider.of<User>(context,listen: false).fcmtoken);
    });
  }

  getPlatform() {
    if (IO.Platform.isAndroid) {
      Provider.of<User>(context, listen: false).devicename = "android";
    } else if (IO.Platform.isIOS) {
      Provider.of<User>(context, listen: false).devicename = "IOS";
    }
  }

  createAccount() async{
    if (nameC.text.isEmpty || emailC.text.isEmpty) {
      BotToast.showSimpleNotification(
          title: 'enter name and email ', duration: Duration(seconds: 3));
    } else if (passwordC.text.isEmpty || Provider.of<User>(context,listen: false).gender.isEmpty) {
      BotToast.showSimpleNotification(
          title: ' enter password and gender ', duration: Duration(seconds: 3));
    } else {
      await Provider.of<User>(context, listen: false)
          .signUp(nameC, emailC, passwordC);
    }
  }
}
