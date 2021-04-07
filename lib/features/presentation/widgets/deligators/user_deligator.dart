import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../constants.dart';
import '../../../data/respositories/user_respository_impl.dart';
import '../../../data/models/user.dart';
import 'party_delegator.dart';
import '../../screens/auth_screens/auth_signup_continue_screen.dart';
import '../../../data/datasources/FirebaseFirestoreService.dart';

class UserDeligator extends StatelessWidget {
  final String uid;
  UserDeligator({Key key, this.uid}) : super(key: key);
  static const routeName = '/userDeligator';

  final UserRepository _userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    print('::::USER DELIGATOR::::');
    return StreamBuilder<Map<String, dynamic>>(
        stream: Provider.of<FirebaseFirestoreService>(context, listen: false)
            .getUserDataStream(uid),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState != ConnectionState.active)
            return Constants.displayLoadingSpinner();
          _userRepository.setUser(User.fromMap(snapshot.data, uid));

          log("user data stream changed");
          log("${_userRepository.user}");

          if (snapshot.hasData) {
            print("::::DATA FROM USER FROM FIRESTORE: ${snapshot.data}");
            return ChangeNotifierProvider(
              create: (_) => _userRepository,
              builder: (ctx, _) {
                return const PartyDelegator();
              },
            );
          } else {
            return SignupScreen(
              uid: uid,
            );
          }
        });
  }
}
