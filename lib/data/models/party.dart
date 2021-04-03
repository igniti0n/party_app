import 'package:flutter/cupertino.dart';

import './lat_long.dart';

enum Drinks {
  BringYourOwnBooze,
  AvailableToBuy,
  FreeDrinks,
}

enum Music {
  DJ,
  Techno,
  House,
  TurboFolk,
  Clasic,
}

// THIS IS AN ADDED COMMENT

class Party {
  @required
  final DateTime timeOfTheParty;
  @required
  final String address;
  @required
  final LatLng coordinates;
  @required
  final Drinks drinks;
  @required
  final Music music;
  List<dynamic> peopleComing;
  List<dynamic> likes;
  @required
  final DateTime createdAt;
  @required
  final String imageUrl;
  final String description;
  final String title;
  final String partyCreatorUsername;
  final String partyCreatorImageUrl;
  final String partyCreatorId;
  final String slogan;
  final String partyId;

  Party({
    this.timeOfTheParty,
    this.address,
    this.drinks,
    this.imageUrl,
    this.peopleComing,
    this.music,
    this.description,
    this.title,
    this.partyCreatorUsername,
    this.partyCreatorImageUrl,
    this.likes = const [],
    this.createdAt,
    this.coordinates,
    this.slogan,
    this.partyCreatorId,
    this.partyId,
  });

  factory Party.fromMap(Map<String, dynamic> inputMap) {
    if (inputMap == null)
      return null;
    else {
      return new Party(
        timeOfTheParty: DateTime.parse(inputMap['timeOfTheParty']),
        address: inputMap['address'],
        drinks: Drinks.values.elementAt(inputMap['drinks']),
        music: Music.values.elementAt(inputMap['music']),
        peopleComing: inputMap['peopleComing'],
        imageUrl: inputMap['imageUrl'],
        description: inputMap['description'],
        title: inputMap['title'],
        partyCreatorUsername: inputMap['partyCreatorUsername'],
        partyCreatorImageUrl: inputMap['partyCreatorImageUrl'],
        likes: inputMap['likes'],
        createdAt: DateTime.parse(inputMap['createdAt']),
        coordinates: LatLng.fromMap(inputMap['coordinates']),
        partyCreatorId: inputMap['partyCreatorId'],
        slogan: inputMap['slogan'],
        partyId: inputMap['partyId'],
      );
    }
  }

  static Map<String, dynamic> toMap(Party party) {
    return party == null
        ? null
        : {
            'timeOfTheParty': party.timeOfTheParty.toIso8601String(),
            'address': party.address,
            'drinks': party.drinks.index,
            'imageUrl': party.imageUrl,
            'peopleComing': party.peopleComing,
            'music': party.music.index,
            'description': party.description,
            'title': party.title,
            'partyCreatorUsername': party.partyCreatorUsername,
            'partyCreatorImageUrl': party.partyCreatorImageUrl,
            'likes': party.likes,
            'createdAt': party.createdAt.toIso8601String(),
            'coordinates': LatLng.toMap(party.coordinates),
            'partyCreatorId': party.partyCreatorId,
            'slogan': party.slogan,
          };
  }
}
