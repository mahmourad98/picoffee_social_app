
//import 'dart:html';
import 'dart:io';
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:picoffee/app_theme/application_colors.dart';
import 'package:picoffee/home/home.dart';
import 'package:picoffee/providers/ImageProvider.dart';
import 'package:picoffee/providers/TweetProvider.dart';
import 'package:provider/provider.dart';


class TextPostScreen extends StatefulWidget {
  @override
  _TextPostScreenState createState() => _TextPostScreenState();
}

class _TextPostScreenState extends State<TextPostScreen> {
 var _post_pic ;
 late var image;
  void initState() {

    Provider.of<TweetsProvider>(context, listen: false).createTweet(tweetTextController,_post_pic);
    image = Provider.of<TweetsProvider>(context, listen: false).imageUrl;
    super.initState();
  }


  TextEditingController tweetTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    _post_pic = Provider.of<MyImageProvider>(context, listen: true).myImage;

    final myAppbar = AppBar(
      backgroundColor: ApplicationColors.white,
      elevation: 0,
      title: Text('Create Post',
          style:
              theme.textTheme.headline6!.copyWith(fontWeight: FontWeight.w500)),
      leading: IconButton(
        icon: Icon(Icons.chevron_left),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
    final bheight = mediaQuery.size.height -
        mediaQuery.padding.top -
        myAppbar.preferredSize.height;
    return Scaffold(
      appBar: myAppbar,
      body: FadedSlideAnimation(
        Container(
          height: bheight,
          color: ApplicationColors.white,
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  FadedScaleAnimation(
                    CircleAvatar(
                      backgroundImage:
                          AssetImage('assets/images/Layer1677.png'),
                    ),
                  ),
                  SizedBox(width: 15),
                  SizedBox(
                    width: mediaQuery.size.width - 150,
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Write something to post',
                      ),
                      controller: tweetTextController,
                      // style: theme.textTheme.bodyText1.copyWith(color: Colors.grey),
                    ),
                  ),
                ],
              ),
              Spacer(),
              Expanded(
                flex: 20,
                child:ClipRRect (
                  //borderRadius: BorderRadius.circular(10),
                  child:  (_post_pic == null)
                   ? FadedScaleAnimation(Image.asset('assets/images/Layer884.png'))
                    : FadedScaleAnimation(Image.file(_post_pic))
                ),

              ),
              Spacer(),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: ApplicationColors.lightGrey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.fromLTRB(5, 0, 10, 5),
                    child: GestureDetector(
                      child: Icon(
                        Icons.camera_alt,
                        color: theme.primaryColor,
                      ),
                      onTap:() {
                       getImage();
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: ApplicationColors.lightGrey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.fromLTRB(5, 0, 10, 5),
                    child: GestureDetector(
                      child: Icon(
                        Icons.photo,
                        color: theme.primaryColor,
                      ),
                      onTap: () async{
                          await getImage().then((value) {
                          Provider.of<MyImageProvider>(context, listen: false).myImage = value;
                        print("value $value");
                          }
                          );
                       //   _post_pic =Provider.of<MyImageProvider>(context, listen: false).myImage ;
                      },
                    ),
                  ),
                ],
              ),

              GestureDetector(
                onTap: ()async {
                  if (tweetTextController.text.isEmpty ) {
                    BotToast.showSimpleNotification(
                        title: 'Cant post an Empty tweet ',
                        duration: Duration(seconds: 3));
                  }
                  else{
                      await Provider.of<TweetsProvider>(context, listen: false).createTweet(tweetTextController,_post_pic).then(
                              (_) {
                          //  Provider.of<MyImageProvider>(context, listen: false).myImage = null;
                          }
                      );

                      BotToast.showSimpleNotification(
                          title: 'Tweet posted successfully',
                          duration: Duration(seconds: 3));

                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
    }

                },
                child: Container(
                  margin: EdgeInsets.only(top: 15),
                  alignment: Alignment.center,
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Create Post',
                    style: theme.textTheme.button,
                  ),
                ),
              ),
            ],
          ),
        ),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }
}

Future<dynamic>  getImage() async{
  final ImagePicker _picker = ImagePicker();
  var image_pick = await _picker.pickImage(source: ImageSource.gallery);

  if(image_pick == null) {
    return null;
  }
  else{
    final image = File(image_pick.path);
    return image;
  }}

