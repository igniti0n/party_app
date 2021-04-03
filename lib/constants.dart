import 'package:flutter/material.dart';

class Constants {
  static const kDartkColor = Color.fromRGBO(255, 255, 255, 0.85);
  static const kButtonColor = Color.fromRGBO(145, 145, 255, 1);
  static const kButtonBorderColor = Color.fromRGBO(68, 56, 56, 1);
  static const kAuthTextColor = Color.fromRGBO(117, 107, 107, 1);
  static const kAuthBoxColor = Color.fromRGBO(243, 241, 241, 1);
  static const kDarkGeneralColor = Color.fromRGBO(42, 31, 31, 1);
  static const kHelperTextColor = Color.fromRGBO(128, 124, 124, 1);
  static const kPurpleButtonTextColor = Color.fromRGBO(68, 42, 42, 1);

  static const String textUserAddingScreen =
      "Type in your friends party ID to add them as a Party Friend !";
  static const String textPartyCreationTitle =
      "Set a short cool/fun name for your party ! Name can be anything, it does not need to explain the party, you can add description later !";
  static const String textPartyCreationImage =
      "Pick a header image that best represents your party ! You can create custom posters and use them from gallery, or just take a random picture of whatever, go nuts !";
  static const String textPartyCreationSpecifics =
      "Here you can set the party location, date of the party, what type of music will be there, do people need to bring their own dinks, and base amount of people !";
  static const String textPartyCreationSpecificsBlock =
      "Base amount of people represents people that are 100% coming, like you and your friends !";
  static const String textPartyCreationDescription =
      "Use party description to describe all other things that are not mentioned by party specifics. Things like where exactly is the location of your party ( drinking on a bench in a park for eg.), if you want to have some crazy rules for your party, does your party have some reason like birthday….";

  static void displaySnackbar(BuildContext ctx, String message) {
    Scaffold.of(ctx).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  static Widget displayLoadingSpinner() {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }

  static List<Widget> buildBackground() {
    return <Widget>[
      Container(
        width: double.infinity,
        height: double.infinity,
        child: Image.asset(
          'assets/images/pattern.png',
          fit: BoxFit.cover,
        ),
      ),
      Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: kDartkColor),
        child: null,
      ),
    ];
  }
}
