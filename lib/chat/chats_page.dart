import 'package:flutter/material.dart';
import 'package:verbose_share_world/app_theme/application_colors.dart';
import 'package:verbose_share_world/chat/chat_friend_tab.dart';
import 'package:verbose_share_world/chat/chat_group_tab_screen.dart';


class ChatsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: TabBar(
          physics: BouncingScrollPhysics(),
          isScrollable: true,
          indicatorColor: theme.primaryColor,
          labelColor: theme.primaryColor,
          unselectedLabelColor: ApplicationColors.black,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: [
            Tab(text: 'Friends'),
            Tab(text: 'Groups'),
          ],
        ),
        body: TabBarView(
          physics: BouncingScrollPhysics(),
          children: [
            ChatFriendTabScreen(),
            ChatGroupTabScreen(),
          ],
        ),
      ),
    );
  }
}
