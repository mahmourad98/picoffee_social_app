import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:verbose_share_world/auth/registration/registration_ui.dart';
import 'package:verbose_share_world/components/custom_button.dart';
import 'package:verbose_share_world/components/entry_field.dart';
import 'package:verbose_share_world/home/home.dart';
import 'package:verbose_share_world/providers/UserProvider.dart';
import 'dart:io' as IO;

class LoginUi extends StatefulWidget {
  @override
  _LoginUiState createState() => _LoginUiState();
}

class _LoginUiState extends State<LoginUi> {
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  bool passwordVisible = true;
  bool clicked = false;
  void initState() {
    getPlatform();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: mediaQuery.size.height,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Spacer(),
              Image.asset('assets/images/ShareWorldLogo.png', height: 30),
              Spacer(),
              EntryField(
                hint: 'Email',
                controller: emailC,
              ),
              SizedBox(height: 20),
              EntryField(
                obscureText: passwordVisible,
                hint: 'Passowrd',
                controller: passwordC,
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
              SizedBox(height: 40),
              (clicked == false)
                  ? CustomButton(
                      label: 'Sign in',
                      onTap: () async {
                        if (emailC.text.isEmpty || passwordC.text.isEmpty) {
                          BotToast.showSimpleNotification(
                              title: 'enter email and password ',
                              duration: Duration(seconds: 3));
                        } else {
                          setState(() {
                            clicked = true;
                          });
                          await Provider.of<User>(context, listen: false)
                              .signIn(emailC, passwordC);
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
              Spacer(),
              Text('Or Continue with',
                  style: theme.textTheme.headline6!.copyWith(fontSize: 14)),
              SizedBox(height: 32),
              CustomButton(
                radius: 12,
                color: Color(0xff3b45c1),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => RegistrationUi()));
                },
                label: 'Register',
                textColor: Colors.white,
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  getPlatform() {
    if (IO.Platform.isAndroid) {
      Provider.of<User>(context, listen: false).devicename = "android";
    } else if (IO.Platform.isIOS) {
      Provider.of<User>(context, listen: false).devicename = "IOS";
    }
  }
}
