import 'dart:io';

import 'package:party/data/models/user.dart';
import 'package:flutter/material.dart';

import '../party_creation_screens/party_creation_screen_title.dart';
import '../party_creation_screens/party_creation_screen_details.dart';
import '../party_creation_screens/party_creation_screen_specifics.dart';
import '../../../data/models/party.dart';
import '../../../services/FirebaseFirestoreService.dart';
import '../../../services/FirebaseStorageService.dart';

import 'package:provider/provider.dart';

class PartyCreationScreensManager extends StatefulWidget {
  final User userData;
  PartyCreationScreensManager({Key key, this.userData}) : super(key: key);

  @override
  _PartyCreationScreensManagerState createState() =>
      _PartyCreationScreensManagerState();
}

enum CreationScreen {
  Title,
  Specifics,
  Detail,
}

class _PartyCreationScreensManagerState
    extends State<PartyCreationScreensManager> {
  CreationScreen _currentScreen = CreationScreen.Title;

  Map<String, dynamic> _newParty = {
    'timeOfTheParty': null,
    'address': '',
    'drinks': Drinks.BringYourOwnBooze,
    'imageUrl': '',
    'music': Music.House,
    'description': '',
    'peopleComing': [],
    'title': '',
    'partyCreatorUsername': '',
    'partyCreatorImageUrl': '',
    'likes': [],
    'createdAt': '',
    'coordinates': {
      'latitude': null,
      'longitude': null,
    },
    'partyCreatorId': '',
    'slogan': '',
  };

  DateTime _datePicked;
  TimeOfDay _timePicked;

  void _changeScreen(CreationScreen screenToChangeTo) {
    setState(() {
      _currentScreen = screenToChangeTo;
    });
  }

  Future<void> _tryToAddParty() async {
    final FirebaseFirestoreService _firestoreService =
        Provider.of<FirebaseFirestoreService>(context, listen: false);

    _newParty['timeOfTheParty'] = _datePicked
        .add(Duration(
          hours: _timePicked.hour,
          minutes: _timePicked.minute,
        ))
        .toIso8601String();

    _newParty['partyCreatorUsername'] = widget.userData.username;
    _newParty['partyCreatorImageUrl'] = widget.userData.imageUrl;
    _newParty['partyCreatorId'] = widget.userData.uid;
    _newParty['drinks'] =
        Drinks.values.indexWhere((element) => element == _newParty['drinks']);
    _newParty['music'] =
        Music.values.indexWhere((element) => element == _newParty['music']);

    _newParty['createdAt'] = DateTime.now().toIso8601String();

    try {
      final _partyId =
          await _firestoreService.storePartyInACollection(_newParty);

      widget.userData.createdPartyIds.add(_partyId);

      final _partyImageDownloadUrl =
          await Provider.of<FirebaseStorageService>(context, listen: false)
              .storePartyImage(File(_newParty['imageUrl']), _partyId);
      await _firestoreService.updatePartyImageUrl(
          _partyId, _partyImageDownloadUrl);

      await _firestoreService.updateUserCreatedParties(
          widget.userData.createdPartyIds, widget.userData.uid);
      File(_newParty['imageUrl']).delete();
      Navigator.of(context).pop();
    } catch (error) {
      print(error.toString());
    }
  }

  void _saveSpecifics(Map<String, dynamic> specificsData) {
    if (specificsData['address'] != '')
      _newParty['address'] = specificsData['address'];
    if (specificsData['coordinates'] != null)
      _newParty['coordinates'] = specificsData['coordinates'];

    if (specificsData['time'] != null) _timePicked = specificsData['time'];
    if (specificsData['date'] != '')
      _datePicked = DateTime.parse(specificsData['date']);

    _newParty['drinks'] = specificsData['drinks'];
    _newParty['music'] = specificsData['music'];
  }

  Widget _buildCurrentScreen() {
    if (_currentScreen == CreationScreen.Title) {
      return PartyCreationScreenTitle(
        initialValueText: _newParty['title'],
        initialValuePicture: _newParty['imageUrl'],
        onNext: (titlePictureData) {
          if (titlePictureData['title'] != '')
            _newParty['title'] = titlePictureData['title'];
          if (titlePictureData['imageUrl'] != '')
            _newParty['imageUrl'] = titlePictureData['imageUrl'];
          _changeScreen(
              CreationScreen.values.elementAt(_currentScreen.index + 1));
        },
      );
    } else if (_currentScreen == CreationScreen.Specifics) {
      return PartyCreationScreenSpecifics(
        initialData: {
          'address': _newParty['address'],
          'drinks': _newParty['drinks'],
          'music': _newParty['music'],
          'date': _datePicked?.toIso8601String() ?? '',
          'time': _timePicked,
          'coordinates':
              _newParty['coordinates'], //LatLng(latitude: 20, longitude: 20),
        },
        onNext: (specificsData) {
          _saveSpecifics(specificsData);
          _changeScreen(
              CreationScreen.values.elementAt(_currentScreen.index + 1));
        },
        onPrevious: (specificsData) {
          _saveSpecifics(specificsData);
          _changeScreen(
              CreationScreen.values.elementAt(_currentScreen.index - 1));
        },
      );
    } else {
      return PartyCreationScreenDetails(
        descriptionInitialValue: _newParty['description'],
        sloganInitialValue: _newParty['slogan'],
        onNext: (slogan, description) async {
          _newParty['slogan'] = slogan;
          _newParty['description'] = description;
          await _tryToAddParty();
        },
        onPrevious: (slogan, description) {
          _newParty['slogan'] = slogan;
          _newParty['description'] = description;
          _changeScreen(
              CreationScreen.values.elementAt(_currentScreen.index - 1));
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print('TITLE:         ' + _newParty['title']);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: _buildCurrentScreen(),

        //   bottom: 40,
        //   left: _media.size.width / 4.6,
        // ),
      ),
    );
  }
}
