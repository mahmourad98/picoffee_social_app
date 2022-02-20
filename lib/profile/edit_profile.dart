import 'dart:io';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:picoffee/providers/GenderProvider.dart';
import 'package:picoffee/providers/ImageProvider.dart';
import 'package:picoffee/topTweets/topTweets.dart';
import 'package:provider/provider.dart';
import 'package:picoffee/app_theme/application_colors.dart';
import 'package:picoffee/providers/UserProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameTextController = TextEditingController();
  TextEditingController usernameTextController = TextEditingController();
  TextEditingController phoneTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();

  var _radioValue;
  var _pickedImage;

  late var name;
  late var email;
  late var phone;
  late var gender;
  late var image;

  @override
  void initState() {
    Provider.of<UserProvider>(context, listen: false).getUserInfo();
    name = Provider.of<UserProvider>(context, listen: false).name;
    email = Provider.of<UserProvider>(context, listen: false).email;
    phone = Provider.of<UserProvider>(context, listen: false).phone ?? "Not Assigned Yet.";
    gender = Provider.of<UserProvider>(context, listen: false).profile['gender']!;
    image = Provider.of<UserProvider>(context, listen: false).imageUrl;
    nameTextController.text = this.name!;
    emailTextController.text = this.email!;
    usernameTextController.text = this.email.split('@')[0].toString();
    phoneTextController.text = this.phone;

    if(this.gender.toString().toUpperCase().startsWith('F')){
      _radioValue = 1;
    }
    else{
      _radioValue = 0;
    }
    Provider.of<MyGenderProvider>(context, listen: false).initiate(_radioValue);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    _radioValue = Provider.of<MyGenderProvider>(context, listen: true).myValue;
    print("radio value: $_radioValue");
    _pickedImage = Provider.of<MyImageProvider>(context, listen: true).myImage;
    if(_pickedImage != null){
      print("picked image: true");
    }
    else{
      print("picked image: false");
    }

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
        icon: Image.asset(
          'assets/Icons/back_arrow_icon.png',
        ),
      ),
      elevation: 0,
      actions: [
        TextButton(
          onPressed: () async{
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.clear();
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => TopTweetsScreen()));
          },
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(64.0),
        child: myAppBar,
      ),
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
                  child: GestureDetector(
                    onTap: () async{
                      await _pickImage().then(
                        (value) {
                          Provider.of<MyImageProvider>(context, listen: false).myImage = value;
                        }
                      );
                    },
                    child: Stack(
                      children: [
                        FadedScaleAnimation(
                          CircleAvatar(
                            radius: 60,
                            //backgroundImage: (_myImage == null) ? AssetImage('assets/images/Layer1677.png') : Container(child: Image.file(_myImage, fit: BoxFit.cover,),),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 2
                                )
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: (_pickedImage == null)
                                  ? (image == "null")
                                    ? Image.asset('assets/images/Layer1677.png', width: 128, height: 128,)
                                    : Image.network(image, width: 128, height: 128,)
                                  : Image.file(_pickedImage, width: 128, height: 128,)
                              ),
                            )
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 6,
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Radio(
                                activeColor: Colors.red,
                                value: 0,
                                groupValue: _radioValue,
                                onChanged: (dynamic value) {
                                  print("male $value");
                                  Provider.of<MyGenderProvider>(context, listen: false).myValue = value;
                                },
                                focusColor: Colors.amberAccent,
                              ),
                              Text(
                                'Male',
                                style: Theme.of(context).textTheme.headline5?.copyWith(
                                    fontSize: 20
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Radio(
                                activeColor: Colors.red,
                                value: 1,
                                groupValue: _radioValue,
                                onChanged: (dynamic value) {
                                  print("female $value");
                                  Provider.of<MyGenderProvider>(context, listen: false).myValue = value;
                                },
                                focusColor: Colors.amberAccent,
                              ),
                              Text(
                                'Female',
                                style: Theme.of(context).textTheme.headline5?.copyWith(
                                    fontSize: 20
                                ),
                              ),
                            ],
                          ),
                        ],
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
                      onTap: () async {
                        //print(nameTextController.text);
                        var gender = "";
                        switch (_radioValue){
                          case 0:
                            gender = "Male";
                            break;
                          case 1:
                            gender = "Female";
                            break;
                        }
                        //print("gender ${gender!}");
                        await Provider.of<UserProvider>(context, listen: false).updateUserInfo(
                          emailTextController.text,
                          nameTextController.text,
                          gender,
                          this._pickedImage
                        ).then(
                          (_) {
                            Provider.of<MyImageProvider>(context, listen: false).myImage = null;
                          }
                        );
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

  Future<dynamic> _pickImage() async{
    try {
      final ImagePicker _picker = ImagePicker();
      XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
      if(pickedImage == null) {
        return null;
      }
      else{
        final image = File(pickedImage.path);
        return image;
      }
    }
    on PlatformException catch(error) {
      print("error while picking image: ${error.toString()}");
    }
  }
}
