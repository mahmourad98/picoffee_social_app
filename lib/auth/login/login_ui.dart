import 'package:flutter/material.dart';
import 'package:verbose_share_world/auth/registration/registration_ui.dart';
import 'package:verbose_share_world/components/custom_button.dart';
import 'package:verbose_share_world/components/entry_field.dart';
import 'package:verbose_share_world/home/home.dart';


class LoginUi extends StatefulWidget {
  @override
  _LoginUiState createState() => _LoginUiState();
}

class _LoginUiState extends State<LoginUi> {

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
              ),
              SizedBox(height: 20),
              EntryField(
                hint: 'Passowrd',
              ),
              SizedBox(height: 40),
              CustomButton(
                label: 'Sign in',
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
                }
              ),
              Spacer(),
              Text('Or Continue with',
                  style: theme.textTheme.headline6!.copyWith(fontSize: 14)),
              SizedBox(height: 32),
              CustomButton(
                radius: 12,
                color: Color(0xff3b45c1),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegistrationUi()));
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
}
