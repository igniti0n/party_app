import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:party/respositories/user_respository.dart';

import '../../screens/visiting_user_screen.dart';
import '../../services/FirebaseAuthService.dart';
import '../../services/FirebaseFirestoreService.dart';
import '../../constants.dart';
import '../../data/models/user.dart';

import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';

class UserAddingScreen extends StatefulWidget {
  const UserAddingScreen({Key key}) : super(key: key);

  @override
  _UserAddingScreenState createState() => _UserAddingScreenState();
}

class _UserAddingScreenState extends State<UserAddingScreen> {
  final GlobalKey<State> _futureKey = new GlobalKey<State>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String _requestId = "";

  @override
  void dispose() {
    super.dispose();
    _formKey.currentState?.dispose();
    _futureKey.currentState?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    final MediaQueryData _mediaData = MediaQuery.of(context);
    final User _currentUser = Provider.of<UserRepository>(context).user;

    //log("UsrAddWidg:    ${_currentUser}");
    // log("UsrAddWidg:    ${_currentUser.friendRequests}");

    void _tryToAddUser() async {
      if (_formKey.currentState.validate()) {
        print(_formKey.currentContext.widget.toStringDeep());

        _formKey.currentState.save();

        if (_currentUser.uid == _requestId) {
          print("NEMOŽEŠ SAM SEBI SLAT ZAHTIJEV");
          return;
        }

        if (_currentUser.friendRequests.contains(_requestId)) {
          print("TAJ KORISNIK JE VEĆ POSLAO ZAHTJEV VAMA");
          return;
        }

        final User _userToSendRequestTo =
            await Provider.of<FirebaseFirestoreService>(context, listen: false)
                .getUserData(_requestId);

        if (_userToSendRequestTo == null) {
          print("SEARCH ZA USERA JE NULL");
          return;
        }

        if (_userToSendRequestTo.friendRequests.contains(_currentUser.uid)) {
          print("VEĆ POSLAN ZAHTIJEV");
          return;
        }

        _userToSendRequestTo.friendRequests.add(_currentUser.uid);
        await Provider.of<FirebaseFirestoreService>(context, listen: false)
            .updateUserFriendRequest(
                _userToSendRequestTo.uid, _userToSendRequestTo.friendRequests);
      }
    }

    return Stack(
      children: [
        ...Constants.buildBackground(),
        SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 10, 20),
                child: Text(
                  Constants.textUserAddingScreen,
                  style: _theme.textTheme.bodyText1.copyWith(
                    color: Constants.kHelperTextColor,
                    fontSize: 16,
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: TextFormField(
                    onSaved: (id) {
                      _requestId = id;
                    },
                    validator: (text) {
                      return null;
                    },
                    maxLines: 1,
                    toolbarOptions: ToolbarOptions(
                      copy: true,
                      cut: true,
                      paste: true,
                      selectAll: true,
                    ),
                    style: _theme.textTheme.headline1,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      disabledBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              Divider(
                height: 2,
                thickness: 1,
                endIndent: _mediaData.size.width > 800 ? 100 : 60,
                color: Colors.blueGrey.shade300,
                indent: _mediaData.size.width > 800 ? 100 : 60,
              ),
              SendRequestButton(
                mediaData: _mediaData,
                theme: _theme,
                onTap: _tryToAddUser,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: Column(children: [
                  Text(
                    "Your Party ID:",
                    style: _theme.textTheme.headline1.copyWith(
                      color: Constants.kHelperTextColor,
                      fontSize: 17,
                    ),
                  ),
                  SelectableText(
                    "${_currentUser.uid}",
                    style: _theme.textTheme.headline1.copyWith(
                      color: Constants.kHelperTextColor,
                      fontSize: 17,
                    ),
                  ),
                ]),
              ),
              Text(
                "Your Friend Requests",
                style: _theme.textTheme.headline1.copyWith(
                  // color: Constants.kHelperTextColor,
                  fontSize: 17,
                ),
              ),
              Divider(
                height: 2,
                thickness: 1.5,
                endIndent: _mediaData.size.width * 0.1,
                color: Colors.blueGrey.shade300,
                indent: _mediaData.size.width * 0.1,
              ),
              RequestsListWidget(
                  mediaData: _mediaData,
                  futureKey: _futureKey,
                  currentUser: _currentUser,
                  theme: _theme),
              Divider(
                height: 2,
                thickness: 1.5,
                endIndent: _mediaData.size.width * 0.1,
                color: Colors.blueGrey.shade300,
                indent: _mediaData.size.width * 0.1,
              ),
              SizedBox(
                height: 4,
              ),
              TextButton(
                child: Text("User Settings"),
                onPressed: () {},
              ),
              TextButton(
                child: Text("Log out"),
                onPressed: () {
                  Provider.of<FirebaseAuthService>(context, listen: false)
                      .logOut();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class RequestsListWidget extends StatefulWidget {
  const RequestsListWidget({
    Key key,
    @required MediaQueryData mediaData,
    @required GlobalKey<State<StatefulWidget>> futureKey,
    @required User currentUser,
    @required ThemeData theme,
  })  : _mediaData = mediaData,
        _futureKey = futureKey,
        _currentUser = currentUser,
        _theme = theme,
        super(key: key);

  final MediaQueryData _mediaData;
  final GlobalKey<State<StatefulWidget>> _futureKey;
  final User _currentUser;
  final ThemeData _theme;

  @override
  _RequestsListWidgetState createState() => _RequestsListWidgetState();
}

class _RequestsListWidgetState extends State<RequestsListWidget> {
  //TODO:LOOK TO REMOVE THIS
  void _onRequestRemoved() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // log("ReqWidg:    ${widget._currentUser}");
    // log("ReqWidg:    ${widget._currentUser.friendRequests}");
    return Container(
      height: widget._mediaData.size.height * 0.2,
      child: FutureBuilder(
          key: widget._futureKey,
          future: Provider.of<FirebaseFirestoreService>(context, listen: false)
              .getAllUsersFromList(widget._currentUser.friendRequests ?? []),
          initialData: [],
          builder: (cntx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Constants.displayLoadingSpinner();
            } else {
              final List<User> _data = (snapshot.data as List<User>) ?? [];
              print("Users request: $_data");
              print("CURRENT friendReq: ${widget._currentUser.friendRequests}");

              return ListView.builder(
                itemCount: widget._currentUser.friendRequests == null
                    ? 0
                    : widget._currentUser.friendRequests.length,
                itemBuilder: (ctx, index) {
                  return RequestTile(
                    onRemovingRequest: _onRequestRemoved,
                    currentUser: widget._currentUser,
                    theme: widget._theme,
                    mediaData: widget._mediaData,
                    sendingUser: _data.elementAt(index),
                    shouldAddDivider: index ==
                            (widget._currentUser.friendRequests == null
                                    ? 0
                                    : widget
                                        ._currentUser.friendRequests.length) -
                                1
                        ? false
                        : true,
                  );
                },
              );
            }
          }),
    );
  }
}

class RequestTile extends StatelessWidget {
  RequestTile({
    Key key,
    @required this.sendingUser,
    @required this.mediaData,
    @required this.shouldAddDivider,
    @required this.theme,
    @required this.currentUser,
    this.onRemovingRequest,
  }) : super(key: key);
  final User sendingUser;
  final MediaQueryData mediaData;
  final bool shouldAddDivider;
  final ThemeData theme;
  final User currentUser;
  final Function() onRemovingRequest;

  final TapGestureRecognizer _recognizer = TapGestureRecognizer();

  @override
  Widget build(BuildContext context) {
    _recognizer.onTap = () {
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (ctx) => ChangeNotifierProvider.value(
                value: Provider.of<UserRepository>(context, listen: false),
                child: VisitingUserScreen(
                  currentUser: currentUser,
                  visitingUser: sendingUser,
                ),
              )));
    };

    return Column(
      children: [
        Container(
          height: mediaData.size.height < 600
              ? mediaData.size.height * 0.075
              : mediaData.size.height * 0.05,
          width: mediaData.size.width * 0.8,
          padding: EdgeInsets.fromLTRB(2, 3, 2, 3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(
                flex: 2,
                child: Container(
                  child: RichText(
                    text: TextSpan(
                      text: '${sendingUser.username} ',
                      recognizer: _recognizer,
                      style: theme.textTheme.bodyText1
                          .copyWith(fontWeight: FontWeight.w600),
                      children: [
                        TextSpan(
                          text: ' wants to party !',
                          style: theme.textTheme.bodyText1,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RequestTileButton(
                      mediaData: mediaData,
                      onTap: () async {
                        try {
                          currentUser.friends.add(sendingUser.uid);
                          sendingUser.friends.add(currentUser.uid);
                          currentUser.friendRequests.remove(sendingUser.uid);
                          await Provider.of<FirebaseFirestoreService>(context,
                                  listen: false)
                              .updateUserFriends(
                                  userTobeSent: currentUser.uid,
                                  value: currentUser.friends);
                          await Provider.of<FirebaseFirestoreService>(context,
                                  listen: false)
                              .updateUserFriends(
                                  userTobeSent: sendingUser.uid,
                                  value: sendingUser.friends);
                          await Provider.of<FirebaseFirestoreService>(context,
                                  listen: false)
                              .updateUserFriendRequest(
                                  currentUser.uid, currentUser.friendRequests);
                          onRemovingRequest();
                        } catch (error) {
                          print("ERRO OCCURED: ${error.toString()}");
                        }
                      },
                      theme: theme,
                      isAdding: true,
                    ),
                    RequestTileButton(
                      mediaData: mediaData,
                      onTap: () async {
                        currentUser.friendRequests.remove(sendingUser.uid);
                        await Provider.of<FirebaseFirestoreService>(context,
                                listen: false)
                            .updateUserFriendRequest(
                                currentUser.uid, currentUser.friendRequests);
                        onRemovingRequest();
                      },
                      theme: theme,
                      isAdding: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (shouldAddDivider)
          Divider(
            height: 2,
            thickness: 2,
            endIndent: mediaData.size.width > 800 ? 100 : 60,
            color: Colors.grey[300],
            indent: mediaData.size.width > 800 ? 100 : 60,
          ),
      ],
    );
  }
}

class RequestTileButton extends StatelessWidget {
  const RequestTileButton({
    Key key,
    @required this.mediaData,
    @required this.theme,
    @required this.isAdding,
    @required this.onTap,
  }) : super(key: key);

  final MediaQueryData mediaData;
  final ThemeData theme;
  final bool isAdding;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: mediaData.size.width * 0.4,
      // padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: isAdding
            ? Constants.kButtonColor
            : Color.fromRGBO(255, 142, 142, 1),
        borderRadius: BorderRadius.all(Radius.circular(8)),
        border: Border.all(color: Color.fromRGBO(97, 92, 92, 1), width: 2),
        // boxShadow: [
        //   BoxShadow(offset: Offset(0, 1), color: Colors.black, blurRadius: 1)
        // ],
      ),

      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Image.asset(isAdding
                ? 'assets/icons/addUser-filled.png'
                : 'assets/icons/removeUser-filled.png'),
          ),
        ),
      ),
    );
  }
}

class SendRequestButton extends StatelessWidget {
  const SendRequestButton({
    Key key,
    @required this.mediaData,
    @required this.theme,
    @required this.onTap,
  }) : super(key: key);

  final MediaQueryData mediaData;
  final ThemeData theme;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        //width: mediaData.size.width * 0.4,
        // height: mediaData.size.height * 0.1,
        decoration: BoxDecoration(
          color: Constants.kButtonColor,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          border: Border.all(color: Color.fromRGBO(97, 92, 92, 1), width: 2),
          boxShadow: [
            BoxShadow(offset: Offset(0, 1), color: Colors.black, blurRadius: 1)
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AutoSizeText(
                'Send Friend Request',
                textAlign: TextAlign.center,
                style: theme.textTheme.headline1.copyWith(
                  color: Constants.kPurpleButtonTextColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
