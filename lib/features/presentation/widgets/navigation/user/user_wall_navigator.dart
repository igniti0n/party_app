import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../constants.dart';
import '../../../../data/datasources/FirebaseFirestoreService.dart';
import '../../../../data/models/user.dart';

class UserWallNavigator extends StatefulWidget {
  final Size availableSize;
  final Function(bool) onTapChange;
  final bool isCreated;
  final User userToBeDisplayed;
  final User logedUser;
  const UserWallNavigator({
    Key key,
    @required this.availableSize,
    @required this.onTapChange,
    @required this.isCreated,
    @required this.userToBeDisplayed,
    @required this.logedUser,
  }) : super(key: key);

  @override
  _UserWallNavigatorState createState() => _UserWallNavigatorState();
}

class _UserWallNavigatorState extends State<UserWallNavigator> {
  @override
  Widget build(BuildContext context) {
    final _buttonsHeight = widget.availableSize.height * 0.16;
    final _theme = Theme.of(context);

    final _style = _theme.textTheme.headline1;
    final _styleUserSpecifics =
        _theme.textTheme.headline1.copyWith(fontSize: 15);
    final _iconsSize = widget.availableSize.height * 0.13;

    FriendshipStatus _friendshipStatus = FriendshipStatus.NotFriends;

    if (widget.userToBeDisplayed.friends.contains(widget.logedUser.uid)) {
      _friendshipStatus = FriendshipStatus.Friends;
    } else if (widget.userToBeDisplayed.friendRequests
        .contains(widget.logedUser.uid)) {
      _friendshipStatus = FriendshipStatus.Pending;
    }

    Future<void> _removeFriend() async {
      _friendshipStatus = FriendshipStatus.NotFriends;
      widget.logedUser.friends.remove(widget.userToBeDisplayed.uid);
      await Provider.of<FirebaseFirestoreService>(context, listen: false)
          .updateUserFriends(
        userTobeSent: widget.logedUser.uid,
        value: widget.logedUser.friends,
      );

      widget.userToBeDisplayed.friends.remove(widget.logedUser.uid);
      await Provider.of<FirebaseFirestoreService>(context, listen: false)
          .updateUserFriends(
        userTobeSent: widget.userToBeDisplayed.uid,
        value: widget.userToBeDisplayed.friends,
      );
      setState(() {});
      print("REMOVING FRIEND.....");
    }

    Future<void> _updateFriendRequests() async {
      await Provider.of<FirebaseFirestoreService>(context, listen: false)
          .updateUserFriendRequest(
        widget.userToBeDisplayed.uid,
        widget.userToBeDisplayed.friendRequests,
      );
      setState(() {});
      print("UPDATING:: ${widget.userToBeDisplayed.friendRequests}");
    }

    return Container(
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  // color: Colors.red,
                  alignment: Alignment.center,
                  width: widget.availableSize.width / 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: widget.availableSize.height / 4.5,
                        backgroundImage:
                            NetworkImage(widget.userToBeDisplayed.imageUrl),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.userToBeDisplayed.username,
                          style: _style,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  // color: Colors.blue,
                  width: widget.availableSize.width / 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Row(
                          children: [
                            Container(
                              height: _iconsSize,
                              width: _iconsSize,
                              child:
                                  Image.asset('assets/icons/partyFriends.png'),
                            ),
                            //:TODO - deal with high numbers
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                ' ${widget.userToBeDisplayed.friends.length} party friends',
                                style: _styleUserSpecifics,
                              ),
                            )
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Row(
                          children: [
                            Container(
                              height: _iconsSize,
                              width: _iconsSize,
                              child:
                                  Image.asset('assets/icons/party-filled.png'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                ' ${widget.userToBeDisplayed.createdPartyIds.length} parties created',
                                style: _styleUserSpecifics,
                              ),
                            )
                          ],
                        ),
                      ),
                      if (widget.userToBeDisplayed.uid != widget.logedUser.uid)
                        Flexible(
                          flex: 1,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: AddFriendButton(
                              friendshipStatus: _friendshipStatus,
                              onTap: () async {
                                // userToBeDisplayed.friendRequests.clear();
                                if (_friendshipStatus !=
                                    FriendshipStatus.Friends) {
                                  if (_friendshipStatus ==
                                      FriendshipStatus.Pending) {
                                    widget.userToBeDisplayed.friendRequests
                                        .remove(widget.logedUser.uid);
                                    _friendshipStatus =
                                        FriendshipStatus.NotFriends;
                                  } else {
                                    widget.userToBeDisplayed.friendRequests
                                        .add(widget.logedUser.uid);
                                    _friendshipStatus =
                                        FriendshipStatus.Pending;
                                  }
                                  await _updateFriendRequests();
                                } else {
                                  await _removeFriend();

                                  _friendshipStatus =
                                      FriendshipStatus.NotFriends;
                                }
                              },
                              // availableHeight: _iconsSize / 1,
                              //width: this.widget.availableSize.width / 3,
                              visitingUser: widget.userToBeDisplayed,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            //height: availableSize.height * 0.3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                  flex: 1,
                  child: UserNavigationButton(
                    widget: widget,
                    buttonsHeight: _buttonsHeight,
                    style: _style,
                    text: 'created',
                    changeValue: true,
                    color: widget.isCreated ? null : Colors.grey[400],
                    textColor: widget.isCreated ? null : Colors.grey[700],
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: UserNavigationButton(
                    widget: widget,
                    buttonsHeight: _buttonsHeight,
                    style: _style,
                    color: widget.isCreated ? Colors.grey[400] : null,
                    textColor: widget.isCreated ? Colors.grey[700] : null,
                    text: 'attended',
                    changeValue: false,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UserNavigationButton extends StatelessWidget {
  const UserNavigationButton({
    Key key,
    @required this.widget,
    @required double buttonsHeight,
    @required TextStyle style,
    @required this.text,
    @required this.color,
    @required this.textColor,
    @required this.changeValue,
  })  : _buttonsHeight = buttonsHeight,
        _style = style,
        super(key: key);

  final UserWallNavigator widget;

  final double _buttonsHeight;
  final TextStyle _style;
  final String text;
  final Color color;
  final Color textColor;
  final bool changeValue;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTapChange(changeValue),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
          ),
        ),
        height: _buttonsHeight,
        child: Center(
            child: Text(
          text,
          style: _style.copyWith(color: textColor),
          textAlign: TextAlign.center,
        )),
      ),
    );
  }
}

class AddFriendButton extends StatefulWidget {
  // final availableHeight;
  // final double width;
  final Function() onTap;

