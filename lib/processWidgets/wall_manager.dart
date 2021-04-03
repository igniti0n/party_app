import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:party/respositories/user_respository.dart';

import '../screens/navigation_screens/user_adding_screen.dart';
import '../constants.dart';
import '../data/models/user.dart';
import '../screens/navigation_screens/user_wall.dart';
import '../screens/navigation_screens/party_creation_screens/party_creation_screens_manager.dart';
import '../widgets/party_navigation_bar.dart';
import '../screens/navigation_screens/news_feed.dart';

import 'package:provider/provider.dart';

class WallManager extends StatelessWidget {
  const WallManager({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User _user = Provider.of<UserRepository>(context, listen: false).user;

    log("Wll MANAGER: ${_user}");

    //print("CREATED PARTIES: ${_user.createdPartyIds},  ${_user.username}");

    return Scaffold(
      appBar: MyAppBar(),
      resizeToAvoidBottomInset: false,
      body: PartyNavigationBar(
        screens: [
          NewsFeed(),
          Container(),
          UserWall(
            visitingUser: _user,
          ),
          UserAddingScreen(),
        ],
        onIndexChanged: (currentIndex) {
          if (currentIndex == 1) {
            Navigator.of(context).push(new MaterialPageRoute(
              builder: (ctx) {
                return PartyCreationScreensManager(
                  userData: _user,
                );
              },
              fullscreenDialog: true,
            ));
            return true;
          }
          print('index: $currentIndex');
          return false;
        },
      ),
    );
  }
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  MyAppBar({Key key}) : super(key: key);

  Size _size = Size(double.infinity, 80);

  @override
  Widget build(BuildContext context) {
    final _media = MediaQuery.of(context);
    final _appBarHeight =
        (_media.size.height / 11) + _media.viewPadding.top * 0.6;
    _size = Size(_media.size.width, _appBarHeight);

    final TextStyle _style =
        Theme.of(context).textTheme.headline1.copyWith(color: Colors.white70);

    return Container(
      alignment: Alignment.bottomCenter,
      width: preferredSize.width,
      height: preferredSize.height,
      color: Constants.kDarkGeneralColor,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            20, (_appBarHeight - _media.viewPadding.top) * 0.4, 20, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Parties in your city',
              style: _style,
            ),
            Icon(
              Icons.more_vert,
              size: (_appBarHeight - _media.viewPadding.top * 0.6) * 0.5,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(
        double.infinity,
        _size.height,
      );
}
