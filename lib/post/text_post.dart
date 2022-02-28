import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  void initState() {

    Provider.of<TweetsProvider>(context, listen: false).createTweet(tweetTextController.text);

    super.initState();
  }


  TextEditingController tweetTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);





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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: FadedScaleAnimation(
                      Image.asset('assets/images/Layer884.png')),
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
                    child: Icon(
                      Icons.camera_alt,
                      color: theme.primaryColor,
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
                      await Provider.of<TweetsProvider>(context, listen: false).createTweet(tweetTextController);

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