  final User visitingUser;
  final FriendshipStatus friendshipStatus;
  const AddFriendButton({
    Key key,
    // @required this.availableHeight,
    // @required this.width,
    @required this.onTap,
    @required this.visitingUser,
    @required this.friendshipStatus,
  }) : super(key: key);

  @override
  _AddFriendButtonState createState() => _AddFriendButtonState();
}

class _AddFriendButtonState extends State<AddFriendButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: widget.availableHeight,
      //width: widget.width,

      decoration: BoxDecoration(
        color: widget.friendshipStatus == FriendshipStatus.NotFriends
            ? Constants.kButtonColor
            : Colors.grey[400],
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          splashFactory: InkSplash.splashFactory,
          splashColor: widget.friendshipStatus != FriendshipStatus.NotFriends
              ? Colors.red[300]
              : null,
          onTap: () {
            widget.onTap();
          },
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                    widget.friendshipStatus == FriendshipStatus.NotFriends
                        ? 'assets/icons/addUser-filled.png'
                        : widget.friendshipStatus == FriendshipStatus.Pending
                            ? 'assets/icons/checkmark.png'
                            : 'assets/icons/removeUser-filled.png'),
                AutoSizeText(
                  widget.friendshipStatus == FriendshipStatus.NotFriends
                      ? '    Add Friend'
                      : widget.friendshipStatus == FriendshipStatus.Pending
                          ? '    Invite Sent'
                          : '   You\'r friends',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline1.copyWith(
                        fontSize: 16,
                        color: widget.friendshipStatus ==
                                FriendshipStatus.NotFriends
                            ? Colors.white
                            : Colors.black,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
