import 'package:flutter/material.dart';

import '../data/models/party.dart';
import '../data/models/user.dart';
import '../widgets/purple_button.dart';
import '../services/FirebaseFirestoreService.dart';

import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:auto_size_text/auto_size_text.dart';

class PartyDetailScreen extends StatelessWidget {
  static final routeName = '/partyDetailScreen';
  const PartyDetailScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _media = MediaQuery.of(context);
    final _theme = Theme.of(context);
    final double _availableHeight =
        _media.size.height - _media.viewInsets.top - _media.viewPadding.top;
    final Map<String, dynamic> _arguments =
        ModalRoute.of(context).settings.arguments as Map<String, Object>;
    final Party _party = _arguments['party'] as Party;
    final User _currentUser = _arguments['currentUser'] as User;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          SingleChildScrollView(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                Container(
                  width: _media.size.width,
                  height: _availableHeight * 0.35,
                  child: Image.network(
                    _party.imageUrl,
                    fit: BoxFit.fill,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 24, 4, 0),
                  child: AutoSizeText(_party.title,
                      style: _theme.textTheme.headline1.copyWith(fontSize: 25)),
                ),
                Divider(
                  thickness: 1,
                  endIndent: 20,
                  color: Colors.blueGrey.shade300,
                  indent: 20,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                  child: Text(
                    _party.description,
                    style: _theme.textTheme.bodyText1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 12, 4, 0),
                  child: AutoSizeText('Party Location',
                      style: _theme.textTheme.headline1.copyWith(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w400)),
                ),
                Divider(
                  thickness: 1,
                  endIndent: 20,
                  color: Colors.blueGrey.shade300,
                  indent: 20,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/location.png',
                        height: 44,
                      ),
                      AutoSizeText(_party.address,
                          style: _theme.textTheme.bodyText1.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 17)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 22, 4, 0),
                  child: AutoSizeText('Party Specifics',
                      style: _theme.textTheme.headline1.copyWith(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w400)),
                ),
                Divider(
                  thickness: 1,
                  endIndent: 20,
                  color: Colors.blueGrey.shade300,
                  indent: 20,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        'assets/icons/time.png',
                        height: 34,
                      ),
                      AutoSizeText(
                        DateFormat.Hm().format(_party.timeOfTheParty) +
                            '      ',
                        style: _theme.textTheme.bodyText1.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                      Image.asset(
                        'assets/icons/calendar.png',
                        height: 34,
                      ),
                      AutoSizeText(
                          DateFormat.yMEd().format(_party.timeOfTheParty),
                          style: _theme.textTheme.bodyText1.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 17)),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        'assets/icons/drinks.png',
                        height: 34,
                      ),
                      AutoSizeText(
                        _party.drinks.toString().replaceRange(0, 7, ''),
                        style: _theme.textTheme.bodyText1.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                      Image.asset(
                        'assets/icons/music.png',
                        height: 34,
                      ),
                      AutoSizeText(
                          _party.music.toString().replaceRange(0, 6, ''),
                          style: _theme.textTheme.bodyText1.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 17)),
                    ],
                  ),
                ),
                if (_currentUser.uid != _party.partyCreatorId)
                  SizedBox(
                    height: 100,
                  )
              ],
            ),
          ),
          Positioned(
            top: _availableHeight * 0.07,
            left: _media.size.width * 0.04,
            child: IconButton(
              color: Colors.white,
              icon: Icon(
                Icons.arrow_back,
                size: 40,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          if (_currentUser.uid != _party.partyCreatorId)
            Positioned(
              bottom: 26,
              left: _media.size.width / 4.6,
              child: AttendanceButton(
                media: _media,
                theme: _theme,
                currentUser: _currentUser,
                party: _party,
              ),
            ),
        ],
      ),
    );
  }
}

class AttendanceButton extends StatefulWidget {
  AttendanceButton({
    Key key,
    @required MediaQueryData media,
    @required ThemeData theme,
    @required Party party,
    @required User currentUser,
  })  : _media = media,
        _theme = theme,
        _party = party,
        _currentUser = currentUser,
        super(key: key);

  final MediaQueryData _media;
  final ThemeData _theme;
  final Party _party;

  final User _currentUser;

  @override
  _AttendanceButtonState createState() => _AttendanceButtonState();
}

class _AttendanceButtonState extends State<AttendanceButton> {
  bool _isComing;

  @override
  Widget build(BuildContext context) {
    _isComing = widget._party.peopleComing.contains(widget._currentUser.uid);

    void _addUserToParty() async {
      widget._party.peopleComing.add(widget._currentUser.uid);
      widget._currentUser.attendedPartyIds.add(widget._party.partyId);
      await Provider.of<FirebaseFirestoreService>(context, listen: false)
          .updatePartyPeopleComing(
              widget._party.partyId, widget._party.peopleComing);
      await Provider.of<FirebaseFirestoreService>(context, listen: false)
          .updateUserAttendedParties(
              widget._currentUser.uid, widget._currentUser.attendedPartyIds);
      setState(() {
        _isComing = true;
      });
    }

    void _removeUserFromParty() async {
      widget._party.peopleComing.remove(widget._currentUser.uid);
      widget._currentUser.attendedPartyIds.remove(widget._party.partyId);
      await Provider.of<FirebaseFirestoreService>(context, listen: false)
          .updatePartyPeopleComing(
              widget._party.partyId, widget._party.peopleComing);
      await Provider.of<FirebaseFirestoreService>(context, listen: false)
          .updateUserAttendedParties(
              widget._currentUser.uid, widget._currentUser.attendedPartyIds);
      setState(() {
        _isComing = false;
      });
    }

    return PurpleButton(
      text: _isComing ? 'Can\'t make it' : 'I am coming!',
      isPurple: !_isComing,
      media: widget._media,
      theme: widget._theme,
      useSplashDelay: false,
      onTap: () {
        if (_isComing) {
          _removeUserFromParty();
        } else {
          _addUserToParty();
        }
      },
    );
  }
}
