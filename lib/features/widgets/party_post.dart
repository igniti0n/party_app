import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../data/models/user.dart';
import '../screens/party_detail_screen.dart';
import '../screens/visiting_user_screen.dart';
import '../services/FirebaseFirestoreService.dart';
import '../data/models/party.dart';

class PartyPost extends StatefulWidget {
  final Party party;
  final bool isUserWall;
  final User currentUser;
  const PartyPost(
      {Key key,
      @required this.party,
      this.isUserWall = false,
      this.currentUser})
      : super(key: key);

  @override
  _PartyPostState createState() => _PartyPostState();
}

class _PartyPostState extends State<PartyPost> {
  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    final _postSize = _size.height / 1.265;
    final _detailSize = _postSize * 0.50;
    final _theme = Theme.of(context);

    //final User widget.currentUser = Provider.of<User>(context, listen: false);

    void _goToProfile() async {
      final User _userToGoTo =
          await Provider.of<FirebaseFirestoreService>(context, listen: false)
              .getUserData(widget.party.partyCreatorId);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => VisitingUserScreen(
                visitingUser: _userToGoTo,
                currentUser: widget.currentUser,
              )));
    }

    final TapGestureRecognizer _recognizer = TapGestureRecognizer()
      ..onTap = _goToProfile;

    return Container(
      width: double.infinity,
      color: Colors.grey[200],
      // decoration: BoxDecoration(
      //     color: Colors.amber[400],
      //     border: Border(bottom: BorderSide(width: 1))),
      height: _postSize,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (!widget.isUserWall)
            Container(
              height: _postSize * 0.10,
              width: double.infinity,
              child: Row(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        widget.party.partyCreatorImageUrl,
                      ),
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      text: '${widget.party.partyCreatorUsername} ',
                      recognizer: _recognizer,
                      style: _theme.textTheme.bodyText1
                          .copyWith(fontWeight: FontWeight.w800),
                      children: [
                        TextSpan(
                          text: 'is organising an event',
                          style: _theme.textTheme.bodyText1,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          Container(
            width: double.infinity,
            height: _postSize * (widget.isUserWall ? 0.46 : 0.42),
            child: FittedBox(
              fit: BoxFit.fill,
              child: !widget.party.imageUrl.startsWith('http')
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Image.network(widget.party.imageUrl),
            ),
          ),
          Expanded(
            // child: Container(
            //   height: _detailSize,
            //   width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                  child: AutoSizeText(
                    widget.party.title,
                    maxLines: 1,
                    style: _theme.textTheme.headline1.copyWith(fontSize: 25),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Image.asset(
                            'assets/icons/peopleComing.png',
                            // height: _detailSize * 0.13,
                          ),
                        ),
                        AutoSizeText(
                          '${widget.party.peopleComing?.length} people coming',
                          style: _theme.textTheme.bodyText1,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Image.asset(
                            'assets/icons/calendar.png',
                            // height: _detailSize * 0.11,
                          ),
                        ),
                        AutoSizeText(
                          DateFormat.yMEd().format(widget.party.timeOfTheParty),
                          style: _theme.textTheme.bodyText1,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Center(
                      child: AutoSizeText(
                        '"${widget.party.slogan}"',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.fade,
                        style: _theme.textTheme.headline1.copyWith(
                          fontSize: 19,
                          color: Colors.grey[900],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 2),
                  height: _detailSize * 0.15,
                  width: _size.width * 0.9,
                  decoration: BoxDecoration(
                      border: Border.symmetric(
                          horizontal: BorderSide(color: Colors.grey))),
                  alignment: Alignment.center,
                  // child: Column(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context)
                        .pushNamed(PartyDetailScreen.routeName, arguments: {
                      'party': widget.party,
                      'currentUser': widget.currentUser,
                    }),
                    child: AutoSizeText(
                      'View Party Details',
                      textAlign: TextAlign.center,
                      style: _theme.textTheme.bodyText1.copyWith(fontSize: 20),
                    ),
                  ),
                  //   ),
                  // ],
                  //),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (widget.party.likes
                                .contains(widget.currentUser.uid)) {
                              //  print('YES IT COINTAINS IT');
                              widget.party.likes.remove(widget.currentUser.uid);
                            } else {
                              //  print('noooooooooooope');
                              widget.party.likes.add(widget.currentUser.uid);
                            }
                            setState(() {
                              Provider.of<FirebaseFirestoreService>(context,
                                      listen: false)
                                  .updatePartyLikes(
                                widget.party.partyId,
                                widget.party.likes,
                              );
                            });

                            print(widget.party.likes);
                          },
                          child: Image.asset(
                            widget.party.likes.contains(widget.currentUser.uid)
                                ? 'assets/icons/liver-filled.png'
                                : 'assets/icons/liver-empty.png',
                            // height: _detailSize * 0.13,
                          ),
                        ),
                        Container(
                          width: _size.width * 0.7,
                          //height: _detailSize * 0.13,
                          child: AutoSizeText(
                            widget.party.likes.contains(widget.currentUser.uid)
                                ? 'You and ${widget.party.likes.length - 1} people wreckd liver for this party !'
                                : 'Your liver is safe from this party',
                            textAlign: TextAlign.left,
                            maxLines: 1,
                            style: _theme.textTheme.bodyText1.copyWith(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                        // AutoSizeText(
                        //   DateFormat.yMMMd().format(widget.party.createdAt),
                        //   style: _theme.textTheme.bodyText1,
                        // )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          //)
        ],
      ),
    );
  }
}
