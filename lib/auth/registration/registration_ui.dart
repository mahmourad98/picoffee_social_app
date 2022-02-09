import 'package:flutter/material.dart';
import 'package:verbose_share_world/app_theme/application_colors.dart';
import 'package:verbose_share_world/components/custom_button.dart';
import 'package:verbose_share_world/components/entry_field.dart';
import 'package:verbose_share_world/home/home.dart';


class RegistrationUi extends StatefulWidget {

  @override
  _RegistrationUiState createState() => _RegistrationUiState();
}

class _RegistrationUiState extends State<RegistrationUi> {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('New User', style: theme.textTheme.headline6),
        leading: (Navigator.of(context).canPop()) ? GestureDetector(
          child: Icon(Icons.arrow_back,color: ApplicationColors.black),
          onTap: (){
            Navigator.of(context).pop();
          },
        ) : SizedBox(),
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
              ),
              SizedBox(height: 20),
              EntryField(
                hint: 'Email Address',
              ),
              SizedBox(height: 20),
              EntryField(
                hint: 'Password',
              ),
              Spacer(flex: 1),
              CustomButton(
                label: 'Register Now',
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
                }
              ),
              SizedBox(height: 28),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
