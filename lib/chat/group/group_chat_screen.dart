import 'dart:math';
import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:verbose_share_world/app_theme/application_colors.dart';


import 'group_info.dart';

class GroupChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> messages = [
      {"Emili Williamson": "Hello Everyone"},
      {
        "john Taylor": "hey Emili",
      },
      {"you": "hey Friends good To See You All"},
      {
        "john Taylor":
            "samantha I Must Say Your Pictures Are So Beautiful"
      },
      {"you": "ohThanksJohn"},
    ];
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final myAppBar = AppBar(
      elevation: 0,
      backgroundColor: ApplicationColors.white,
      title: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => GroupInfoScreen()));
        },
        child: Transform(
          transform: Matrix4.translationValues(-25, 0, 0),
          child: Row(
            children: [
              Container(
                height: 30,
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: FadedScaleAnimation(
                  Image.asset(
                    'assets/images/profile_pics/Layer1550.png',
                    scale: 2,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Text(
                'Keylin Taylor',
                style: theme.textTheme.headline6!
                    .copyWith(fontWeight: FontWeight.w500, fontSize: 16.7),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'is Typing...',
                style: theme.textTheme.subtitle2!
                    .copyWith(color: theme.hintColor, fontSize: 11.7),
              )
            ],
          ),
        ),
      ),
      leading: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Icon(Icons.chevron_left),
      ),
    );
    final bHeight = mediaQuery.size.height -
        mediaQuery.padding.top -
        myAppBar.preferredSize.height;
    return Scaffold(
      backgroundColor: ApplicationColors.white,
      appBar: myAppBar,
      body: FadedSlideAnimation(
        ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.all(10),
              height: bHeight * 0.89,
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment:
                        messages[index % messages.length].keys.toList()[0] ==
                                "you"
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 4, 10, 4),
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: messages[index % messages.length]
                                      .keys
                                      .toList()[0] ==
                                  "you"
                              ? theme.primaryColor
                              : ApplicationColors.lightGrey,
                        ),
                        // width: mediaQuery.size.width * 0.7,
                        width: messages[index % messages.length]
                                        .values
                                        .toList()[0]
                                        .split('\n')
                                        .map((e) => e.length)
                                        .toList()
                                        .reduce(max) *
                                    11.0 >=
                                mediaQuery.size.width * 0.7
                            ? mediaQuery.size.width * 0.7
                            : messages[index % messages.length]
                                    .values
                                    .toList()[0]
                                    .split('\n')
                                    .map((e) => e.length)
                                    .toList()
                                    .reduce(max) *
                                11.0,
                        alignment: messages[index % messages.length]
                                    .keys
                                    .toList()[0] ==
                                "you"
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: messages[index % messages.length]
                                      .keys
                                      .toList()[0] ==
                                  "you"
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Text(
                              messages[index % messages.length]
                                  .keys
                                  .toList()[0],
                              style: theme.textTheme.bodyText1!.copyWith(
                                fontSize: 8,
                                color: messages[index % messages.length]
                                            .keys
                                            .toList()[0] ==
                                        "you"
                                    ? ApplicationColors.white
                                    : theme.primaryColor,
                              ),
                              textAlign: messages[index % messages.length]
                                          .keys
                                          .toList()[0] ==
                                      "you"
                                  ? TextAlign.right
                                  : TextAlign.left,
                            ),
                            Text(
                              messages[index % messages.length]
                                  .values
                                  .toList()[0],
                              style: theme.textTheme.bodyText1!.copyWith(
                                fontSize: 13,
                                color: messages[index % messages.length]
                                            .keys
                                            .toList()[0] ==
                                        "you"
                                    ? ApplicationColors.white
                                    : ApplicationColors.black,
                              ),
                              textAlign: messages[index % messages.length]
                                          .keys
                                          .toList()[0] ==
                                      "you"
                                  ? TextAlign.right
                                  : TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Container(
              height: bHeight * 0.085,
              width: mediaQuery.size.width,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.emoji_emotions_outlined,
                    color: theme.hintColor,
                    size: 20,
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: mediaQuery.size.width * 0.7,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Write your comment",
                        hintStyle: TextStyle(
                          fontSize: 12,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.send,
                    color: theme.primaryColor,
                    size: 20,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }
}
