import '../../data/models/lat_long.dart';
import 'party.dart';

class DummyParties {
  static final parties = [
    new Party(
      coordinates: LatLng(
        latitude: 100,
        longitude: 100,
      ),
      createdAt: DateTime.now(),
      address: "Ulica kralja Petra Svačića, 1c",
      description:
          "Ovo je moja zaba neka koju sam ja eto napravila jer sam demosica i etoooo takoo pomalo se druskat hocuu i etoooo.",
      drinks: Drinks.BringYourOwnBooze,
      imageUrl: '',
      likes: [],
      music: Music.TurboFolk,
      peopleComing: [],
      partyCreatorId: 'pUONmP4XX3NzR44oDa69NxOinA43',
      partyCreatorImageUrl:
          "https://firebasestorage.googleapis.com/v0/b/partyproject-93b33.appspot.com/o/userImages%2FpUONmP4XX3NzR44oDa69NxOinA43%2Favatar.png?alt=media&token=df83952a-30b4-4f4b-8c58-782d019cc4aa",
      partyCreatorUsername: 'ivan',
      timeOfTheParty: DateTime.now().add(Duration(days: 4)),
      title: 'Booze Party',
    ),
    new Party(
      coordinates: LatLng(
        latitude: 100,
        longitude: 100,
      ),
      createdAt: DateTime.now(),
      address: "Adresa tu neka sada, 26",
      description:
          "Ovo je moja zaba neka koju sam ja eto napravila jer sam demosica i etoooo takoo pomalo se druskat hocuu i etoooo.",
      drinks: Drinks.BringYourOwnBooze,
      imageUrl: '',
      likes: [],
      music: Music.TurboFolk,
      peopleComing: [],
      partyCreatorId: 'pUONmP4XX3NzR44oDa69NxOinA43',
      partyCreatorImageUrl:
          "https://firebasestorage.googleapis.com/v0/b/partyproject-93b33.appspot.com/o/userImages%2F0in44BgHUDPa3Jjuf8NAsTf2piF3%2Favatar.png?alt=media&token=6b880300-d238-426a-83d4-3e2e01d49c19",
      partyCreatorUsername: 'ivan',
      timeOfTheParty: DateTime.now().add(Duration(days: 4)),
      title: 'Chillaiona',
    ),
  ];
}
