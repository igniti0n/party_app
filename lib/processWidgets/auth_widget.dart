import 'package:flutter/material.dart';

import '../processWidgets/user_deligator.dart';
import '../screens/auth_screens/auth_login_screen.dart';
import '../widgets/loading_widget.dart';
import '../services/FirebaseAuthService.dart';

import 'package:firebase_auth/firebase_auth.dart' as auth show User;
import 'package:provider/provider.dart';

class AuthenticationWidget extends StatelessWidget {
  const AuthenticationWidget({Key key, this.snapshot}) : super(key: key);
  final AsyncSnapshot<auth.User> snapshot;

  @override
  Widget build(BuildContext context) {
    print('::::BUILDING AUTHENTICATION WIDGET::::');
    if (snapshot.connectionState == ConnectionState.active) {
      // if (snapshot.data != null)
      //

      return snapshot.hasData
          ? UserDeligator(uid: snapshot.data.uid)
          : AuthLoginScreen();
    }
    return Scaffold(
      body: Center(
        child: LoadingWidget(),
      ),
    );
  }
}
